prompt Question 5 - yyin
select p.name,p.address,p.phone
from patient p,test_record t
where p.health_care_no = t.patient_no 
	and t.patient_no not in(select t1.patient_no
				from test_record t1
				where t1.medical_lab = (select m.lab_name/*'c lab'*/
							from medical_lab m,can_conduct c1
							where m.lab_name = c1.lab_name 
								group by m.lab_name
								having count(c1.test_id) = /*max type for a lab*/(select count(c2.test_id)
														from can_conduct c2
														where count(c2.test_id) >= c1.test_id)));

