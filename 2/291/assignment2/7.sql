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
