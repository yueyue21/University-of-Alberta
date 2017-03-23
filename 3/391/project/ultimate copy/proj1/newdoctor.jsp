<HTML>
<HEAD>
<TITLE>Your Login Result</TITLE>
</HEAD>

<BODY>

<%@page import="java.sql.*" import= "java.util.*"%>
<% 		
		    String sqlname = (String)session.getAttribute("SQLUSERID");
		    String sqlpwd =  (String)session.getAttribute("SQLPASSWD");
		    String classtype = (String)session.getAttribute("Class");
		    
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
	
        	String doctorlist = "select distinct person_id from users where class = 'd'";
        	String patientlist = "select distinct person_id from users where class = 'p'";
        	
        	ArrayList<Integer> didList = new ArrayList<Integer>();
        	ArrayList<String> nameList = new ArrayList<String>();
        	
	        //select the user table from the underlying db and validate the user name and password
        	Statement stmt = null;
	        ResultSet rset = null;
	        
        	try{
	        	stmt = conn.createStatement();
	        	if (classtype.equals("d")){
	        		rset = stmt.executeQuery(patientlist);
	        	}
	        	else{
	        		rset = stmt.executeQuery(doctorlist);
	        	}
        	}
	
	        catch(Exception ex){
		        out.println("<hr>" + ex.getMessage() + "<hr>");
        	}
		
        	while(rset != null && rset.next()){
        		Integer K= new Integer(rset.getInt(1));
        		didList.add(K);
        	}       
        	
			int n = didList.size();
			for(int i = 0; i < n ; i++){
	        	String name = "select p.first_name, p.last_name from persons p where person_id = "+didList.get(i)+"";

	        	stmt = null;
		        rset = null;
		        String F = "";
		        String L = "";
		        String Name ="";
	        	try{
		        	stmt = conn.createStatement();
			        rset = stmt.executeQuery(name);
			        //rset.next();
		        	//out.println("<p><CENTER>"+rset.getString(1).trim()+"</CENTER></p>");
	        	}
		
		        catch(Exception ex){
			        out.println("<hr>" + ex.getMessage() + "<hr>");
	        	}
			
	        	while(rset != null && rset.next()){
	        		F = (rset.getString(1)).trim();
	        		L = (rset.getString(2)).trim();
	        		Name = F+" "+L;
	        		nameList.add(Name);
	        	} 
			}
            try{
                conn.close();
       		}
       	    catch(Exception ex){
                out.println("<hr>" + ex.getMessage() + "<hr>");
       		}
        	out.println("<html><head><script type='text/javascript' src='validate.js'></script></head><body>");
        	out.println("<div style='background: url(10.jpg) no-repeat; width: 100%; height: 100%; background-size: 100%;'>");
        	out.println("<form action='finishNewuser.jsp' name='newUserRegistration' onsubmit='return(validate());'>");
        	out.println("<br><br><br><br><br><br><table cellpadding=8 align=center cellspacing=5>");
        	out.println("<tr><td colspan=2><center><font size=4><b>New User Registration Form</b></font></center></td></tr>");
        	out.println("<tr><td colspan=2><center>Family Doctor</center></td></tr>");
        	out.println("<tr><td colspan=2><hr></td></tr>");
        	if (classtype.equals("d")){
            	out.println("<tr><td>Patient ID & Name:</td><td><select name='DoctorIdName'>");
            	out.println("<option value='-1' selected>select a patient..</option>");
        	}
        	else {
        		out.println("<tr><td>Doctor ID & Name:</td><td><select name='DoctorIdName'>");
        		out.println("<option value='-1' selected>select a doctor..</option>");
        	}  	
			int q = didList.size();
			for(int i = 0; i < q ; i++)
				out.println("<option value="+didList.get(i)+">"+didList.get(i)+"  "+nameList.get(i)+"</option>");

        	out.println("</select></td></tr>");
        	out.println("<tr><td colspan=2><hr></td></tr>");
        	out.println("<tr><td colspan=2>Registration Progress:<progress value='100' max='100'></progress> 3 step left</td></tr>");
        	out.println("<tr><td colspan=2><input type='reset'><input type='submit' name='newdoctor' value='Next Step'></form>");
        	out.println("<form action='userManagement.html'><center><input type='submit' name='newuserfinish' value='finish Adding'>");
        	out.println("</center></form></td></tr></table></body></html>");

  
%>



</BODY>
</HTML>

