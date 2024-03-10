--Create trigger that will update column updated_datetime to current date in case of updating any of student.
CREATE OR REPLACE FUNCTION update_update_datetime()
RETURNS TRIGGER AS $$
BEGIN
    NEW.update_datetime := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER students_update_trigger
BEFORE UPDATE ON students
FOR EACH ROW
EXECUTE FUNCTION update_update_datetime();

--Create validation on DB level that will check username on special characters ('@', '#', '$') 
ALTER TABLE students
ADD CONSTRAINT check_name_no_special_characters
CHECK (name !~* '[@#$]');

--Create snapshot that will contain next data: student name, student surname, subject name, mark
CREATE VIEW snapshot AS
SELECT s.name AS student_name,
       s.surname AS student_surname,
       sb.subject_name,
       er.mark
FROM students s
JOIN exam_results er ON s.id = er.student_id
JOIN subjects sb ON er.subject_id = sb.id;

--Create function that will return average mark for input user
CREATE OR REPLACE FUNCTION get_average_mark(user_id UUID)
RETURNS FLOAT AS $$
DECLARE
    avg_mark FLOAT;
BEGIN
    SELECT AVG(mark)
    INTO avg_mark
    FROM exam_results
    WHERE student_id = user_id;

    RETURN avg_mark;
END;
$$ LANGUAGE plpgsql;

--Create function that will return avarage mark for input subject name
CREATE OR REPLACE FUNCTION get_average_mark_for_subject(subject_name VARCHAR)
RETURNS FLOAT AS $$
DECLARE
    avg_mark FLOAT;
BEGIN
    SELECT AVG(er.mark)
    INTO avg_mark
    FROM exam_results er
    JOIN subjects sb ON er.subject_id = sb.id
    WHERE sb.subject_name = subject_name;

    RETURN avg_mark;
END;
$$ LANGUAGE plpgsql;

--Create function that will return student at "red zone" (red zone means at least 2 marks <=3)
CREATE OR REPLACE FUNCTION get_students_in_red_zone()
RETURNS TABLE (
    student_id UUID,
    student_name VARCHAR,
    student_surname VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT s.id AS student_id, 
           s.name AS student_name, 
           s.surname AS student_surname
    FROM students s
    WHERE (
        SELECT COUNT(*)
        FROM exam_results er
        WHERE er.student_id = s.id AND er.mark <= 3
    ) >= 2;
END;
$$ LANGUAGE plpgsql;