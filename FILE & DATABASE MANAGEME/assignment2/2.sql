prompt Question 2 - yyin
select distinct p.name, d.clinic_address
from patient p,test_record t1,test_record t2,test_record t3,doctor d,medical_lab m, test_type tt
where d.health_care_no = p.health_care_no
	and tt.test_name = 'CT scan'
	and tt.type_id = t1.type_id
	and tt.type_id = t2.type_id
	and tt.type_id = t3.type_id
	and t1.employee_no = d.employee_no 
	and t2.employee_no = d.employee_no 
	and t3.employee_no = d.employee_no    
	and to_char(t1.test_date,'dd-mm-yyyy') like '%2004%' 
	and to_char(t2.test_date,'dd-mm-yyyy') like '%2004%'
	and to_char(t3.test_date,'dd-mm-yyyy') like '%2004%';
