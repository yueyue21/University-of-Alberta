prompt Question 1 - yyin
select p.name, p.address, p.phone 
from patient p,test_record t 
where p.health_care_no = t.patient_no and t.medical_lab = 'c lab';
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
prompt Question 3 - yyin
select p.name,p.address,p.phone
from patient p,not_allowed n
where n.test_id <> 3000005 and n.health_care_no = p.health_care_no;
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

prompt Question 6 - yyin
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

prompt Question 7 - yyin
SELECT  extract (year from t1.test_date),t2.type_id,   
            count(distinct t2.test_id)/count(distinct(t1.test_id) abnormal_rate
FROM     test_record t1, test_record t2
WHERE   t2.result not like 'normal'  AND
                 extract (year from t1.test_date) = extract (year from t2.test_date) AND 
                 t1.type_id = t2.type_id
		 AND extract (year from t1.test_date) between 2000 and 2004
		 AND extract (year from t2.test_date) between 2000 and 2004
GROUP BY  extract (year from t1.test_date),t2.type_id;
prompt Question 8 - yyin
prompt Question 9 - yyin
