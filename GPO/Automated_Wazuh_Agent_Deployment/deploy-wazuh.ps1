$WazuhManager = "Your_Wazuh_Manager_IP"
$InstallerUrl = "https://packages.wazuh.com/4.x/windows/wazuh-agent-4.14.3-1.msi"
$InstallerPath = "$env:TEMP\wazuh-agent.msi"
$AgentName = $env:COMPUTERNAME

$service = Get-Service -Name "WazuhSvc" -ErrorAction SilentlyContinue 

if (!service) {
    try {
         Invoke-WebRequest -Uri $InstallerUrl -OutFile $InstallerPath -UseBasicParsing

         Start-Process msiexec.exe -ArgumentList "/i `"$InstallerPath`" /qn WAZUH_MANAGER=$WazuhManager WAZUH_AGENT_NAME=$AgentName WAZUH_AGENT_GROUP=default" -wait

         Start-Service WazuhSvc
    } catch {
         Write-Output "Wazuh agent installation failed"
    }
}
