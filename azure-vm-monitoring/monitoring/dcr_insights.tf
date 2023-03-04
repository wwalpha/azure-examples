# ----------------------------------------------------------------------------------------------
# Azure Monitor Data Collection Rule - VM Insights
# ----------------------------------------------------------------------------------------------
resource "azurerm_monitor_data_collection_rule" "insights" {
  name                = "MSVMI-Insights"
  description         = "Data collection rule for VM Insights."
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.this.id
      name                  = "VMInsightsPerf-Logs-Dest"
    }
  }

  data_flow {
    streams      = ["Microsoft-InsightsMetrics"]
    destinations = ["VMInsightsPerf-Logs-Dest"]
  }

  data_flow {
    streams      = ["Microsoft-ServiceMap"]
    destinations = ["VMInsightsPerf-Logs-Dest"]
  }

  data_sources {
    performance_counter {
      counter_specifiers = [
        "\\VmInsights\\DetailedMetrics",
      ]
      name                          = "VMInsightsPerfCounters"
      sampling_frequency_in_seconds = 60
      streams = [
        "Microsoft-InsightsMetrics",
      ]
    }

    extension {
      name           = "DependencyAgentDataSource"
      extension_name = "DependencyAgent"
      streams        = ["Microsoft-ServiceMap"]
    }
  }
}

# ----------------------------------------------------------------------------------------------
# Azure Monitor Data Collection Rule Association - Windows Server 2016
# ----------------------------------------------------------------------------------------------
resource "azurerm_monitor_data_collection_rule_association" "dcr_insights_win2016" {
  depends_on              = [azurerm_monitor_data_collection_rule.insights]
  name                    = "dcr-insights-win2016-${var.suffix}"
  target_resource_id      = var.win2016_vm_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.insights.id
}

# ----------------------------------------------------------------------------------------------
# Azure Monitor Data Collection Rule Association - Windows Server 2022
# ----------------------------------------------------------------------------------------------
resource "azurerm_monitor_data_collection_rule_association" "dcr_insights_win2022" {
  depends_on              = [azurerm_monitor_data_collection_rule.insights]
  name                    = "dcr-insights-win2022-${var.suffix}"
  target_resource_id      = var.win2022_vm_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.insights.id
}

# ----------------------------------------------------------------------------------------------
# Azure Monitor Data Collection Rule Association - Redhat Enterprise Linux 8.6
# ----------------------------------------------------------------------------------------------
resource "azurerm_monitor_data_collection_rule_association" "dcr_insights_rhel86" {
  depends_on              = [azurerm_monitor_data_collection_rule.insights]
  name                    = "dcr-insights-rhel86-${var.suffix}"
  target_resource_id      = var.rhel_86_vm_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.insights.id
}

# ----------------------------------------------------------------------------------------------
# Azure Monitor Data Collection Rule Association - Ubuntu
# ----------------------------------------------------------------------------------------------
resource "azurerm_monitor_data_collection_rule_association" "dcr_insights_ubuntu2004" {
  depends_on              = [azurerm_monitor_data_collection_rule.insights]
  name                    = "dcr-insights-ubuntu2004-${var.suffix}"
  target_resource_id      = var.ubuntu_2004_vm_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.insights.id
}
