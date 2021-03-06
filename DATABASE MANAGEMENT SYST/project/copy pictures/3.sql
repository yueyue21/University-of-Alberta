------IF-------NULL SPECIFICATION UNDER picture SELECTION
select count(*)
from pacs_images pp;
--**********===========GROUP BY ATTRIBUTE GIVEN IN PARTICULAR(a row)=========***************
-----********SINGLE*********** 
----ELSE IF------A PATIENT(ONLY)
select count(*)
from radiology_record rr,persons p,pacs_images pp
where rr.patient_id = p.person_id
and pp.record_id = rr.record_id
and p.first_name = 'White'/*input_first_name*/ 
and p.last_name = 'Apple'/*input_last_name*/
----ELSE IF------A LIST OF TEST_TYPE(ONLY)
select count(*)
from radiology_record rr,pacs_images pp
where rr.test_type = 'US'/*input_test_type*/ 
and pp.record_id = rr.record_id;
----ELSE IF------A TIME PERIOD(ONLY)
select count(*)
from radiology_record rr,pacs_images pp
where rr.test_date between '01-May-2007' /*input1_to_date*/ and '01-May-2008'/*input2_to_date*/
and pp.record_id = rr.record_id;
--**************DOUBLE***************
----ELSE IF------(A PATIENT && A TEST_TYPE)ONLY
select count(*)
from radiology_record rr,persons p,pacs_images pp
where rr.patient_id = p.person_id
and pp.record_id = rr.record_id
and rr.test_type='MRI'/*input_test_type*/ 
and p.first_name='Xiaocong'/*input_first_name*/ 
and p.last_name ='Zhou'/*input_last_name*/
----ELSE IF------(A PATIENT && A TIME INTERVAL)ONLY
select count(*)
from radiology_record rr,persons p,pacs_images pp
where rr.patient_id = p.person_id
and pp.record_id = rr.record_id
and p.first_name= 'Jojo'/*input_first_name*/ 
and p.last_name ='Star'/*input_last_name*/
and rr.test_date between '01-May-2008'/*input1_to_date*/ and '30-May-2009' /*input2_to_date*/
----ELSE IF------(A TEST_TYPE && A TIME INTERVAL)ONLY
select count(*)
from radiology_record rr,pacs_images pp
where rr.test_type= 'MRI'/*input_test_type*/ 
and pp.record_id = rr.record_id
and rr.test_date between '01-May-2008'/*input1_to_date*/ and '30-May-2009'/*input2_to_date*/
--**************TRIPLE***********************
----ELSE IF------(A PATIENT && A TEST_TYPE && A TIME INTERVAL)ONLY
select count(*)
from radiology_record rr,persons p,pacs_images pp
where rr.patient_id = p.person_id
and pp.record_id = rr.record_id
and rr.test_type='X-ray'/*input_test_type*/ 
and p.first_name='Xiaocong'/*input_first_name*/ 
and p.last_name ='Zhou'/*input_last_name*/
and rr.test_date between '01-May-2008'/*input1_to_date*/ and '30-May-2009'/*input2_to_date*/
--*********==================GROUP BY GENERAL(total rows)=============****************
-----********SINGLE***********
----ELSE if------PATIENTS ONLY
select p.first_name,p.last_name,count(*)
from radiology_record rr,persons p,pacs_images pp
where rr.patient_id = p.person_id
and pp.record_id = rr.record_id
group by p.first_name,p.last_name;
----ELSE IF------TEST_TYPE ONLY
select rr.test_type,count(*)
from radiology_record rr,pacs_images pp
where pp.record_id = rr.record_id
group by rr.test_type;
----ELSE IF------TIME OF YEAR ONLY(DISTINCT)
select extract(year from rr.test_date),count(*)
from radiology_record rr,pacs_images pp
where pp.record_id = rr.record_id
group by extract(year from rr.test_date);
----ELSE IF------TIME OF MONTH ONLY(DISTINCT)
select extract(month from rr.test_date),count(*)
from radiology_record rr,pacs_images pp
where pp.record_id = rr.record_id
group by extract(month from rr.test_date);
----ELSE IF------TIME OF WEEK ONLY(DISTINCT)
select to_char(rr.test_date,'ww'),count(*)
from radiology_record rr,pacs_images pp
where pp.record_id = rr.record_id
group by to_char(rr.test_date,'ww');
--**************DOUBLE***********************---------
----ELSE IF------(PATIENTS && TEST_TYPE) ONLY
select p.first_name,p.last_name,rr.test_type,count(*)
from radiology_record rr,persons p,pacs_images pp
where rr.patient_id = p.person_id
and pp.record_id = rr.record_id
group by p.first_name,p.last_name,rr.test_type;
----ELSE IF------(PATIENTS && TIME TO YEAR) ONLY
select p.first_name,p.last_name,extract(year from rr.test_date),count(*)
from radiology_record rr,persons p,pacs_images pp
where rr.patient_id = p.person_id
and pp.record_id = rr.record_id
group by p.first_name,p.last_name,extract(year from rr.test_date);
----ELSE IF------(PATIENTS && TIME TO YEAR->MONTH) ONLY
select p.first_name,p.last_name,extract(year from rr.test_date),extract(month from rr.test_date),count(*)
from radiology_record rr,persons p,pacs_images pp
where rr.patient_id = p.person_id
and pp.record_id = rr.record_id
group by p.first_name,p.last_name,extract(year from rr.test_date),extract(month from rr.test_date);
----ELSE IF------(PATIENTS && TIME TO YEAR->WEEK) ONLY
select p.first_name,p.last_name,extract(year from rr.test_date),to_char(rr.test_date,'ww'),count(*)
from radiology_record rr,persons p,pacs_images pp
where rr.patient_id = p.person_id
and pp.record_id = rr.record_id
group by p.first_name,p.last_name,extract(year from rr.test_date),to_char(rr.test_date,'ww');
----ELSE IF------(PATIENTS && TIME TO MONTH->WEEK) ONLY
select p.first_name,p.last_name,extract(month from rr.test_date),to_char(rr.test_date,'w'),count(*)
from radiology_record rr,persons p,pacs_images pp
where rr.patient_id = p.person_id
and pp.record_id = rr.record_id
group by p.first_name,p.last_name,extract(month from rr.test_date),to_char(rr.test_date,'w');
----ELSE IF------(PATIENTS && TIME TO YEAR->MONTH->WEEK) ONLY
select p.first_name,p.last_name,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'w'),count(*)
from radiology_record rr,persons p,pacs_images pp
where rr.patient_id = p.person_id
and pp.record_id = rr.record_id
group by p.first_name,p.last_name,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'w');
----ELSE IF------(TEST_TYPE && TIME TO YEAR) ONLY
select rr.test_type,extract(year from rr.test_date),count(*)
from radiology_record rr,pacs_images pp
where pp.record_id = rr.record_id
group by rr.test_type,extract(year from rr.test_date);
----ELSE IF------(TEST_TYPE && TIME TO YEAR->MONTH) ONLY
select rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),count(*)
from radiology_record rr,pacs_images pp
where pp.record_id = rr.record_id
group by rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date);
----ELSE IF------(TEST_TYPE && TIME TO YEAR->WEEK) ONLY
select rr.test_type,extract(year from rr.test_date),to_char(rr.test_date,'ww'),count(*)
from radiology_record rr,pacs_images pp
where pp.record_id = rr.record_id
group by rr.test_type,extract(year from rr.test_date),to_char(rr.test_date,'ww');
----ELSE IF------(TEST_TYPE && TIME TO MONTH->WEEK) ONLY
select rr.test_type,extract(month from rr.test_date),to_char(rr.test_date,'w'),count(*)
from radiology_record rr,pacs_images pp
where pp.record_id = rr.record_id
group by rr.test_type,extract(month from rr.test_date),to_char(rr.test_date,'w');
----ELSE IF------(TEST_TYPE && TIME TO YEAR->MONTH->WEEK) ONLY
select rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'w'),count(*)
from radiology_record rr,pacs_images pp
where pp.record_id = rr.record_id
group by rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'w');
--************TRIPLE*************************
----ELSE IF------(PATIENTS && TEST_TYPE && TIME TO YEAR) ONLY
select p.first_name,p.last_name,rr.test_type,extract(year from rr.test_date),count(*)
from radiology_record rr,persons p,pacs_images pp
where rr.patient_id = p.person_id
and pp.record_id = rr.record_id
group by p.first_name,p.last_name,rr.test_type,extract(year from rr.test_date);
----ELSE IF------(PATIENTS && TEST_TYPE && TIME TO YEAR->MONTH) ONLY
select p.first_name,p.last_name,rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),count(*)
from radiology_record rr,persons p,pacs_images pp
where rr.patient_id = p.person_id
and pp.record_id = rr.record_id
group by p.first_name,p.last_name,rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date);
----ELSE IF------(PATIENTS && TEST_TYPE && TIME TO YEAR->WEEK) ONLY
select p.first_name,p.last_name,rr.test_type,extract(year from rr.test_date),to_char(rr.test_date,'ww'),count(*)
from radiology_record rr,persons p,pacs_images pp
where rr.patient_id = p.person_id
and pp.record_id = rr.record_id
group by p.first_name,p.last_name,rr.test_type,extract(year from rr.test_date),to_char(rr.test_date,'ww');
----ELSE IF------(PATIENTS && TEST_TYPE && TIME TO MONTH->WEEK) ONLY
select p.first_name,p.last_name,rr.test_type,extract(month from rr.test_date),to_char(rr.test_date,'w'),count(*)
from radiology_record rr,persons p,pacs_images pp
where rr.patient_id = p.person_id
and pp.record_id = rr.record_id
group by p.first_name,p.last_name,rr.test_type,extract(month from rr.test_date),to_char(rr.test_date,'w');
----ELSE IF------(PATIENTS && TEST_TYPE && TIME TO YEAR->MONTH->WEEK) ONLY
select p.first_name,p.last_name,rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'w'),count(*)
from radiology_record rr,persons p,pacs_images pp
where rr.patient_id = p.person_id
and pp.record_id = rr.record_id
group by p.first_name,p.last_name,rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'w');







