resource "random_string" "naming_random_suffix" {
  length  = 8
  special = false
  upper   = false
  lower   = false
}