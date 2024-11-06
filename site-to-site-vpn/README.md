# Site to Site VPN

## Prerequisites
```shell
export ARM_SUBSCRIPTION_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
export ARM_TENANT_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

## Architecture


## Execution
```sh
$ terraform apply -auto-approve
var.aws_virtual_private_gateway_public_ip
  Enter a value:   (Enter)

var.pre_shared_key
  Enter a value:    (Enter)

Outputs:

azure_vpn_gateway_public_ip = "172.207.236.208"
```


## Execution
```sh
$ terraform apply -auto-approve
var.aws_virtual_private_gateway_public_ip
  Enter a value: xxx.xxx.xxx.xxx (get from aws)  (Enter)

var.pre_shared_key
  Enter a value: xxxxxxxxxxxx (get from aws)  (Enter)

Outputs:

azure_vpn_gateway_public_ip = "172.207.236.208"
```