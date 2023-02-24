Param (
[Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]
[String] $AzureSubscriptionId,
[Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]
[String] $storageAccountRG,
[Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]
[String] $storageAccountName,
[Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]
[String] $storageContainerName,
[Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]
[String] $storageFileShareName
)

# Ensures you do not inherit an AzContext in your runbook
Disable-AzContextAutosave -Scope Process

# Connect to Azure with system-assigned managed identity (automation account)
Connect-AzAccount -Identity

# SOURCE Azure Subscription
Set-AzContext -Subscription $AzureSubscriptionId

# Get Storage Account Key
$storageAccountKey = (Get-AzStorageAccountKey -ResourceGroupName $storageAccountRG -AccountName $storageAccountName).Value[0]

# Set AzStorageContext
$destinationContext = New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey

# Generate Container SAS URI Token which is valid for 60 minutes ONLY with read, write, create, and delete permission
# If you want to change the target (BlobContainer -> AzureFileShare), then make sure to update the -Permission parameter to (rl)
$blobContainerSASURI = New-AzStorageContainerSASToken -Context $destinationContext `
-ExpiryTime(get-date).AddSeconds(3600) -FullUri -Name $storageContainerName -Permission rwldc

# Generate File Share SAS URI Token which is valid for 60 minutes ONLY with read and list permission
# If you want to change the target (BlobContainer -> AzureFileShare), then make sure to add (rwldc) to the -Permission parameter
$fileShareSASURI = New-AzStorageShareSASToken -Context $destinationContext `
-ExpiryTime(get-date).AddSeconds(3600) -FullUri -ShareName $storageFileShareName -Permission rl

# Choose the following syntax if you want to Sync instead of Copy
$command = "azcopy","sync",$fileShareSASURI,$blobContainerSASURI,"--recursive=true","--delete-destination=true"

# Choose the following syntax if you want to Copy only
# The copy command consumes less memory and incurs less billing costs because a copy operation doesn't have to index the source or destination prior to moving files.
# $command = "azcopy","copy",$fileShareSASURI,$blobContainerSASURI,"--recursive=true","--overwrite=ifSourceNewer"

# Container Group Name
$jobName = $storageAccountName + "-" + $storageFileShareName + "-azcopy-job"

# Set the AZCOPY_BUFFER_GB value at 2 GB which would prevent the container from crashing.
$envVars = New-AzContainerInstanceEnvironmentVariableObject -Name "AZCOPY_BUFFER_GB" -Value "2"

# Create Azure Container Instance Object and run the AzCopy job
# The container image (peterdavehello/azcopy:latest) is publicly available on Docker Hub and has the latest AzCopy version installed
# You could also create your own private container image and use it instead
# When you create a new container instance, the default compute resources are set to 1vCPU and 1.5GB RAM
# We recommend starting with 2 vCPU and 4 GB memory for large file shares (E.g. 3TB)
# You may need to adjust the CPU and memory based on the size and churn of your file share
$container = New-AzContainerInstanceObject -Name $jobName -Image "peterdavehello/azcopy:latest" `
-RequestCpu 2 -RequestMemoryInGb 4 -Command $command -EnvironmentVariable $envVars

# The container will be created in the $location variable based on the storage account location. Adjust if needed.
$location = (Get-AzResourceGroup -Name $storageAccountRG).location
$containerGroup = New-AzContainerGroup -ResourceGroupName $storageAccountRG -Name $jobName `
-Container $container -OsType Linux -Location $location -RestartPolicy never

Write-Output ("Finish.")