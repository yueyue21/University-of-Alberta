select p.first_name,p.last_name,count(*)
from radiology_record rr,persons p
where rr.patient_id = p.person_id 
and p.first_name in ('Yue','White') 
and 'Apple' in (select p1.last_name 
			from persons p1, radiology_record rr1 
			where rr1.patient_id = p1.person_id 
			and p1.first_name = p.first_name)
group by p.first_name,p.last_name;
