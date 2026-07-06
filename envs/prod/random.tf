resource "random_password" "db_password" {

  length  = 20

  special = true

  override_special = "!@#$%^&*()-_=+"

}