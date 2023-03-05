# ----------------------------------------------------------------------------------------------
# Azure Log Analytics Workspace
# ----------------------------------------------------------------------------------------------
resource "azurerm_log_analytics_workspace" "this" {
  name                       = "workspace-${var.suffix}"
  location                   = var.resource_group_location
  resource_group_name        = var.resource_group_name
  retention_in_days          = 730
  internet_ingestion_enabled = false
}

# ----------------------------------------------------------------------------------------------
# Azure Log Analytics Workspace Table
# ----------------------------------------------------------------------------------------------
resource "azapi_resource" "table_nginx_access" {
  depends_on = [azurerm_log_analytics_workspace.this]
  provider   = azapi
  type       = "Microsoft.OperationalInsights/workspaces/tables@2022-10-01"
  name       = "NginxAccessLog_CL"
  parent_id  = azurerm_log_analytics_workspace.this.id

  body = jsonencode(
    {
      "properties" : {
        "schema" : {
          "name" : "NginxAccessLog_CL",
          "columns" : [
            {
              "name" : "TimeGenerated",
              "type" : "DateTime"
            },
            {
              "name" : "RawData",
              "type" : "string"
            },
            {
              "name" : "RemoteAddress",
              "type" : "string"
            },
            {
              "name" : "RequestType",
              "type" : "string"
            },
            {
              "name" : "Resource",
              "type" : "string"
            },
            {
              "name" : "ResponseCode",
              "type" : "string"
            },
            {
              "name" : "HttpReferer",
              "type" : "string"
            },
            {
              "name" : "UserAgent",
              "type" : "string"
            }
          ]
        },
        "retentionInDays" : 30,
        "totalRetentionInDays" : 30
      }
    }
  )

  response_export_values = ["id"]
}

# ----------------------------------------------------------------------------------------------
# Azure Log Analytics Workspace Table
# ----------------------------------------------------------------------------------------------
resource "azapi_resource" "table_linux_process" {
  depends_on = [azurerm_log_analytics_workspace.this]
  provider   = azapi
  type       = "Microsoft.OperationalInsights/workspaces/tables@2022-10-01"
  name       = "LinuxProcess_CL"
  parent_id  = azurerm_log_analytics_workspace.this.id

  body = jsonencode(
    {
      "properties" : {
        "schema" : {
          "name" : "LinuxProcess_CL",
          "columns" : [
            {
              "name" : "TimeGenerated",
              "type" : "DateTime"
            },
            {
              "name" : "RawData",
              "type" : "string"
            },
            {
              "name" : "User",
              "type" : "string"
            },
            {
              "name" : "Command",
              "type" : "string"
            },
            {
              "name" : "Computer",
              "type" : "string"
            },
            {
              "name" : "CPUUtilization",
              "type" : "string"
            },
            {
              "name" : "MemoryUtilization",
              "type" : "string"
            },
            {
              "name" : "Pid",
              "type" : "string"
            }
          ]
        },
        "retentionInDays" : 30,
        "totalRetentionInDays" : 30
      }
    }
  )

  response_export_values = ["id"]
}

# ----------------------------------------------------------------------------------------------
# Azure Monitor Private Link Scoped Service - Workspace
# ----------------------------------------------------------------------------------------------
resource "azurerm_monitor_private_link_scoped_service" "workspace" {
  name                = "amplsservice-workspace-${var.suffix}"
  resource_group_name = var.resource_group_name
  scope_name          = var.ampls_scope_name
  linked_resource_id  = azurerm_log_analytics_workspace.this.id
}

# ----------------------------------------------------------------------------------------------
# Azure Monitor Private Link Scoped Service - Data Collection Endpoint for Windows
# ----------------------------------------------------------------------------------------------
resource "azurerm_monitor_private_link_scoped_service" "dce_windows" {
  name                = "amplsservice-dce-windows-${var.suffix}"
  resource_group_name = var.resource_group_name
  scope_name          = var.ampls_scope_name
  linked_resource_id  = azurerm_monitor_data_collection_endpoint.windows.id
}

# ----------------------------------------------------------------------------------------------
# Azure Monitor Private Link Scoped Service - Data Collection Endpoint for Linux
# ----------------------------------------------------------------------------------------------
resource "azurerm_monitor_private_link_scoped_service" "dce_linux" {
  name                = "amplsservice-dce-linux-${var.suffix}"
  resource_group_name = var.resource_group_name
  scope_name          = var.ampls_scope_name
  linked_resource_id  = azurerm_monitor_data_collection_endpoint.linux.id
}
