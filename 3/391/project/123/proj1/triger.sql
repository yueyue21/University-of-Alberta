CREATE OR REPLACE TRIGGER user_manage_insert
BEFORE INSERT ON persons
FOR EACH ROW
DECLARE counter INTEGER;
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
	SELECT count(*) INTO counter
	FROM persons
	WHERE person_id = :NEW.person_id;

	IF counter > 0
	THEN
		raise_application_error(-20101, 'The ID has already been registrated!');
	END IF;
COMMIT;
END;
/

CREATE OR REPLACE TRIGGER user_manage_insert1
BEFORE UPDATE OR INSERT ON persons
FOR EACH ROW
DECLARE counter INTEGER;
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
	SELECT count(*) INTO counter
	FROM persons p
	WHERE email = :NEW.email AND
		p.person_id <> :NEW.person_id;

	IF counter > 0
	THEN
		raise_application_error(-20102, 'The email has already been registrated!');
	END IF;
COMMIT;
END;
/

CREATE OR REPLACE TRIGGER user_manage_insert2
BEFORE UPDATE OR INSERT ON users
FOR EACH ROW
DECLARE counter INTEGER;
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
	SELECT count(*) INTO counter
	FROM users p
	WHERE user_name = :NEW.user_name AND
		p.person_id <> :NEW.person_id;

	IF counter > 0
	THEN
		raise_application_error(-20103, 'The user name has already been registrated!');
	END IF;
COMMIT;
END;
/

CREATE OR REPLACE TRIGGER user_manage_insert3
BEFORE INSERT ON users
FOR EACH ROW
DECLARE counter INTEGER;
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
	SELECT count(*) INTO counter
	FROM persons p
	WHERE p.person_id = :NEW.person_id;

	IF counter < 1
	THEN
		raise_application_error(-20104, 'The users person ID does not exist!');
	END IF;
COMMIT;
END;
/

CREATE OR REPLACE TRIGGER user_manage_insert4
BEFORE UPDATE OR INSERT ON family_doctor
FOR EACH ROW
DECLARE counter INTEGER;
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
	SELECT count(*) INTO counter
	FROM family_doctor
	WHERE doctor_id = :NEW.doctor_id AND
		patient_id  = :NEW.patient_id;

	IF counter > 0
	THEN
		raise_application_error(-20105, 'The pair has already been recorded!');
	END IF;
COMMIT;
END;
/

CREATE OR REPLACE TRIGGER user_manage_insert5
BEFORE UPDATE OR INSERT ON family_doctor
FOR EACH ROW
DECLARE counter INTEGER;
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
	SELECT count(*) INTO counter
	FROM persons p1, persons p2
	WHERE p1.person_id = :NEW.doctor_id and
		p2.person_id  = :NEW.patient_id;

	IF counter < 1
	THEN
		raise_application_error(-20106, 'Not a exist id!');
	END IF;
COMMIT;
END;
/
