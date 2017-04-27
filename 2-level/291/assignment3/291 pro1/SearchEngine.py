import cx_Oracle
import datetime 

def searchengine():
    login='xiaocong/samisda38@gwynne.cs.ualberta.ca:1521/CRS'
    connection = cx_Oracle.connect(login)
    curs = connection.cursor()     
    
    try:

        print("If you want to search the health_care_no, patient name, test type name, testing date, and test result, please choose 1 or 2")
        print("If you want to search the health_care_no, patient name, test type name, prescribing date, please choose 3 or 4")        
        print("1.patient health number")
        print("2.patient name")
        print("3.name of the doctor")
        print("4.employee_no of the doctor")
        print("5.exit")        
        choose=int(input("Please enter one of the 4 key information for searching:"))
        if  choose==1:
            patient_no=input("Please enter the health care number of the patient for searching:")#-------check input
            
            checkinput=0
            curs.execute("SELECT patient_no FROM test_record Where test_record.patient_no = '"+patient_no+"'")
            row1 = curs.fetchone()
            while row1:
                if len(row1)!=0:
                    checkinput=1
                row1 = curs.fetchone()
                
            if  checkinput==1:   
                list2=["patient health care number:","patient name:","test name:","test date:","test result:"]
                curs.execute("SELECT distinct tr.patient_no,p.name,tt.test_name,tr.test_date,tr.result FROM test_record tr,test_type tt, patient p WHERE tr.patient_no = '"+str(patient_no)+"' and tr.patient_no = p.health_care_no and tt.type_id = tr.type_id")
                row3 = curs.fetchall()
                while row3:
                    for i in range(len(row3)):
                        for j in range (5):
                            print(list2[j],row3[i][j])
                        print("----------------------------------------------------------------------")
                    row3 = curs.fetchall()
            else:
                print("No data found! Please try again.")
                print("")
                searchengine()
                
        if choose==2:
            list2=["patient health care number:","patient name:","test name:","test date:","test result:"]
            patient_name=input("Please enter the name of the patient for searching:")#--------------check input
            
            checkinput=0
            curs.execute("SELECT p.name FROM patient p,test_record tr Where tr.patient_no = p.health_care_no and p.name like '"+patient_name+"'")
            row1 = curs.fetchone()
            while row1:
                if len(row1)!=0:
                    checkinput=1
                row1 = curs.fetchone()
                
            if checkinput==1:    
                curs.execute("SELECT distinct tr.patient_no,p.name,tt.test_name,tr.test_date,tr.result FROM test_record tr,test_type tt, patient p WHERE tr.patient_no = p.health_care_no and tt.type_id = tr.type_id and p.name like '"+patient_name+"'")
                row3 = curs.fetchall()
                while row3:
                    for i in range(len(row3)):
                        for j in range (5):
                            print(list2[j],row3[i][j])
                        print("----------------------------------------------------------------------")
                    row3 = curs.fetchall()
            else:       
                print("No data found! Please try again.")
                print("")
                searchengine()
                
        if  choose==3 :
            list2=["patient health care number:","patient name:","test name:","prescribe date:"]
            name_doctor=input("Please enter the name of the doctor for searching:")#--------------check input
            
            checkinput=0
            curs.execute("SELECT tr.employee_no FROM patient p,test_record tr, doctor d Where d.health_care_no = p.health_care_no and d.employee_no = tr.employee_no and p.name like '"+name_doctor+"'")
            row1 = curs.fetchone()
            while row1:
                if len(row1)!=0:
                    checkinput=1
                row1 = curs.fetchone()
                
            if checkinput==1:
                curs.execute("SELECT distinct tr.patient_no,p.name,tt.test_name,tr.prescribe_date FROM test_record tr,test_type tt, patient p,doctor d WHERE tt.type_id = tr.type_id and d.health_care_no = p.health_care_no and p.name like '"+name_doctor+"' and d.employee_no = tr.employee_no")
                row3 = curs.fetchall()
                while row3:
                    for i in range(len(row3)):
                        for j in range (4):
                            print(list2[j],row3[i][j])
                        print("----------------------------------------------------------------------")
                    row3 = curs.fetchall()
            else:
                print("No data found! Please try again.")
                print("")
                searchengine()                
                
        if choose==4 :
            list2=["patient health care number:","patient name:","test name:","prescribe date:"]
            employee_no=input("Please enter the d.employee_no of the doctor for searching:")#--------------check input
            
            checkinput=0
            curs.execute("SELECT employee_no FROM test_record Where test_record.employee_no = '"+employee_no+"'")
            row1 = curs.fetchone()
            while row1:
                if len(row1)!=0:
                    checkinput=1
                row1 = curs.fetchone() 
                
            if checkinput==1:
                curs.execute("SELECT distinct tr.patient_no,p.name,tt.test_name,tr.prescribe_date FROM test_record tr,test_type tt, patient p,doctor d WHERE tr.patient_no = p.health_care_no and tt.type_id = tr.type_id and tr.employee_no = '"+employee_no+"'")
                row3 = curs.fetchall()
                while row3:
                    for i in range(len(row3)):
                        for j in range (4):
                            print(list2[j],row3[i][j])
                        print("----------------------------------------------------------------------")
                    row3 = curs.fetchall()
            
            else:
                print("No data found! Please try again.")
                print("")
                searchengine()             
            
        if  choose==5:
            print("Thank you for using the search engine!")
            return
        
    except:
        print("Invalid input try again")
        update_patient()        
    
        curs.close()
        connection.close()    


    


#List the health_care_no, patient name, test type name, prescribing date of all tests prescribed by a given doctor during a specified 
#time period. The user needs to enter the name or employee_no of the doctor, and the starting and ending dates between which tests are 
#prescribed.