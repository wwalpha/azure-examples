# Azure File Sync Example

## [Deploy Azure File Sync](https://learn.microsoft.com/en-us/azure/storage/file-sync/file-sync-deployment-guide?tabs=azure-portal%2Cproactive-portal)
1. Download and install Azure File Sync Agent
[Microsoft Download Center](https://www.microsoft.com/en-us/download/details.aspx?id=57159)

2. Disable Internet Explorer Enhanced Security Configuration
- Server Manager > Local Server
- On the Properties subpane, select the link for IE Enhanced Security Configuration.
- In the Internet Explorer Enhanced Security Configuration dialog box, select Off for Administrators and Users


3. Register server
You would need to create a custom role where you list the administrators that are only allowed to register servers and give your custom role the following permissions

- "Microsoft.StorageSync/storageSyncServices/registeredServers/write"
- "Microsoft.StorageSync/storageSyncServices/read"
- "Microsoft.StorageSync/storageSyncServices/workflows/read"
- "Microsoft.StorageSync/storageSyncServices/workflows/operations/read"

4. Add cloud endpoint

5. Create a server endpoint
- Registered server
- Path
- Cloud Tiering
  - Volume Free Space Policy
  - Date Policy
- Initial Sync
  - Initial Upload
  - Initial Download

6. Config Cloud Tiering to enabled

7. Add modules from gallery
- Az.Accounts
- Az.ContainerInstance
- Az.Storage

8. Add automation account schedule to execute runbook

## How to limit Azure File Sync bandwidth via PowerShell
```
Import-Module 'C:\Program Files\Azure\StorageSyncAgent\StorageSync.Management.ServerCmdlets.dll'

// Mon-Fri 8am to 5pm bandwidth limit of 20mbps
New-StorageSyncNetworkLimit -Day Monday, Tuesday, Wednesday, Thursday, Friday -StartHour 8 -EndHour 17 -LimitKbps 20000

// 24/7 limit of 20mbps, you'll need to run something similar to this
New-StorageSyncNetworkLimit -Day Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday -StartHour 00 -StartMinute 01 -EndHour 23 -EndMinute 59 -LimitKbps 20000

// To get a list of all the current bandwidth limit schedules
Get-StorageSyncNetworkLimit | ft

// To delete all configured bandwidth limit schedules
Get-StorageSyncNetworkLimit | ForEach-Object { Remove-StorageSyncNetworkLimit -Id $_.Id }

// To delete an individual bandwidth limit schedule
Get-StorageSyncNetworkLimit | Where Id -eq "{idnumber}" | Remove-StorageSyncNetworkLimit
```