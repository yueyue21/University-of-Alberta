prompt Question 4 - yyin
select p.name,p.address,p.phone
from patient p,test_record t
where to_char(t.test_date,'dd-mm-yyyy') like '%2003%'
	and p.health_care_no = t.patient_no
	and 	(select count(t3.patient_no)
		from test_record t3
		where to_char(t.test_date,'dd-mm-yyyy') like '%2003%'
		and t.patient_no = t3.patient_no
		group by t3.patient_no) > (	(select count(t1.test_id)
								from test_record t1
								where to_char(t.test_date,'dd-mm-yyyy') like '%2003%')/	(select count(distinct t2.patient_no)
															from test_record t2
															where to_char(t.test_date,'dd-mm-yyyy') like '%2003%')	);

