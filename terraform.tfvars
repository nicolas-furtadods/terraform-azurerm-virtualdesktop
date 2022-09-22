##########################################################################
# 0. Global Configuration
##########################################################################

# Working subscription ID. Resources which may need to be created will use this subscription.
# A shared subscription is the wise choice for production use.
subscription_id = "428a61c1-c02e-4dfe-a07b-c03820269e59"

# Name of the resource group which should hold the resources
resource_group_name = "rg-in-sbx-nfurtado-001"

#Core tag to be used on core resources, in order to not be overwritten by the governance
tags = {
  "Application"        = "azure-poc",
  "Referent"           = "team-devsecops",
  "Creator"            = "terraform"
  "Entity-Billing"     = "dsi-rvd"
  "Entity-Operational" = "pit"
  "Environment"        = "sbx"
  "Provider"           = "azr"
}

# Enter the application which set the whole governance.
application = "virtualdesktop"

# Enter the environment which will be used by policies and tags
environment = "sbx"

# "Enter the zone which will be used by resources (in,ex,cm)
technical_zone = "cm"

# Enter the location to configure
location = "westeurope"
