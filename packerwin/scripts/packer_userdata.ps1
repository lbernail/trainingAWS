<powershell>

echo "Configuring execution policy"
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force

echo "Configuring WinRM"
winrm quickconfig -q
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="1024"}'
winrm set winrm/config '@{MaxTimeoutms="1800000"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
cmd /c "sc config winrm start=auto"
cmd /c "net start winrm"

echo "Configuring firewall"
netsh advfirewall firewall add rule name="WinRM 5985" protocol=TCP dir=in localport=5985 action=allow
netsh advfirewall firewall add rule name="WinRM 5986" protocol=TCP dir=in localport=5986 action=allow

#Gets the content of EC2Config Config.xml and enables Password Generation, UserData and DynamicVolumeSize for next boot
echo  "Setting Config.xml"
$EC2SettingsFile= "$env:ProgramFiles\Amazon\Ec2ConfigService\Settings\Config.xml"
$xml = [xml](get-content $EC2SettingsFile)
$xmlElement = $xml.get_DocumentElement()
$xmlElementToModify = $xmlElement.Plugins

foreach ($element in $xmlElementToModify.Plugin)
{
    if ($element.name -eq "Ec2SetPassword") { $element.State="Enabled" }
    elseif ($element.name -eq "Ec2HandleUserData") { $element.State="Enabled" }
    elseif ($element.name -eq "Ec2DynamicBootVolumeSize") { $element.State="Enabled" }
}
$xml.Save($EC2SettingsFile)

</powershell>
