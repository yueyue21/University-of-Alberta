import cx_Oracle
import datetime
import Prescription
import Medical_Test
import update
import SearchEngine

gay1=Prescription
gay2=Medical_Test
gay3=update
gay4=SearchEngine

login='xiaocong/samisda38@gwynne.cs.ualberta.ca:1521/CRS'
connection = cx_Oracle.connect(login)
curs = connection.cursor()


patient = [(111111,'Sam','9910-100st, Edmonton Alberta','01-October-1985','7800000001'),
        (222222,'Sammy','9939-105st, Prince Albert Saskatchewan','30-September-1974','7800000002'),
        (333333,'Peter','5112-39st. Vancouver British Columbia','19-July-1988','7800000003')]

doctor = [(11111,'701-12st. Whitehorse Yukon','7800000011','7800000001',111111),
          (22222,'910-100st, Edmonton Alberta','7800000022','7800000002',222222),
          (33333,'99-105st, Prince Albert Saskatchewan','7800000033','7800000003',333333)]

medical_lab = [('medical_lab_A','Vancouver British Columbia','7900000001'),
               ('medical_lab_B','Terrace British Columbia','7900000002'),
               ('medical_lab_C','Edmonton Alberta','7900000003'),
               ('medical_lab_D','Whitehorse Yukon','7900000004')]

test_type = [(1000,'CT scan','Patients need to be female','A+B+X+S.'),
             (2000,'bone marrow check','Patients need to be male','B+DD+A+Q.'),
             (3000,'X ray','Patients ages less than 20','Q+W+E.'),
             (4000,'EEG','Patients take drugA','P+A+D+WW.')]

can_conduct = [('medical_lab_A',1000),
               ('medical_lab_A',2000),
               ('medical_lab_A',3000),
               ('medical_lab_A',4000),
               ('medical_lab_B',1000),
               ('medical_lab_B',2000),
               ('medical_lab_C',1000), 
               ('medical_lab_C',3000), 
               ('medical_lab_D',4000)]

not_allowed = [(111111,1000),
               (111111,2000),
               (111111,3000),
               (222222,2000)]

test_record = [(10000,2000,111111,11111,'medical_lab_A','abnormal','13-October-2004','13-October-2004'),
               (10001,1000,222222,11111,'medical_lab_A','normal','13-October-2004','13-October-2004'),
               (10002,1000,333333,11111,'medical_lab_A','normal','15-June-2004','15-June-2004'),
               (10003,3000,111111,22222,'medical_lab_A','abnormal','12-October-2004','15-October-2004'),
               (10004,2000,111111,33333,'medical_lab_A','abnormal','11-October-2004','16-October-2004')]


createStr = ("CREATE TABLE patient"
            "(health_care_no int, name  varchar(100) NOT NULL, address varchar(200), birth_day date, phone char(10), PRIMARY KEY(health_care_no), UNIQUE(name,address))")
createStr1 =  ("CREATE TABLE doctor" 
           "(employee_no int, clinic_address  varchar(100) NOT NULL, office_phone char(10), emergence_phone char(10), health_care_no  int, PRIMARY KEY (employee_no),FOREIGN KEY (health_care_no) REFERENCES patient)") 
createStr2  = ("CREATE TABLE medical_lab"
           "(lab_name  varchar(25),address varchar(100) NOT NULL, phone char(10) NOT NULL, PRIMARY KEY (lab_name))")
createStr3 =  ("CREATE TABLE test_type"
           "(type_id int,test_name varchar(48) NOT NULL,pre_requirment varchar(1024),test_procedure varchar(1024),PRIMARY KEY (type_id),UNIQUE (test_name))")
createStr4 = ("CREATE TABLE can_conduct"
           "(lab_name  varchar(25),test_id int,PRIMARY KEY(lab_name,test_id),FOREIGN KEY(lab_name) REFERENCES medical_lab,FOREIGN KEY(test_id) REFERENCES test_type)")
createStr5 = ("CREATE TABLE not_allowed"
           "(health_care_no int,test_id int,PRIMARY KEY(health_care_no, test_id),FOREIGN KEY(health_care_no) REFERENCES patient,FOREIGN KEY(test_id) REFERENCES test_type)")
