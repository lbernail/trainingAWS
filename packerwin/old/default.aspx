<%@ Page Language="C#"%>
<%@ Import Namespace="System"%>
<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="System.Data.SqlClient"%>

<%

String hello;
String date;
String server="test.cwe2ozwnuq5m.eu-west-1.rds.amazonaws.com";
String instance="test";
String database="test";
String dbuser="test";
String dbpasswd="testtest";

String connection_string="Server="+server+";Database="+database+";User Id="+dbuser+";Password="+dbpasswd+";";

String sql="select hello from test.dbo.Table_1";

hello="Hello world";
date=DateTime.Now.ToString();

SqlConnection conn= new SqlConnection(connection_string);
conn.Open();

SqlCommand cmd = new SqlCommand(sql, conn);
DataTable dt= new DataTable();
dt.Load(cmd.ExecuteReader());

%>

<html>
<body>
<h2><%= hello %></h2>
<p>Welcome! <%= date %></p>
<p>Result: <%= dt.Rows[0][0]  %></p>
</body>
</html>
