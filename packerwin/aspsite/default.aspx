<%@ Page Language="C#"  Debug="true"%>

<%@ Import Namespace="System"%>
<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="System.Web.Configuration"%>
<%@ Import Namespace="System.Data.SqlClient"%>

<%
String hello;
String date;
String table="mytable";
String connectionString="mydb";

hello="Hello world";
date=DateTime.Now.ToString();
String sql="select hello from "+table;

SqlConnection conn = new SqlConnection(WebConfigurationManager.ConnectionStrings["mydb"].ConnectionString);
conn.Open();

SqlCommand cmd = new SqlCommand(sql, conn);
DataTable dt= new DataTable();
dt.Load(cmd.ExecuteReader());
%>

<html>
<body>
<h2>
<%= hello %>
</h2>
<p>Welcome! <%= date %></p>
<p>Result: <%= dt.Rows[0][0]  %></p>
</body>
</html>
