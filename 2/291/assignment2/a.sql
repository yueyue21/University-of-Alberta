/*
 *   The script file is used to create the list of all tables
 *   for the medical information system.
 *
 *   We shall first drop all the tables just in case if they were created.
 *
 */

DROP TABLE test_record;
DROP TABLE not_allowed;
DROP TABLE doctor;
DROP TABLE patient;
DROP TABLE can_conduct;
DROP TABLE medical_lab;
DROP TABLE test_type;

CREATE TABLE patient (
    health_care_no int,
    name           varchar(100) NOT NULL,
    address        varchar(200),
    birth_day      date,
    phone          char(10),
    PRIMARY KEY(health_care_no),
    UNIQUE(name,address)
);
insert into patient values(1000000,'Philip','11003-90-Ave-NW-Edmonton-AB','24-Dec-1990',7800000000);
insert into patient values(1000001,'Sam','18203-70-St-NE-Edmonton-AB','12-May-1992',7800000001);
insert into patient values(1000002,'Mark','10034-57-St-SW-Edmonton-AB','7-July-1991',7800000002);
insert into patient values(1000003,'Kim','10969-44-St-SW-Edmonton-AB','30-Sep-1989',7800000003);

CREATE TABLE doctor (
    employee_no     int,
    clinic_address  varchar(100) NOT NULL,
    office_phone    char(10),
    emergence_phone char(10),
    health_care_no  int,
    PRIMARY KEY (employee_no),
    FOREIGN KEY (health_care_no) REFERENCES patient
);
insert into doctor values(2000000,'10394-90-Ave-NW-Edmonton AB',7801000000,7802000000,1000000);
insert into doctor values(2000001,'17568-20-St-NE-Edmonton-AB',7801000001,7802000001,1000001);


CREATE TABLE medical_lab (
    lab_name  varchar(25),
    address   varchar(100) NOT NULL,
    phone     char(10) NOT NULL,
    PRIMARY KEY (lab_name)
);
insert into medical_lab values('a lab','16543-33-Ave-Edmonton AB',7803000000);
insert into medical_lab values('b lab','12452-19-St-Edmonton AB',7803000001);
insert into medical_lab values('c lab','15624-55-St-Calgary AB',7803000001);

CREATE TABLE test_type (
    type_id        int,
    test_name      varchar(48) NOT NULL,
    pre_requirment varchar(1024),
    test_procedure varchar(1024),
    PRIMARY KEY (type_id),
    UNIQUE (test_name)
);
insert into test_type values(3000000,'visual test','patient is able to see','watch coulp of pictures to identify his or her capability');
insert into test_type values(3000001,'audio test','patient is able to hear','listen coulp of music to identify his or her capability');
insert into test_type values(3000002,'feeling test','patient is able to feel','touch coulp of items to identify his or her capability');
insert into test_type values(3000003,'X ray','patient is younger than 60','using X ray to detect liver condition of the patient');
insert into test_type values(3000004,'CT scan','patient is younger than 60','using CT technology to detect liver condition of the patient');
insert into test_type values(3000005,'bone marrow check','patient is younger than 60','using specialized technology to detect bone condition of the patient');
insert into test_type values(3000006,'NULL TEST','xxxxxxxxxxxxxxx','this test is checking for those are allowed to any test in table not_allowed');

CREATE TABLE can_conduct (
    lab_name  varchar(25),
    test_id   int,
    PRIMARY KEY(lab_name,test_id),
    FOREIGN KEY(lab_name) REFERENCES medical_lab,
    FOREIGN KEY(test_id) REFERENCES test_type
);
insert into can_conduct values('a lab',3000000);
insert into can_conduct values('a lab',3000001);
insert into can_conduct values('a lab',3000002);
insert into can_conduct values('b lab',3000001);
insert into can_conduct values('b lab',3000002);
insert into can_conduct values('b lab',3000005);
insert into can_conduct values('c lab',3000003);
insert into can_conduct values('c lab',3000004);
insert into can_conduct values('c lab',3000005);
insert into can_conduct values('c lab',3000002);
 
CREATE TABLE not_allowed (
    health_care_no  int,
    test_id         int,
    PRIMARY KEY(health_care_no, test_id),
    FOREIGN KEY(health_care_no) REFERENCES patient,
    FOREIGN KEY(test_id) REFERENCES test_type
);
insert into not_allowed values(1000001,3000001);
insert into not_allowed values(1000002,3000000);
insert into not_allowed values(1000003,3000005);
insert into not_allowed values(1000000,3000006);


CREATE TABLE test_record (
    test_id     int,
    type_id     int,
    patient_no  int,
    employee_no int,
    medical_lab varchar(25),
    result      varchar(1024),
    prescribe_date  date,
    test_date   date,
    PRIMARY KEY(test_id),
    FOREIGN KEY (employee_no) REFERENCES doctor,
    FOREIGN KEY (medical_lab) REFERENCES medical_lab,
    FOREIGN KEY (type_id) REFERENCES test_type,
    FOREIGN KEY (patient_no) REFERENCES patient
);
insert into test_record values(4000000,3000000,1000001,2000000,'a lab','normal','30-May-2000','2-June-2000');
insert into test_record values(4000001,3000001,1000000,2000001,'b lab','abnormal','30-May-2001','2-June-2001');
insert into test_record values(4000002,3000003,1000002,2000001,'c lab','abnormal','30-May-2005','2-June-2005');
insert into test_record values(4000003,3000004,1000002,2000000,'c lab','abnormal','30-May-2004','2-June-2004');
insert into test_record values(4000004,3000004,1000001,2000000,'c lab','abnormal','30-Sep-2004','2-Oct-2004');
insert into test_record values(4000005,3000004,1000003,2000000,'c lab','normal','30-Jan-2004','2-Feb-2004');
insert into test_record values(4000006,3000004,1000000,2000000,'c lab','normal','5-Jan-2004','7-Feb-2004');
insert into test_record values(4000007,3000004,1000003,2000001,'c lab','normal','30-Jan-2003','2-Feb-2003');
insert into test_record values(4000008,3000004,1000000,2000001,'c lab','normal','5-Jan-2003','7-Feb-2003');
insert into test_record values(4000009,3000005,1000000,2000001,'c lab','normal','5-Jan-2003','7-Feb-2003');
insert into test_record values(4000010,3000005,1000000,2000001,'c lab','normal','5-Jan-2004','7-Feb-2004');



select p.name,p.address
from patient p,test_record t
where p.health_care_no = t.patient_no
	and 2003 > (select extract(year from test_date)
			from test_record
			where(10 > (select extract(month from test_date)
					from test_record
					where(15 > (select extract(day from test_date)
						from test_record
						)))));
select p.name,p.address
from patient p,test_record t
where p.health_care_no = t.patient_no
	and t.type_id not in (	select t1.type_id
				from test_record
				where test_record = 3000003)
				and count(t.test_id)=3
				group by p.name;



























