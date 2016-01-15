<powershell>
$webconfig= "c:\inetpub\wwwroot\web.config"

$xml = [xml](get-content $webconfig)
$xml_mydb = ($xml.configuration.connectionStrings.add |where {$_.name -eq "mydb"})
$xml_mydb.connectionString="Server=${db_endpoint};Database=${db_instance};User Id=${db_user};Password=${db_password};"

$xml.Save($$webconfig)
</powershell>
