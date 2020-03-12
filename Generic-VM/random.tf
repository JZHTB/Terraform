## The random password generation

resource "random_string" "vm_rndstr" {
  special = true
  upper   = true
  lower   = true
  number  = true
  length  = 16
}
