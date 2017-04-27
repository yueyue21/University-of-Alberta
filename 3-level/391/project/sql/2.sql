--sample

--display the number of images for each patient ,  test type, and/or period of time
drop view l1;
drop view l2;
create view l1 as
select r.patient_id,r.test_type,r.test_date
from radiology_record r,persons p
"'"where"'"-- not null
"'"and"'"--  great than 1 
"'"+"condition 1.+"'"--choose name_id 
"'"+"condition 2.+"'" --choose test_type
"'"+"condition 3.+"'";--choose test_time
group by cube(r.patient_id,r.test_type,r.test_date);

create view l2 as
select l1.patient_id,l1.test_type,l1.test_date
from l1

select count(*) from l2;
