# ----------------------------------------------------------------------------------------------
# Azure Monitor Data Collection Rule - Windows Server Event Log
# ----------------------------------------------------------------------------------------------
resource "azurerm_monitor_data_collection_rule" "win_eventlog" {
  name                = "MSVMI-Windows-EventLogs"
  description         = "data collection rule"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  kind                = "Windows"

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.this.id
      name                  = "la-777488146"
    }
  }

  data_flow {
    streams      = ["Microsoft-Event"]
    destinations = ["la-777488146"]
  }

  data_sources {
    windows_event_log {
      name    = "eventLogsDataSource"
      streams = ["Microsoft-Event"]
      x_path_queries = [
        "Application!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=0)]]",
        "Security!*[System[(band(Keywords,13510798882111488))]]",
        "System!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=0)]]"
      ]
    }
  }
}

# ----------------------------------------------------------------------------------------------
# Azure Monitor Data Collection Rule Association - Windows Server 2016
# ----------------------------------------------------------------------------------------------
resource "azurerm_monitor_data_collection_rule_association" "dcr_win2016_eventlog" {
  name                    = "dcr-win2016-eventlog-${var.suffix}"
  target_resource_id      = var.win2016_vm_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.win_eventlog.id
}

# ----------------------------------------------------------------------------------------------
# Azure Monitor Data Collection Rule Association - Windows Server 2022
# ----------------------------------------------------------------------------------------------
resource "azurerm_monitor_data_collection_rule_association" "dcr_win2022_eventlog" {
  name                    = "dcr-win2022-eventlog-${var.suffix}"
  target_resource_id      = var.win2022_vm_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.win_eventlog.id
}

# ----------------------------------------------------------------------------------------------
# Azure Monitor Data Collection Rule - Linux System Log
# ----------------------------------------------------------------------------------------------
resource "azurerm_monitor_data_collection_rule" "linux_syslogs" {
  name                = "MSVMI-Linux-SysLogs"
  description         = "data collection rule"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  kind                = "Linux"

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.this.id
      name                  = "la-1508762574"
    }
  }

  data_flow {
    streams      = ["Microsoft-Syslog"]
    destinations = ["la-1508762574"]
  }

  data_sources {
    syslog {
      facility_names = [
        "auth",
        "authpriv",
        "cron",
        "daemon",
        "mark",
        "kern",
        "local0",
        "local1",
        "local2",
        "local3",
        "local4",
        "local5",
        "local6",
        "local7",
        "lpr",
        "mail",
        "news",
        "syslog",
        "user",
        "uucp",
      ]
      log_levels = [
        "Debug",
        "Info",
        "Notice",
        "Warning",
        "Error",
        "Critical",
        "Alert",
        "Emergency",
      ]
      name = "sysLogsDataSource-1688419672"
      streams = [
        "Microsoft-Syslog",
      ]
    }

  }
}

# ----------------------------------------------------------------------------------------------
# Azure Monitor Data Collection Rule Association - Redhat Enterprise Linux 8.6
# ----------------------------------------------------------------------------------------------
resource "azurerm_monitor_data_collection_rule_association" "dcr_rhel_86_syslog" {
  name                    = "dcr-rhel86-syslog-${var.suffix}"
  target_resource_id      = var.rhel_86_vm_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.linux_syslogs.id
}

# ----------------------------------------------------------------------------------------------
# Azure Monitor Data Collection Rule Association - Ubuntu 20.04
# ----------------------------------------------------------------------------------------------
resource "azurerm_monitor_data_collection_rule_association" "dcr_ubuntu_2004_syslog" {
  name                    = "dcr-ubuntu-syslog-${var.suffix}"
  target_resource_id      = var.ubuntu_2004_vm_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.linux_syslogs.id
}

