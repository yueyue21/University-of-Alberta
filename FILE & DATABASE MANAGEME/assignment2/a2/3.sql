prompt Question 3 - yyin
select p.name,p.address,p.phone
from patient p,not_allowed n
where n.test_id <> 3000005 and n.health_care_no = p.health_care_no;
