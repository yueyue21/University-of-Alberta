<HTML>
<HEAD>
<TITLE>Your Insert Result</TITLE>
</HEAD>

<BODY>

<%@page import="java.sql.*"%>
<% 
	if((request.getParameter("newperson") != null) || (request.getParameter("newuserskip") != null))
        {			
		    String sqlname = (String)session.getAttribute("SQLUSERID");
		    String sqlpwd =  (String)session.getAttribute("SQLPASSWD");
		    
	        String firstName= "";
	        String lastName = "";
	        String personid = "";
	        Integer personID= null;
	        String address  = "";
	        String email    = "";
	        String phone    = "";
	        if (request.getParameter("newuserskip") != null){
	        	String skip = (request.getParameter("newuserskip")).trim();
	        	session.setAttribute("newuserskip",skip);
		    	out.println("<script language=javascript type=text/javascript>");
		    	out.println("setTimeout("+"\"javascript:location.href='newuser.html'\""+", 0);");
		    	out.println("</script>");
	        }
	        else if ((request.getParameter("personid") == "")){
	        	out.println("<div style='background: url(10.jpg) no-repeat; width: 100%; height: 100%; background-size: 100%;'>");
	        	out.println("<BR><BR>");
	        	out.println("<BR><p><CENTER><b>Insert Failed!</b></CENTER></p>");
	        	out.println("<BR><p><CENTER><b>Please provide your Person ID!</b></CENTER></p>");
		    	out.println("<script language=javascript type=text/javascript>");
		    	out.println("setTimeout("+"\"javascript:location.href='newperson.html'\""+", 2500);");
		    	out.println("</script></div>");
	        }
	        else{
	        	String skip = null;
	        	session.setAttribute("newuserskip",skip);
		        //get the user input
		        firstName= (request.getParameter("firstname")).trim();
		        lastName = (request.getParameter("lastname")).trim();
		        personid = (request.getParameter("personid")).trim();
		        personID= Integer.parseInt(personid);
		        address  = (request.getParameter("address")).trim();
		        email    = (request.getParameter("emailid")).trim();
		        phone    = (request.getParameter("mobileno")).trim();
		        session.setAttribute("personid",personid);	 
		        
	        	//out.println("<p><CENTER>Your input first name is "+firstName+"</CENTER></p>");
	        	//out.println("<p><CENTER>Your input last name is "+lastName+"</CENTER></p>");
	        	//out.println("<p><CENTER>Your input person ID is "+personID+"</CENTER></p>");
	        	//out.println("<p><CENTER>Your input address is "+address+"</CENTER></p>");
	        	//out.println("<p><CENTER>Your input email is "+email+"</CENTER></p>");
	        	//out.println("<p><CENTER>Your input phone is "+phone+"</CENTER></p>");
	        
	        	
	
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
	        	PreparedStatement pstmt = null;
	 
	        	
	        	try{
	        		pstmt = conn.prepareStatement("INSERT INTO persons (person_id, first_name,last_name,address,email,phone)"
	        				  +"VALUES(?, ?, ?, ?, ?, ?)");
	      			pstmt.setInt(1, personID);
	      			pstmt.setString(2, firstName);
	      			pstmt.setString(3, lastName);
	      			pstmt.setString(4, address);
	      			pstmt.setString(5, email );
	      			pstmt.setString(6, phone );
			    	pstmt.executeQuery();
	
			    	out.println("<div style='background: url(10.jpg) no-repeat; width: 100%; height: 100%; background-size: 100%;'>");
			    	out.println("<BR><p><CENTER><b>Insert Successful!</b></CENTER></p>");
			    	out.println("<script language=javascript type=text/javascript>");
			    	out.println("setTimeout("+"\"javascript:location.href='newuser.html'\""+", 1000);");
			    	out.println("</script></div>");
	        	}
	
		        catch(Exception ex){
		        	out.println("<div style='background: url(10.jpg) no-repeat; width: 100%; height: 100%; background-size: 100%;'>");
		        	out.println("<BR><p><CENTER>Insert Failed!</CENTER></p><br><br>");
			        out.println("<hr>" + ex.getMessage() + "<hr>");
			    	out.println("<script language=javascript type=text/javascript>");
			    	out.println("setTimeout("+"\"javascript:location.href='newperson.html'\""+", 2500);");
			    	out.println("</script>");
			        out.println("</div>");
			       // conn.rollback();
	            }
	
	            try{
	                    conn.close();
	            }
	            catch(Exception ex){
	                    out.println("<hr>" + ex.getMessage() + "<hr>");
	            }
	        }
        }
  
%>


</BODY>
</HTML>