# ----------------------------------------------------------------------------------------------
# Azure Monitor Data Collection Rule - Linux Custom Logs
# ----------------------------------------------------------------------------------------------
resource "azapi_resource" "linux_custom_log" {
  depends_on = [
    azapi_resource.table_nginx_access
  ]
  provider  = azapi
  type      = "Microsoft.Insights/dataCollectionRules@2021-09-01-preview"
  name      = "MSVMI-Linux-CustomLogs"
  location  = var.resource_group_location
  parent_id = var.resource_group_id

  body = jsonencode({
    kind = "Linux"
    properties = {
      dataCollectionEndpointId = "${azurerm_monitor_data_collection_endpoint.linux.id}"
      streamDeclarations = {
        Custom-NginxAccessLog_CL = {
          columns = [
            {
              name = "TimeGenerated",
              type = "datetime"
            },
            {
              name = "RawData",
              type = "string"
            }
          ]
        }
      },
      dataFlows = [
        {
          destinations = [
            "la-1234567"
          ],
          streams = [
            "Custom-NginxAccessLog_CL"
          ],
          transformKql = <<EOT
source | extend TimeGenerated = now() | parse RawData with RemoteAddress:string ' ' * ' ' * ' [' * '] "' RequestType:string " " Resource:string " " * '" ' ResponseCode:string ' ' * ' "' HttpReferer:string '" "' UserAgent:string '"'
          EOT
          outputStream = "Custom-NginxAccessLog_CL"
        }
      ]
      dataSources = {
        logFiles = [
          {
            filePatterns = [
              "/var/log/nginx/access*.log"
            ]
            format = "text"
            name   = "NginxAccessLog_CL"
            settings = {
              text = {
                recordStartTimestampFormat = "yyyy-MM-ddTHH:mm:ssK"
              }
            }
            streams = [
              "Custom-NginxAccessLog_CL"
            ]
          }
        ]
      }
      description = "string"
      destinations = {
        logAnalytics = [
          {
            name                = "la-1234567"
            workspaceResourceId = "${azurerm_log_analytics_workspace.this.id}"
          }
        ]
      }
    }
  })

  response_export_values = ["id"]
}

# ----------------------------------------------------------------------------------------------
# Azure Monitor Data Collection Rule Association - Ubuntu 20.04
# ----------------------------------------------------------------------------------------------
resource "azurerm_monitor_data_collection_rule_association" "dcr_ubuntu_customlog" {
  name                    = "dcr-ubuntu-customlog-${var.suffix}"
  target_resource_id      = var.ubuntu_2004_vm_id
  data_collection_rule_id = jsondecode(azapi_resource.linux_custom_log.output).id
}

# ----------------------------------------------------------------------------------------------
# Azure Monitor Data Collection Rule - Linux Process
# ----------------------------------------------------------------------------------------------
resource "azapi_resource" "dcr_linux_process" {
  depends_on = [
    azapi_resource.table_linux_process
  ]
  provider  = azapi
  type      = "Microsoft.Insights/dataCollectionRules@2021-09-01-preview"
  name      = "MSVMI-Linux-Processes"
  location  = var.resource_group_location
  parent_id = var.resource_group_id

  body = jsonencode({
    kind = "Linux"
    properties = {
      dataCollectionEndpointId = "${azurerm_monitor_data_collection_endpoint.linux.id}"
      streamDeclarations = {
        Custom-LinuxProcess_CL = {
          columns = [
            {
              name = "TimeGenerated",
              type = "datetime"
            },
            {
              name = "RawData",
              type = "string"
            }
          ]
        }
      },
      dataFlows = [
        {
          streams = [
            "Custom-LinuxProcess_CL"
          ],
          destinations = [
            "la-1234567"
          ],
          transformKql = "source | extend datas = parse_json(RawData) | project TimeGenerated = todatetime(datas.timestamp), User = datas.user, Pid = datas.pid, CPUUtilization = datas.cpu_utilization, MemoryUtilization = datas.memory_utilization, Command = datas.command, Computer = datas.Computer"
          outputStream = "Custom-LinuxProcess_CL"
        }
      ]
      dataSources = {
        logFiles = [
          {
            filePatterns = [
              "/var/log/process*.log"
            ]
            format = "text"
            name   = "LinuxProcess_CL"
            settings = {
              text = {
                recordStartTimestampFormat = "yyyy-MM-ddTHH:mm:ssK"
              }
            }
            streams = [
              "Custom-LinuxProcess_CL"
            ]
          }
        ]
      }
      description = "string"
      destinations = {
        logAnalytics = [
          {
            name                = "la-1234567"
            workspaceResourceId = "${azurerm_log_analytics_workspace.this.id}"
          }
        ]
      }
    }
  })

  response_export_values = ["id"]
}

# ----------------------------------------------------------------------------------------------
# Azure Monitor Data Collection Rule Association - Ubuntu 20.04
# ----------------------------------------------------------------------------------------------
resource "azurerm_monitor_data_collection_rule_association" "ubuntu_process" {
  name                    = "dcr-ubuntu-process-${var.suffix}"
  target_resource_id      = var.ubuntu_2004_vm_id
  data_collection_rule_id = jsondecode(azapi_resource.dcr_linux_process.output).id
}

# ----------------------------------------------------------------------------------------------
# Azure Monitor Data Collection Rule Association - RHEL 8.6
# ----------------------------------------------------------------------------------------------
resource "azurerm_monitor_data_collection_rule_association" "rhel_process" {
  name                    = "dcr-rhel-process-${var.suffix}"
  target_resource_id      = var.rhel_86_vm_id
  data_collection_rule_id = jsondecode(azapi_resource.dcr_linux_process.output).id
}

