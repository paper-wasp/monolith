<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="javax.naming.*,javax.sql.*,java.sql.*,java.io.*"
    %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><head id="j_idt3">
   <title>Monolith</title>
   <meta http-equiv="Content-Type" content="text/html; charset=utf-8" /><link type="text/css" rel="stylesheet" href="css/screen.css" /></head><body>
   <div id="container">
      <div class="dualbrand">
         <img src="gfx/rhjb_eap_logo.png" />
      </div>
      <div id="content">
      <h1>Welcome to JBoss!</h1>

      <div>
         <p>You have successfully deployed a Java EE Enterprise Application.</p>
      </div>
<form id="reg" name="reg" method="post" enctype="application/x-www-form-urlencoded">

         <h2>Datasource Testing</h2>
         <p>Use the following form to test your datasource.</p><table>
<tbody>
<tr>
<td class="titleCell"><label for="jndiName">JNDI Name:</label></td>
<td><input id="jndiName" type="text" name="jndiName" /></td>
<td></td>
</tr>
<tr>
<td class="titleCell"><label for="tableName">Table Name:</label></td>
<td><input id="tableName" type="text" name="tableName" /></td>
<td></td>
</tr>
</tbody>
</table>


<p><table>
<tbody>
<tr>
<td><input id="test" type="submit" name="reg:register" value="Test" class="register" /></td>
<td></td>
</tr>
</tbody>
</table>
</p>
</form>
	<%
	if(request.getParameter("jndiName") != null) {
	      // 	PrintWriter writer = response.getWriter();
		out.write("<h1>Results of Test</h1>");
		String jndiName = request.getParameter("jndiName");

		try {
			InitialContext ctx = new InitialContext();
			DataSource ds = (DataSource)ctx.lookup(jndiName);
			out.write("<p>Successfully looked up DataSource named " + jndiName + "</p>");

			if(request.getParameter("tableName") != null) {
				String tableName = request.getParameter("tableName");
				Connection conn = null;
			    	Statement stmt = null;

				conn = ds.getConnection();
				out.write("<p>Successfully connected to database.</p>");
				stmt = conn.createStatement();
				String query = "SELECT * FROM " + tableName;
				out.write("<p>Attempting query \"" + query + "\"</p>");
				ResultSet results = stmt.executeQuery(query);
				ResultSetMetaData rsMetaData = results.getMetaData();
			    	int numberOfColumns = rsMetaData.getColumnCount();

				out.write("<table class=\"simpletablestyle\"><thead><tr>");
				//Display the header row of column names
			    	for (int i = 1; i <= numberOfColumns; i++) {
					int columnType = rsMetaData.getColumnType(i);
				      	String columnName = rsMetaData.getColumnName(i);
					if(columnType == Types.VARCHAR) {
						out.write("<th>" + columnName + "</th>");
					}
			    	}
				out.write("</tr></thead>");
				//Print the values (VARCHAR's only) of each result
				while(results.next()) {
					out.write("<tr>");
				    	for (int i = 1; i <= numberOfColumns; i++) {
						int columnType = rsMetaData.getColumnType(i);
					      	String columnName = rsMetaData.getColumnName(i);
						if(columnType == Types.VARCHAR) {
							out.write("<td>" + results.getString(columnName) + "</td>");
						}
				    	}
					out.write("</tr>");
				}
				out.write("</table>");
				stmt.close();
				conn.close();
			}
	    	}catch(Exception e) {
			out.write("An exception was thrown: " + e.getMessage() + "<br>");
	    		e.printStackTrace();
	    	}
	} else {

%>
	<p>Results will appear here...</p>

	<% } %>
      </div>
      <div id="aside">
         <p>Learn more about Red Hat JBoss Enterprise Application Platform.</p>
         <ul>
            <li><a href="https://access.redhat.com/documentation/en/red-hat-jboss-enterprise-application-platform/">Documentation</a></li>
            <li><a href="http://www.redhat.com/en/technologies/jboss-middleware/application-platform">Product Information</a></li>
         </ul>
      </div>
      <div id="footer">
         <p>
            This project is based on the Kitchensink quickstart.<br />
         </p>
	<%
	String message = "";
	try {
		java.util.Properties props = new java.util.Properties(); 
		props.load(new java.io.FileInputStream(new java.io.File("/opt/eap/standalone/configuration/props/monolith.properties")));
		message = props.getProperty("msg");
		out.write("<p>" + message + "</p>");
	} catch(Exception e) {
		out.write("<p>No message to display</p>");
    	e.printStackTrace();
    	return;
	}
	%>
      </div>
   </div>
   </body>
</html>