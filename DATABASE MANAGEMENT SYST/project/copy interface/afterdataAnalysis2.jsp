<HTML>
<HEAD>
<TITLE>Your Login Result</TITLE>
</HEAD>

<BODY>

<%@page import="java.sql.*" %>
<% 
	if(request.getParameter("search2") != null)
        {			
			String sqlname = (String)session.getAttribute("SQLUSERID");
			String sqlpwd =  (String)session.getAttribute("SQLPASSWD");
			String name1="";
			String type="";
			String year="";
			String month="";
			String week="";
	        //get the user input from the login page
	        try{
        			name1 = (request.getParameter("name1")).trim();
        			}
	        catch(Exception ex){
	        		name1="off";
	        }
	        
	        try{
	        		type = (request.getParameter("type")).trim();
    			}
        	catch(Exception ex){
        			type="off";
        	}
	        
	        try{
        		year = (request.getParameter("year")).trim();
			}
    		catch(Exception ex){
    			year="off";
    		}
	        
	        try{
        		month= (request.getParameter("month")).trim();
			}
    		catch(Exception ex){
    			month="off";
    		}
	        
	        try{
        		week = (request.getParameter("week")).trim();
			}
    		catch(Exception ex){
    			week="off";
    		}
        	
        	
        	out.println("<p><CENTER>Your input User Name is "+name1+"</CENTER></p>");
        	out.println("<p><CENTER>Your input User type is "+type+"</CENTER></p>");
        	out.println("<p><CENTER>Your input User year is "+year+"</CENTER></p>");
        	out.println("<p><CENTER>Your input User month is "+month+"</CENTER></p>");
        	out.println("<p><CENTER>Your input User week is "+week+"</CENTER></p>");
        	


	        //establish the connection to the underlying database
        	Connection conn = null;
	
	        String driverName = "oracle.jdbc.driver.OracleDriver";
            String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
	
	        try{
		        //load and register the driver
        		Class drvClass = Class.forName(driverName); 
	        	DriverManager.registerDriver((Driver) drvClass.newInstance());
        	}
	        catch(Exception ex){
		        out.println("<hr>" + ex.getMessage() + "<hr>");
	
	        }

        	try{
	        	//establish the connection 
		        conn = DriverManager.getConnection(dbstring,sqlname,sqlpwd);
        		conn.setAutoCommit(false);
	        }
        	catch(Exception ex){
		        out.println("<hr>" + ex.getMessage() + "<hr>");
        	}
	

	        //select the user table from the underlying db and validate the user name and password
        	Statement stmt = null;
	        ResultSet rset = null;
	        Statement stmt2 = null;
	        ResultSet rset2 = null;
	        
        	String sql = "select count(*) from pacs_images pp";
        			//"select password from users where user_name = '"+userName+"'";
        	//String type = "select class from users where user_name = '"+userName+"'";
        	
	        //out.println(sql);
        	try{
	        	stmt = conn.createStatement();
		        rset = stmt.executeQuery(sql);
        	}
	
	        catch(Exception ex){
		        out.println("<hr>" + ex.getMessage() + "<hr>");
        	}

	        String basecase = "";
        	while(rset != null && rset.next())
	        	basecase = (rset.getString(1)).trim();
        		out.println(basecase);
        	out.println(basecase);	
        		
			try{
                conn.close();
            }
            catch(Exception ex){
                 out.println("<hr>" + ex.getMessage() + "<hr>");
            }
        }
  
%>



</BODY>
</HTML>
