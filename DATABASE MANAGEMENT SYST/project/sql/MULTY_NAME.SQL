drop view PT1;
create view PT1 as
select rr.patient_id,rr.test_type
from radiology_record rr
group by cube(rr.patient_id,rr.test_type);
--select *from PT1;
select PT1.patient_id,PT1.test_type,count(PT1.test_type)
from PT1
group by PT1.patient_id,PT1.test_type;
