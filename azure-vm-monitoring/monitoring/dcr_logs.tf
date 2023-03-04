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
