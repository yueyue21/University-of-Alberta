import cx_Oracle
import datetime
import random  


def MedicalTest():
    login='xiaocong/samisda38@gwynne.cs.ualberta.ca:1521/CRS'
    connection = cx_Oracle.connect(login)
    curs = connection.cursor()  
    cursUpdate = connection.cursor()
    print("Medical Test")
    print("1.patient number")
    print("2.test type id")
    print("3.doctor empolyee number")
    print("4.go back")
    AnyOhterCondition=int(input("Please choose the data you want to enter to find prescription or go back (1,2,3,4):"))
#----------------------------------------------------------------------------------    
    try:
        list_test_id=[]
        list_patient_no=[]
        list_type_id=[]
        list_doctor_num=[]
        curs.execute("SELECT test_id,type_id,patient_no,employee_no FROM test_record")
        row1 = curs.fetchone()
        #i=0
        while row1:
            list_test_id.append(int(row1[0]))
            list_type_id.append(int(row1[1]))
            list_patient_no.append(int(row1[2]))
            list_doctor_num.append(int(row1[3]))
            row1 = curs.fetchone()
            #print(list_test_id[i])
            #i+=1
        print("test ID:",list_test_id)   
        test_id=int(input("Please enter the test id of the current test(test id is necessary):"))
        while(test_id=="" or (test_id not in list_test_id)):
            print("Test id number DOES NOT EXIST.")            
            test_id=int(input("Please enter the test id of the current test again(enter an integer):"))
    #----------------------------------------------------------------------------------       
        if AnyOhterCondition==1:
            patientNo=int(input("Please enter the patient's health care number(please enter an integer):"))
            if (patientNo not in list_patient_no):
                print("Invalid patient nomber OR the the number doesn't exist!")
        elif AnyOhterCondition==2:
            test_type_id =input("Please enter the test type ID:")
            if (ptest_type_id not in list_type_id):
                print("Invalid patient nomber OR the the number doesn't exist!")        
        elif AnyOhterCondition==3:
            doctor_employee_no=input("Please enter the doctor's employee no(enter in integer):")
            if (doctor_employee_no not in list_doctor_num):
                print("Invalid patient nomber OR the the number doesn't exist!")
        #elif AnyOhterCondition==4:
            #----------------------------**************************************************************************************************gai
        else:
            print("UNknow commend")
#---------------input the modifying record----------------------------------------------
        lab_name=input("Please enter lab name(25 characters):")#-------------------------repeat
        test_result=input("enter the lab result(1024 characters):")
        list_labname=[]
        curs.execute("SELECT lab_name FROM medical_lab")
        row2 = curs.fetchone()
        while row2:
            list_labname.append(str(row2[0]))
            row2 = curs.fetchone()
            
        list_lab_name=[]
        list_test_id1=[]
        index=0
        curs.execute("SELECT lab_name, test_id FROM can_conduct")
        row3 = curs.fetchone()
        while row3:
            list_lab_name.append(str(row3[0]))
            list_test_id1.append(int(row3[1]))
            index+=1
            row3 = curs.fetchone()        
        
        tttt="SELECT type_id FROM test_record "+"where test_record.test_id = '"+str(test_id)+"'"
        curs.execute(tttt)
        row4 = curs.fetchone()
        for i in range (index) :   
            if list_lab_name[i]== lab_name and int(list_test_id1[i])==int(row4[0]):
                uiui="update test_record set medical_lab='"+lab_name+"'"+" where test_id="+str(test_id)
                uouo="update test_record set result='"+test_result+"'"+" where test_id="+str(test_id)
                now = datetime.datetime.now()
                list_month=["January","February","March","April","May","June","July"\
                            ,"August","September","October","November","December"]
                prescribe_time=str(now.day)+"-"+list_month[now.month-1]+"-"+str(now.year)
                utut="update test_record set test_date='"+prescribe_time+"'"+" where test_id="+str(test_id)
                cursUpdate.execute(uiui)
                cursUpdate.execute(uouo)
                cursUpdate.execute(utut)
                connection.commit()  
        #input("record modified,would you like to record another test?(y/n)")-------------------******************************************
#--------------------------------------------------------------------------------------- 
    except:
        print("Invalid input, try again")
        MedicalTest()
    curs.close()
    cursUpdate.close()
    connection.close()