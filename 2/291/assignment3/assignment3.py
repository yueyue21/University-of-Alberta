import sys
import cx_Oracle

def createTable():
	connStr = 'yyin/lovewww410412340@gwynne.cs.ualberta.ca:1521/CRS'
	creat_patient = ("CREATE TABLE patient" 
	                 "(health_care_no int,name varchar(100) NOT NULL,"
	                  "address        varchar(200),"
	                  "birth_day      date,"
	                  "phone          char(10),"
	                  "PRIMARY KEY(health_care_no),"
	                  "UNIQUE(name,address))"
	                  )
	creat_doctor = ("CREATE TABLE doctor "
	               "(employee_no     int,"
	               "clinic_address  varchar(100) NOT NULL,"
	               "office_phone    char(10),"
	               "emergence_phone char(10),"
	               "health_care_no  int,"
	               "PRIMARY KEY (employee_no),"
	               "FOREIGN KEY (health_care_no) REFERENCES patient)"
	               )
	creat_medical_lab =("CREATE TABLE medical_lab "
	                   "(lab_name  varchar(25),"
	                   "address   varchar(100) NOT NULL,"
	                   "phone     char(10) NOT NULL,"
	                   "PRIMARY KEY (lab_name))"
	                   )
	creat_test_type=("CREATE TABLE test_type "
	                "(type_id        int,"
	                "test_name      varchar(48) NOT NULL,"
	                "pre_requirment varchar(1024),"
	                "test_procedure varchar(1024),"
	                "PRIMARY KEY (type_id),"
	                "UNIQUE (test_name))"
	                )
	creat_can_conduct=("CREATE TABLE can_conduct "
	                 "(lab_name  varchar(25),"
	                 "test_id   int,"
	                 "PRIMARY KEY(lab_name,test_id),"
	                 "FOREIGN KEY(lab_name) REFERENCES medical_lab,"
	                 "FOREIGN KEY(test_id) REFERENCES test_type)"	
	                 )
	creat_not_allowed=("CREATE TABLE not_allowed "
	                  "(health_care_no  int,"
	                  "test_id         int,"
	                  "PRIMARY KEY(health_care_no, test_id),"
	                  "FOREIGN KEY(health_care_no) REFERENCES patient,"
	                  "FOREIGN KEY(test_id) REFERENCES test_type)"
	                  )
	creat_test_record=("CREATE TABLE test_record "
	                  "(test_id     int,"
	                  "type_id     int,"
	                  "patient_no  int,"
	                  "employee_no int,"
	                  "medical_lab varchar(25),"
	                  "result      varchar(1024),"
	                  "prescribe_date  date,"
	                  "test_date   date,"
	                  "PRIMARY KEY(test_id),"
	                  "FOREIGN KEY (employee_no) REFERENCES doctor,"
	                  "FOREIGN KEY (medical_lab) REFERENCES medical_lab,"
	                  "FOREIGN KEY (type_id) REFERENCES test_type,"
	                  "FOREIGN KEY (patient_no) REFERENCES patient)"
	                  )
	
	try:
		connection = cx_Oracle.connect(connStr)
		curs = connection.cursor()
		
		#curs.execute("DROP TABLE patient")
		#curs.execute("DROP TABLE doctor")
		#curs.execute("DROP TABLE medical_lab")
		#curs.execute("DROP TABLE test_type")
		#curs.execute("DROP TABLE can_conduct")
		#curs.execute("DROP TABLE not_allowed")
		#curs.execute("DROP TABLE test_record")
		
		#curs.execute(creat_patient)
		#curs.execute(creat_doctor)#--------------??
		#curs.execute(creat_medical_lab)
		#curs.execute(creat_test_type)
		#curs.execute(creat_can_conduct)#-------------?
		#curs.execute(creat_not_allowed)#--------?
		#curs.execute(creat_test_record)#-------?
		
		#data = [('Quadbury', 101, 7.99, 0, 0),
		#	('Almond roca', 102, 8.99, 0, 0),
		#	('Golden Key', 103, 3.99, 0, 0)]

		#cursInsert = connection.cursor()
		#cursInsert.bindarraysize = 3
		#cursInsert.setinputsizes(32, int, float, int, int)
		#cursInsert.executemany("INSERT INTO TOFFEES(T_NAME, SUP_ID, PRICE, SALES, TOTAL) " 
		#	"VALUES (:1, :2, :3, :4, :5)", data)
		#connection.commit()
		
		
		#curs.execute("SELECT * from TOFFEES")
		#rows = curs.fetchall()
		#for row in rows:
		#	print(row)
		
		curs.close()
		#cursInsert.close()
		connection.close()
	except cx_Oracle.DatabaseError as exc:
		error, = exc.args
		print( sys.stderr, "Oracle code:", error.code)
		print( sys.stderr, "Oracle message:", error.message)
		
if __name__ == "__main__":
    createTable()
