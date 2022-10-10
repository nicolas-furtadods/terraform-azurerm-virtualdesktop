##########################################################################
# 1. Azure Virtual Desktop
##########################################################################
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}
data "azuread_user" "aad_user" {
  for_each            = toset(var.avd_users)
  user_principal_name = format("%s", each.key)
}

data "azurerm_role_definition" "desktop_user" { # access an existing built-in role
  name = local.desktop_user_role
}

data "azurerm_role_definition" "vm_user" { # access an existing built-in role
  name = local.vm_user_role
}

resource "azuread_group" "aad_group" {
  display_name     = local.avd_group_name
  security_enabled = true
}

resource "azuread_group_member" "aad_group_member" {
  for_each         = data.azuread_user.aad_user
  group_object_id  = azuread_group.aad_group.id
  member_object_id = each.value["id"]
}

resource "azurerm_role_assignment" "desktop_user" {
  scope              = data.azurerm_resource_group.rg.id
  role_definition_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}${data.azurerm_role_definition.desktop_user.id}"
  principal_id       = azuread_group.aad_group.id
}

resource "azurerm_role_assignment" "vm_user" {
  scope              = data.azurerm_resource_group.rg.id
  role_definition_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}${data.azurerm_role_definition.vm_user.id}"
  principal_id       = azuread_group.aad_group.id
}

##########################################################################
# 2. Azure Virtual Desktop - Host Pool
##########################################################################
resource "azurerm_virtual_desktop_host_pool" "host_pool" {
  for_each            = var.applications
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  name                 = "${local.virtual_desktop_host_pool_prefix}-${local.naming_noapplication}-${each.key}-001"
  friendly_name        = "${local.virtual_desktop_host_pool_prefix}-${local.naming_noapplication}-${each.key}-001"
  validate_environment = lookup(var.host_pool_properties, "validate_environment", false)
  start_vm_on_connect  = lookup(var.host_pool_properties, "start_vm_on_connect", false)
  #custom_rdp_properties    = lookup(var.host_pool_properties,"custom_rdp_properties","drivestoredirect:s:*;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;usbdevicestoredirect:s:*;enablecredsspsupport:i:1;redirectwebauthn:i:1;use multimon:i:1")
  description                      = lookup(var.host_pool_properties, "description", "Standard Terraform Description for the host pool created with a generic property.")
  type                             = lookup(var.host_pool_properties, "type", local.host_pool_type)
  maximum_sessions_allowed         = lookup(var.host_pool_properties, "type", local.host_pool_type) == "Pooled" ? lookup(var.host_pool_properties, "maximum_sessions_allowed", 50) : null
  personal_desktop_assignment_type = lookup(var.host_pool_properties, "type", local.host_pool_type) == "Personnal" ? lookup(var.host_pool_properties, "personal_desktop_assignment_type", "Automatic") : null
  load_balancer_type               = lookup(var.host_pool_properties, "load_balancer_type", "BreadthFirst")
  scheduled_agent_updates {
    enabled = true
    schedule {
      day_of_week = "Saturday"
      hour_of_day = 2
    }
  }
}

resource "azurerm_virtual_desktop_host_pool_registration_info" "host_pool_registration" {
  for_each        = var.applications
  hostpool_id     = azurerm_virtual_desktop_host_pool.host_pool[each.key].id
  expiration_date = var.expiration_date
}

##########################################################################
# 3. Azure Virtual Desktop - Application Group
##########################################################################
resource "azurerm_virtual_desktop_application_group" "remoteapp" {
  for_each            = var.applications
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  name                         = "${local.virtual_desktop_application_prefix}-${local.naming_noapplication}-${each.key}-001"
  type                         = lookup(var.application_group_properties, "type", "Desktop")
  host_pool_id                 = azurerm_virtual_desktop_host_pool.host_pool[each.key].id
  friendly_name                = lookup(var.application_group_properties, "friendly_name", "Application Group")
  default_desktop_display_name = each.value.display_name
  description                  = lookup(var.application_group_properties, "description", "Acceptance Test: An application group")
}

##########################################################################
# 4. Azure Virtual Desktop - Workspace
##########################################################################

resource "azurerm_virtual_desktop_workspace" "workspace" {
  name                = "${local.virtual_desktop_workspace_prefix}-${local.naming_noapplication}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  friendly_name = lookup(var.workspace_properties, "friendly_name", "AVD Workspace")
  description   = lookup(var.workspace_properties, "description", "A description of my workspace")
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "workspaceremoteapp" {
  for_each             = var.applications
  workspace_id         = azurerm_virtual_desktop_workspace.workspace.id
  application_group_id = azurerm_virtual_desktop_application_group.remoteapp[each.key].id
}