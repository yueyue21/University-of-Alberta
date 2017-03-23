select count(*)
from radiology_record rr,pacs_images pp
where rr.test_date between '01-05-2007'  and '01-05-2008'
and pp.record_id = rr.record_id;
