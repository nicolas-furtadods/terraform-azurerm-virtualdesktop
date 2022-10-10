locals {
  ##########################################################################
  # 0. Global Configuration
  ##########################################################################
  naming               = replace(lower("${var.technical_zone}-${var.environment}-${var.application}"), " ", "")
  naming_noapplication = replace(lower("${var.technical_zone}-${var.environment}"), " ", "")

  virtual_machines_tmp = flatten([
    for k, apps in var.applications : [
      for i, machine in apps.virtual_machines : {
        name             = machine.name
        id               = machine.id
        application_name = k
      }
    ]
  ])
  virtual_machines_all = {
    for machine in local.virtual_machines_tmp : machine.name => machine
  }

  ##########################################################################
  # 3. Azure Virtual Desktop
  ##########################################################################
  virtual_desktop_host_pool_prefix   = "avd-hp"
  virtual_desktop_application_prefix = "avd-dag"
  virtual_desktop_workspace_prefix   = "avd-wk"
  host_pool_type                     = "Pooled"

  desktop_user_role = "Desktop Virtualization User"
  vm_user_role      = "Virtual Machine User Login"

  avd_group_name = "Azure Virtual Desktop"
}