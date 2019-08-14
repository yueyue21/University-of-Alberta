<HTML>
<HEAD>
<TITLE>Your Login Result</TITLE>
</HEAD>

<BODY>

<%@page import="java.sql.*" import= "java.util.*"%>
<% 		
	if(request.getParameter("newdoctor") != null){
		
		    String sqlname = (String)session.getAttribute("SQLUSERID");
		    String sqlpwd =  (String)session.getAttribute("SQLPASSWD");
	        String personid = (String)session.getAttribute("personid");
	        Integer personID= Integer.parseInt(personid);
			String doctorid=(request.getParameter("DoctorIdName")).trim();
			Integer doctorID= Integer.parseInt(doctorid);
			String classtype = (String)session.getAttribute("Class");
			//out.println("<p><CENTER>Your personID is "+personID+"</CENTER></p>");
			//out.println("<p><CENTER>Your doctorID Name is "+doctorID+"</CENTER></p>");
			
			
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
	        
	        try{
	        	if (classtype.equals("d")){
	        		String sql1 = "insert into family_doctor values ("+personID+", "+doctorID+")";
		        	stmt = conn.createStatement();
			        rset = stmt.executeQuery(sql1);
	        	}
	        	else{
	        		String sql2 = "insert into family_doctor values ("+doctorID+", "+personID+")";
		        	stmt = conn.createStatement();
			        rset = stmt.executeQuery(sql2);
	        	}
	    	
		    	out.println("<div style='background: url(10.jpg) no-repeat; width: 100%; height: 100%; background-size: 100%;'>");
		    	out.println("<BR><BR><BR><BR><BR><BR><BR>");
		    	out.println("<BR><p><CENTER><b>Insert Successful!</b></CENTER></p>");
		    	out.println("<script language=javascript type=text/javascript>");
		    	out.println("setTimeout("+"\"javascript:location.href='newdoctor.jsp'\""+", 1000);");
		    	out.println("</script></div>");
	        }
	        catch(Exception ex){
	        	out.println("<div style='background: url(10.jpg) no-repeat; width: 100%; height: 100%; background-size: 100%;'>");
		    	out.println("<BR><BR><BR><BR><BR><BR><BR>");
	        	out.println("<BR><p><CENTER><b>Insert Failed!</b></CENTER></p><br><br>");
		        out.println("<hr>" + ex.getMessage() + "<hr>");
		    	out.println("<script language=javascript type=text/javascript>");
		    	out.println("setTimeout("+"\"javascript:location.href='newdoctor.jsp'\""+", 2500);");
		    	out.println("</script></div>");
				out.println("</div>");
				conn.rollback();
            }
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