createStr6 = ("CREATE TABLE test_record"
           "(test_id int,type_id int,patient_no int,employee_no int,medical_lab varchar(25),result varchar(1024),prescribe_date  date,test_date   date,PRIMARY KEY(test_id),FOREIGN KEY (employee_no) REFERENCES doctor,FOREIGN KEY (medical_lab) REFERENCES medical_lab,FOREIGN KEY (type_id) REFERENCES test_type,FOREIGN KEY (patient_no) REFERENCES patient)")
                          



curs.execute("DROP TABLE test_record")
curs.execute("DROP TABLE not_allowed")
curs.execute("DROP TABLE doctor")
curs.execute("DROP TABLE patient")
curs.execute("DROP TABLE can_conduct")
curs.execute("DROP TABLE medical_lab")
curs.execute("DROP TABLE test_type")
 

curs.execute("CREATE TABLE patient"
            "(health_care_no int, name  varchar(100) NOT NULL, address varchar(200), birth_day date, phone char(10), PRIMARY KEY(health_care_no), UNIQUE(name,address))")
cursInsert = connection.cursor()
cursInsert.bindarraysize = 3
cursInsert.setinputsizes(int, 100, 200, datetime.date, 10)
cursInsert.executemany("insert into patient (health_care_no, name, address, birth_day, phone)"
                      "VALUES (:1, :2, :3, :4, :5)", patient)
connection.commit()

                    
curs.execute(createStr1)
cursInsert = connection.cursor()
cursInsert.bindarraysize = 3
cursInsert.setinputsizes(int, 100, 10, 10, int)
cursInsert.executemany("insert into doctor (employee_no, clinic_address, office_phone, emergence_phone, health_care_no)"
                      "VALUES (:1, :2, :3, :4, :5)", doctor)
connection.commit()                      



curs.execute(createStr2)
cursInsert = connection.cursor()
cursInsert.bindarraysize = 4
cursInsert.setinputsizes(25, 100, 10)
cursInsert.executemany("insert into medical_lab (lab_name , address, phone)"
                      "VALUES (:1, :2, :3)", medical_lab)
connection.commit()
                      
curs.execute(createStr3)
cursInsert = connection.cursor()
cursInsert.bindarraysize = 4
cursInsert.setinputsizes(int, 48, 1024, 1024)
cursInsert.executemany("insert into test_type (type_id , test_name, pre_requirment, test_procedure)"
                      "VALUES (:1, :2, :3, :4)", test_type)
connection.commit()
                      
curs.execute(createStr4)
cursInsert = connection.cursor()
cursInsert.bindarraysize = 9
cursInsert.setinputsizes(25, int)
cursInsert.executemany("insert into can_conduct (lab_name , test_id)"
                      "VALUES (:1, :2)", can_conduct)
connection.commit()                        
                      
curs.execute(createStr5)
cursInsert = connection.cursor()
cursInsert.bindarraysize = 5
cursInsert.setinputsizes(int, int)
cursInsert.executemany("insert into not_allowed (health_care_no ,test_id)"
                      "VALUES (:1, :2)", not_allowed)
connection.commit()

curs.execute(createStr6)
cursInsert = connection.cursor()
cursInsert.bindarraysize = 5
cursInsert.setinputsizes(int, int, int, int, 25, 1024, datetime.date, datetime.date)
cursInsert.executemany("insert into test_record (test_id,type_id,patient_no,employee_no,medical_lab,result,prescribe_date,test_date)"
                      "VALUES (:1, :2, :3, :4, :5, :6, :7, :8)", test_record)
connection.commit()

def start():
    print("1,Prescription\n2,Medical Test\n3,Patient Information Update\n4,Search Engine\n5,Exit")
    condition=int(input("What would you like to do today(1,2,3,4,5):"))
    if condition==1:
        gay1.prescription()
    elif condition==2:
        gay2.MedicalTest()
    elif condition == 3:
        gay3.update_patient()
    elif condition == 4:
        gay4.searchengine()        
    elif condition == 5:
        return
    else:
        print("UNKNOW TYPE!")
        start()
start()    
curs.close()
cursInsert.close()
connection.close()
#-----------------------update-----------------------
