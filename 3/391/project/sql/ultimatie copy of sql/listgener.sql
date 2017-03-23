-- name, address and phone number of the patient, and testing date of the first radiology record 

(select p.person_id, p.first_name, p.last_name, p.address, p.phone ,min(rr.test_date), rr.diagnosis
	from	persons p, radiology_record rr
	where	p.person_id = rr.patient_id and
		rr.diagnosis = 'bladder cancer' and
		rr.test_date between '07-May-2001' and '23-May-2015'
	group by p.person_id, p.first_name, p.last_name, p.address, p.phone, rr.diagnosis
);

