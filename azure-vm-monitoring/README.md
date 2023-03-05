# Azure VM Monitoring

## Architecture
![img](./docs/architecture.png)

## Target
- Windows 2016
- Windows 2022
- Ubuntu 2004
- Redhat Linux Enterprise 8.6

## Create Environment
```
$ export ARM_SUBSCRIPTION_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
$ export ARM_TENANT_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

$ terraform init
$ terraform apply -auto-approve

Outputs:
load_balancer_public_ip = "xx.xx.xx.xx"
log_analytics_workspace_name = "workspace-xxxxxxxx"
rhel_vm_name = "rhel86-xxxxxxxx"
ubuntu_vm_name = "ubuntu-2004-xxxxxxxx"
win2016_vm_name = "win2016-xxxxxxxx"
win2022_vm_name = "win2022-xxxxxxxx"
```

## Create Sample Data for DCR
```
.\LogGenerator.ps1 -Log "sample_access.log" -Type "file" -Output "data_sample.json"
```