import cx_Oracle
import datetime
import random  

def check_input():
    login='xiaocong/samisda38@gwynne.cs.ualberta.ca:1521/CRS'
    connection = cx_Oracle.connect(login)
    curs = connection.cursor()  
    cursInsert = connection.cursor()
    
    try:
        list_of_test=[]
        curs.execute("SELECT test_name FROM test_type")
        row4 = curs.fetchone()
        while row4:
            list_of_test.append(str(row4[0]))
            row4 = curs.fetchone() 
       
#-------1-----------------------------------------------------------------------------
        list_patient_no=[]
        list_patient_name=[]
        curs.execute("SELECT Health_care_no,name FROM patient")
        row2 = curs.fetchone()
        while row2:
            list_patient_no.append(row2[0])
            list_patient_name.append(row2[1])
            row2 = curs.fetchone()
 #------2----------------------------------------------------------------------------------                 
        list_doctor_employee=[]
        list_doctor_health_no=[]
        curs.execute("SELECT employee_no, health_care_no FROM doctor")
        row3 = curs.fetchone()
        while row3:
            list_doctor_employee.append(row3[0])
            list_doctor_health_no.append(row3[1])
            row3 = curs.fetchone() 
        print("Prescription \n1:prescribe\n2:go back")
        #input(are you going to prescribe a test(1/2)?:)---------------------***************************85
#----------------INPUT1------------------------------------------------------------------------           
        userinp1=int(input("Please enter a doctor employee_no(enter an integer):"))
        while(userinp1=="" or (userinp1 not in list_doctor_employee)):
            if userinp1 not in list_doctor_employee:
                        print("employee number DOES NOT EXIST.")            
            userinp1=int(input("Please enter  employee_no again(enter an integer):")) 
#------------------INPUT2---------------------------------------------------------------------- 
        name999=list_patient_name[list_patient_no.index(list_doctor_health_no[list_doctor_employee.index(userinp1)])]
        userinp2=input("Please enter a doctor name(string 1-100 characters):")
        while(userinp2=="" or userinp2!=name999):
            if userinp2!=name999:
                print("empoyee id does not match to name entered.")
            userinp2=input("Please enter name again(string 1-100 characters):")         
#-------------------INPUT3---------------------------------------------------------------------  
        userinp3=input("Please enter the test name(please enter the test name int table, test_type):")
        while(userinp3=="" or (userinp3 not in list_of_test)):
            print(userinp3,list_of_test)
            userinp3=input("Please enter the test name again(please enter the test name int table, test_type):")    
#--------------------INPUT4&5--------------------------------------------------------------------             
        check_name=input("Would you like to enter a name?(y/n):")
        if check_name=='y':
            userinp4=input("Please enter the name of the patient(string 1-100 characters):")
            while(userinp4=="" or (userinp4 not in list_patient_name)):
                if(userinp4 not in list_patient_name):
                    print("patient's name not registed yet.")
                userinp4=input("Please enter the name of the patient again(string 1-100 characters):")
            check_health=input("Would you like to enter a health_care_no?(y/n):")
            if check_health=='y':
                number999=list_patient_no[list_patient_name.index(userinp4)]
                print(number999)                
                userinp5=int(input("Please enter the health_care_no of the patient(enter an integer):"))

                while(userinp5=="" or (int(list_patient_no[list_patient_name.index(userinp4)]) != userinp5)):
                    print("patient name does not match.")
                    userinp5=input("Please enter health_care_no of the patient again(enter an integer):")
            else:
                userinp5=None
                    
        else:
            userinp4=None
            userinp5=int(input("Please enter the health_care_no of the patient(enter an integer):"))
            while(userinp5=="" or (int(userinp5) not in list_patient_no)):
                print("health care number is not registed.")
                userinp5=int(input("Please enter health_care_no of the patient again(enter an integer):"))
 #----------------------------------------------------------------------------------------                 

        list_of_test_id=[]
        curs.execute("SELECT test_id FROM test_record")
        row5 = curs.fetchone()
        while row5:
            list_of_test_id.append(row5[0])
            row5 = curs.fetchone()             
            
        tttt="select type_id from test_type "+"where test_type.test_name like '"+userinp3+"'"            
        curs.execute(tttt)
        row1 = curs.fetchone()
            
        i = datetime.datetime.now()
        list_month=["January","February","March","April","May","June","July","August","September","October","November","December"]
        prescribe_time=str(i.day)+"-"+list_month[i.month-1]+"-"+str(i.year)
        
        new_test_id=random.randint(10000,99999)
        while (new_test_id in list_of_test_id):
            new_test_id=random.randint(10000,99999)
        print("The new test id for this test is:",new_test_id)  
        
        new_record=(new_test_id,int(row1[0]),userinp5,int(userinp1),None,None,prescribe_time,None)
        cursInsert.setinputsizes(int, int, int, int, 25, 1024, datetime.date, datetime.date)
        cursInsert.execute("insert into test_record (test_id,type_id,patient_no,employee_no,medical_lab,result,prescribe_date,test_date)"
                "VALUES (:1, :2, :3, :4, :5, :6, :7, :8)", new_record) 
        connection.commit()
    except:
            print("Invalid input please try again!")
            check_input()
            
            
               
            
    curs.close()
    cursInsert.close()
    connection.close()              

    
     
def prescription():
    check_input()
    

    
  