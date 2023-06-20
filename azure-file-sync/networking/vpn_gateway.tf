resource "azurerm_public_ip" "vpngw" {
  name                = "vpngw-ip"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "this" {
  name                = "vpngw-${var.suffix}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "GatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpngw.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway.id
  }

  vpn_client_configuration {
    address_space        = ["172.168.0.0/24"]
    vpn_auth_types       = ["Certificate"]
    vpn_client_protocols = ["OpenVPN"]

    root_certificate {
      name             = "DigiCert-Federated-ID-Root-CA"
      public_cert_data = <<EOF
MIIC5zCCAc+gAwIBAgIQGplIvZnM3oZMzBr/7L6C5zANBgkqhkiG9w0BAQsFADAW
MRQwEgYDVQQDDAtQMlNSb290Q2VydDAeFw0yMjEyMDEwODQ1MzBaFw0yMzEyMDEw
OTA1MzBaMBYxFDASBgNVBAMMC1AyU1Jvb3RDZXJ0MIIBIjANBgkqhkiG9w0BAQEF
AAOCAQ8AMIIBCgKCAQEA3sGjayzv8BHIIfnSbrrEsxBV885Lr2kGHvF5MKBFM+Hm
SkOdmKc3p/fZ5vr4O4KCAfG3uNPv4FjCalQU1nA2TQluxElogsOUqZkvEdXYBNHd
JPfFBcEOKeC7rVORRB4LL7d89AwWoxajvO3xLOQJIAvxZZpfgmFpkyCfgPBxiqUe
ePfoZriowOeWPN9F8QG08qr9SMEihJdnmU3U6/20PzMpMpn9w8i3Stu8y7nMofex
odkuhGEwOQNrmrOeLjKJzZXEv00Mv1dweG8YElfiYzB8eQbq7zCvPkazMzvid+CV
MbVEYnEU6jIIIIZC8pUZ7I1K7xkSDWtWEK1Pk7ltrQIDAQABozEwLzAOBgNVHQ8B
Af8EBAMCAgQwHQYDVR0OBBYEFF5ACgnUHptfYWPsX2KG5r8o7wPXMA0GCSqGSIb3
DQEBCwUAA4IBAQBtCMAZx3jihot2M8I1kc0xdb5HkObrnhegOkhWes2l34HDXWTL
NT56PsJhBCMlriE2kRDAI5ZiOt920spi95Th+hKx7GdStUIaZcxB0GxnRkGTwpQS
mkFzwsZJmz2A/owB86Q+OTsc6CkPiYjk674yfLjcrNODtSRHF7a3SBO4fjzq/kSR
zTx8sCJgj9PPHYamtuXAjJgF+pW6Cq6cOrQhzzoPiawWLghn0ghOnX6uFc76wNqX
Sr868FzMWj38/v654C8f8joc0HtuKa3+QiSgVQKvj8Aplfc+GakQsDZ6N/FymzlQ
5SemGxinaBNdwQgdPr77iB8qQnlk1RN7zwk2
EOF
    }
  }
}
