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

