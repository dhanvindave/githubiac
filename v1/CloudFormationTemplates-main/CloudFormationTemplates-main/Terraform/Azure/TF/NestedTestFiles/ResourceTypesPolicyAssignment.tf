data "azurerm_billing_enrollment_account_scope" "example" {
  billing_account_name    = "1234567890"
  enrollment_account_name = "0123456"
}

resource "azurerm_subscription" "example" {
  subscription_name = "My Example EA Subscription"
  billing_scope_id  = data.azurerm_billing_enrollment_account_scope.example.id
}

resource "azurerm_subscription_policy_assignment" "example" {
  name                 = "example"
  policy_definition_id = azurerm_policy_definition.example.id
  subscription_id      = data.azurerm_subscription.current.id
}

resource "azurerm_policy_definition" "policy" {
  name         = "accTestPolicy"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Not allowed resource types"
}