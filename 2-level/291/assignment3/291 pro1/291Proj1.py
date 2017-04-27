import cx_Oracle
import datetime

login='xiaocong/samisda38@gwynne.cs.ualberta.ca:1521/CRS'
connection = cx_Oracle.connect(login)
curs = connection.cursor()

#patient(health_care_no, name, address,birth_day, phone)
#doctor(employee_no,clinic_address,office_phone,emergency_phone,health_care_no)
#medical_lab(lab_name,address,phone)
#test_type(type_id,test_name,pre_requirement,test_procedure)
#can_conduct(lab_name, type_id)
#not_allowed(health_care_no,type_id)
#test_record(test_id,type_id,patient_no,employee_no,medical_lab,result,prescribe_date,test_date)

patient = [(111111,'Sam','9910-100st, Edmonton Alberta','01-October-1985','7800000001'),
        (222222,'Sammy','9939-105st, Prince Albert Saskatchewan','30-September-1974','7800000002'),
        (333333,'Peter','5112-39st. Vancouver British Columbia','19-July-1988','7800000003'),
        (444444,'Paul','9701-52st. Terrace British Columbia','03-June-1989','7800000004'),
        (555555,'Armstrong','10102-109st. Camrose Alberta','11-May-1965','7800000005'),
        (666666,'Lily','5701-12st. Whitehorse Yukon','22-May-1980','7800000006'),
        (777777,'Lukia','57-102st. Whitehorse Yukon','01-May-1970','7800000006')]

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
               (222222,2000),
               (444444,2000)]

test_record = [(10000,2000,111111,11111,'medical_lab_A','abnormal','13-October-2004','13-October-2004'),
               (10001,1000,222222,11111,'medical_lab_A','normal','13-October-2004','13-October-2004'),
               (10002,1000,333333,11111,'medical_lab_A','normal','15-June-2004','15-June-2004'),
               (10003,1000,444444,11111,'medical_lab_B','abnormal','21-September-2004','21-September-2004'),
               (10004,1000,555555,11111,'medical_lab_C','normal','01-May-2003','01-May-2003')]


formatlist=[("CREATE TABLE patient" "(health_care_no int, name  varchar(100) NOT NULL, address varchar(200), birth_day date, phone char(10)"),
            ("CREATE TABLE doctor" "(employee_no int, clinic_address  varchar(100) NOT NULL, office_phone char(10), emergence_phone char(10), health_care_no  int, PRIMARY KEY (employee_no),FOREIGN KEY (health_care_no) REFERENCES patient)"),
            ("CREATE TABLE medical_lab" "(lab_name  varchar(25),address varchar(100) NOT NULL, phone char(10) NOT NULL, PRIMARY KEY (lab_name))"),
            ("CREATE TABLE test_type" "(type_id int,test_name varchar(48) NOT NULL,pre_requirment varchar(1024),test_procedure varchar(1024),PRIMARY KEY (type_id),UNIQUE (test_name))"),
            ("CREATE TABLE can_conduct" "(lab_name  varchar(25),test_id int,PRIMARY KEY(lab_name,test_id),FOREIGN KEY(lab_name) REFERENCES medical_lab,FOREIGN KEY(test_id) REFERENCES test_type)"),
            ("CREATE TABLE not_allowed" "(health_care_no int,test_id int,PRIMARY KEY(health_care_no, test_id),FOREIGN KEY(health_care_no) REFERENCES patient,FOREIGN KEY(test_id) REFERENCES test_type)"),
            ("CREATE TABLE test_record" "(test_id int,type_id int,patient_no int,employee_no int,medical_lab varchar(25),result varchar(1024),prescribe_date  date,test_date   date,PRIMARY KEY(test_id),FOREIGN KEY (employee_no) REFERENCES doctor,FOREIGN KEY (medical_lab) REFERENCES medical_lab,FOREIGN KEY (type_id) REFERENCES test_type,FOREIGN KEY (patient_no) REFERENCES patient)")
            ]

createStr = ("CREATE TABLE patient"
            "(health_care_no int, name  varchar(100) NOT NULL, address varchar(200), birth_day date, phone char(10)")
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
                          

#curs.execute("DROP TABLE test_record")
#urs.execute("DROP TABLE not_allowed")
#curs.execute("DROP TABLE can_conduct")
#curs.execute("DROP TABLE medical_lab")
#curs.execute("DROP TABLE test_type")
curs.execute("DROP TABLE patient")

curs.execute(createStr)
cursInsert = connection.cursor()
cursInsert.bindarraysize = 7
cursInsert.setinputsizes(int, 100, 200, datetime.date, 10)
cursInsert.executemany("insert into patient (health_care_no, name, address, birth_day, phone)"
                      "VALUES (:1, :2, :3, :4, :5)", patient)
connection.commit()


curs.execute("DROP TABLE patient")

curs.close()
cursInsert.close()
connection.close()