drop view l1;
create view l1 as
select rr.patient_id, rr.test_type, rr.test_date
from radiology_record rr,persons p
--"'"where"'"-- not null
--"'"and"'"--  great than 1 
--"'"+"condition 1.+"'"--choose name_id 
--"'"+"condition 2.+"'" --choose test_type

where --IF NAME ENTERED
	p.person_id = rr.patinet_id and p.first_name = 'first name' and p.last_name = 'last name'------- pre
and   --IF TEST_TYPE ENTERED
	rr.test_type = 'test_type'
group by cube(rr.patient_id,rr.test_type,rr.test_date);

--year starting
--"'"+"condition 3.+"'";--choose test_time
-----IF IF IF IF IF IF IF IF IF IF IF IF IF  TIME ENTERED
replace view l1 as
select l1.patient_id,l1.test_type,l1.test_date
from l1

select count(*) from l2;
