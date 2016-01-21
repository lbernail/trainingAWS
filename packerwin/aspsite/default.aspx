<%@ Page Language="C#"  Debug="true"%>

<%@ Import Namespace="System"%>
<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="System.Net"%>
<%@ Import Namespace="System.Net.Sockets"%>
<%@ Import Namespace="System.Web.Configuration"%>
<%@ Import Namespace="System.Data.SqlClient"%>

<%

String table="mytable";
String connectionString="mydb";

String hello="Hello world";
String date=DateTime.Now.ToString();

IPHostEntry ipHostInfo = Dns.GetHostEntry(Dns.GetHostName());
IPAddress ipAddress = ipHostInfo.AddressList[0];
if (ipAddress.AddressFamily != AddressFamily.InterNetwork) ipAddress = ipHostInfo.AddressList[1];
String serverIP=ipAddress.ToString();

String sql="select hello from "+table;
SqlConnection conn = new SqlConnection(WebConfigurationManager.ConnectionStrings["mydb"].ConnectionString);
conn.Open();

SqlCommand cmd = new SqlCommand(sql, conn);
DataTable dt= new DataTable();
dt.Load(cmd.ExecuteReader());

conn.Close();

%>

<html>
<body>
<h2>
<%= hello %>
</h2>
<p>The time is <%= date %></p>
<p>Server IP is <%= serverIP %></p>
<p>Content of the first table row: <%= dt.Rows[0][0]  %></p>
</body>
</html>
