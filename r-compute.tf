resource "azurerm_virtual_machine_extension" "aad" {
  for_each                   = local.virtual_machines_all
  name                       = "${each.value.name}-domainjoin"
  virtual_machine_id         = each.value.id
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADLoginForWindows"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true

  depends_on = [
    azurerm_virtual_desktop_host_pool_registration_info.host_pool_registration
  ]
}

resource "azurerm_virtual_machine_extension" "vmext_dsc" {
  for_each                   = local.virtual_machines_all
  name                       = "${each.value.name}-avd_dsc"
  virtual_machine_id         = each.value.id
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.73"
  auto_upgrade_minor_version = true

  settings = <<-SETTINGS
    {
      "modulesUrl": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_3-10-2021.zip",
      "configurationFunction": "Configuration.ps1\\AddSessionHost",
      "properties": {
        "HostPoolName":"${azurerm_virtual_desktop_host_pool.host_pool[each.value.application_name].name}"
      }
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
  {
    "properties": {
      "registrationInfoToken": "${azurerm_virtual_desktop_host_pool_registration_info.host_pool_registration[each.value.application_name].token}"
    }
  }
PROTECTED_SETTINGS

  depends_on = [
    azurerm_virtual_desktop_host_pool_registration_info.host_pool_registration
  ]
}
