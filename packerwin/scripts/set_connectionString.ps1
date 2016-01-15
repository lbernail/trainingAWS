$webconfig= "c:\inetpub\wwwroot\web.config"

$xml = [xml](get-content $webconfig)
$xml_mydb = ($xml.configuration.connectionStrings.add |where {$_.name -eq "mydb"})
$xml_mydb.connectionString="Server=test.cwe2ozwnuq5m.eu-west-1.rds.amazonaws.com;Database=test;User Id=test;Password=testtest;"

$xml.Save($webconfig)
