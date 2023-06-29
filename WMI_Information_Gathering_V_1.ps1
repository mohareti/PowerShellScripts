# Retrieve system information
$systemInfo = Get-WmiObject -Class Win32_ComputerSystem
$systemInfo | Select-Object Manufacturer, Model, TotalPhysicalMemory

# Retrieve installed software information
$installedSoftware = Get-WmiObject -Class Win32_Product
$installedSoftware | Select-Object Name, Version

# Retrieve disk drive information
$diskDrives = Get-WmiObject -Class Win32_DiskDrive
$diskDrives | Select-Object DeviceID, Model, Size

# Retrieve currently logged-in users
$loggedUsers = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty UserName
$loggedUsers

# Retrieve event log entries
$eventLogEntries = Get-WmiObject -Class Win32_NTLogEvent -Filter "Logfile='System' AND EventCode=6005"
$eventLogEntries | Select-Object TimeGenerated, SourceName, Message

# Retrieve CPU usage
$cpuUsage = Get-WmiObject -Class Win32_Processor | Select-Object -ExpandProperty LoadPercentage
$cpuUsage
