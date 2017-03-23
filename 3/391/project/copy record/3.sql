------IF-------NULL SPECIFICATION UNDER RECORD SELECTION
select count(*)
from radiology_record rr;
--**********===========GROUP BY ATTRIBUTE(S) IS GIVEN IN PARTICULAR(some rows or a row)=========***************
-----********SINGLE*********** A PARTICULAR ATTRIBUTE IS GIVEN("FOR LOOP"works for a list of patients, a list of types, a list of time intervals)
----ELSE IF------A LIST OF PATIENT(ONLY)
select count(*)
from radiology_record rr,persons p
where rr.patient_id = p.person_id 
and p.first_name = /*input_first_name*/ 
and p.last_name = /*input_last_name*/
/*select rr.patient_id,count(*)
from radiology_record rr
where rr.patient_id in (2,12)
group by rr.patient_id;*/
----ELSE IF------A LIST OF TEST_TYPE(ONLY)
select count(*)
from radiology_record rr
where rr.test_type in /*input_list_of_test_type*/
group by rr.test_type;
----ELSE IF------A LIST OF TIME PERIOD(ONLY) --------------------???????(A LIST OF PATIENTS? A LIST OF TYPES?)-------UNCONCERED FOR THE DOUBLE AND TRIPLES yet
select count(*)
from radiology_record rr
where rr.test_date between /*input1_to_date*/ and /*input2_to_date*/
--**************DOUBLE***************"NESTED FOR LOOP" works for any combination of a patient/a list of patients, a type/a list of types, a time interval/a list of time intercals.
----ELSE IF------(A LIST OF PATIENT && A LIST OF TEST_TYPE)ONLY 
----ELSE IF------(A LIST OF PATIENT && A LIST OF TIME INTERVAL)ONLY
----ELSE IF------(A LIST OF TEST_TYPE && A LIST OF TIME INTERVAL)ONLY
--**************TRIPLE***********************
----ELSE IF------(A LIST OF PATIENT && A LIST OF TEST_TYPE && A LIST OF TIME INTERVAL)ONLY
--*********==================GROUP BY GENERAL(total rows)=============****************
-----********SINGLE***********
----ELSE if------PATIENTS ONLY
select p.first_name,p.last_name,count(*)
from radiology_record rr,persons p
where rr.patient_id = p.person_id
group by p.first_name,p.last_name;
----ELSE IF------TEST_TYPE ONLY
select rr.test_type,count(*)
from radiology_record rr
group by rr.test_type;
----ELSE IF------TIME OF YEAR ONLY(DISTINCT)
select extract(year from rr.test_date),count(*)
from radiology_record rr
group by extract(year from rr.test_date);
----ELSE IF------TIME OF MONTH ONLY(DISTINCT)
select extract(month from rr.test_date),count(*)
from radiology_record rr
group by extract(month from rr.test_date);
----ELSE IF------TIME OF WEEK ONLY(DISTINCT)
select to_char(rr.test_date,'ww'),count(*)
from radiology_record rr
group by to_char(rr.test_date,'ww');
--**************DOUBLE***********************
----ELSE IF------(PATIENTS && TEST_TYPE) ONLY
select p.first_name,p.last_name,rr.test_type,count(rr.test_type)
from radiology_record rr,persons p
where rr.patient_id = p.person_id
group by p.first_name,p.last_name,rr.test_type;
----ELSE IF------(PATIENTS && TIME TO YEAR) ONLY
select p.first_name,p.last_name,extract(year from rr.test_date),count(*)
from radiology_record rr,persons p
where rr.patient_id = p.person_id
group by p.first_name,p.last_name,extract(year from rr.test_date);
----ELSE IF------(PATIENTS && TIME TO YEAR->MONTH) ONLY
select p.first_name,p.last_name,extract(year from rr.test_date),extract(month from rr.test_date),count(*)
from radiology_record rr,persons p
where rr.patient_id = p.person_id
group by p.first_name,p.last_name,extract(year from rr.test_date),extract(month from rr.test_date);
----ELSE IF------(PATIENTS && TIME TO YEAR->MONTH->WEEK) ONLY
select p.first_name,p.last_name,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'w'),count(*)
from radiology_record rr,persons p
where rr.patient_id = p.person_id
group by p.first_name,p.last_name,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'w');
----ELSE IF------(TEST_TYPE && TIME TO YEAR) ONLY
select rr.test_type,extract(year from rr.test_date),count(*)
from radiology_record rr
group by rr.test_type,extract(year from rr.test_date);
----ELSE IF------(TEST_TYPE && TIME TO YEAR->MONTH) ONLY
select rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),count(*)
from radiology_record rr
group by rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date);
----ELSE IF------(TEST_TYPE && TIME TO YEAR->MONTH->WEEK) ONLY
select rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'w'),count(*)
from radiology_record rr
group by rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'w');
--************TRIPLE*************************
----ELSE IF------(PATIENTS && TEST_TYPE && TIME TO YEAR) ONLY
select p.first_name,p.last_name,rr.test_type,extract(year from rr.test_date),count(rr.test_type)
from radiology_record rr,persons p
where rr.patient_id = p.person_id
group by p.first_name,p.last_name,rr.test_type,extract(year from rr.test_date);
----ELSE IF------(PATIENTS && TEST_TYPE && TIME TO YEAR->MONTH) ONLY
select p.first_name,p.last_name,rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),count(rr.test_type)
from radiology_record rr,persons p
where rr.patient_id = p.person_id
group by p.first_name,p.last_name,rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date);
----ELSE IF------(PATIENTS && TEST_TYPE && TIME TO YEAR->MONTH->WEEK) ONLY
select p.first_name,p.last_name,rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'w'),count(rr.test_type)
from radiology_record rr,persons p
where rr.patient_id = p.person_id
group by p.first_name,p.last_name,rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'w');







