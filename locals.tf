locals {
  ##########################################################################
  # 0. Global Configuration
  ##########################################################################
  naming               = replace(lower("${var.technical_zone}-${var.environment}-${var.application}"), " ", "")
  naming_noapplication = replace(lower("${var.technical_zone}-${var.environment}"), " ", "")

}