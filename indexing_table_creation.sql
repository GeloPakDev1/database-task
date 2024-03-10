-- Prepare tables for index testing

-- Create table for students
CREATE TABLE students_indexing (
    id               SERIAL      PRIMARY KEY,
    name             VARCHAR(50) NOT NULL,
    surname          VARCHAR(50) NOT NULL,
    date_of_birth    DATE        NOT NULL,
    phone_number     VARCHAR(20) NOT NULL,
    primary_skill    JSONB       NOT NULL,
    create_datetime  TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    update_datetime  TIMESTAMP   DEFAULT CURRENT_TIMESTAMP
);

-- Create table for tutors
CREATE TABLE tutors_indexing (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    qualification VARCHAR(100) NOT NULL,
    create_datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for subjects
CREATE TABLE subjects_indexing (
    id               SERIAL PRIMARY KEY,
    subject_name     VARCHAR(50) NOT NULL,
    tutor_id         SERIAL,
    course_level     JSONB NOT NULL,
    create_datetime  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_datetime  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_tutor
        FOREIGN KEY (tutor_id)
        REFERENCES tutors_indexing(id)
);

-- Create table for exam results
CREATE TABLE exam_results_indexing (
    id               SERIAL PRIMARY KEY,
    student_id       SERIAL,
    subject_id       SERIAL,
    mark             INTEGER NOT NULL,
    create_datetime  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_datetime  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_student
        FOREIGN KEY (student_id)
        REFERENCES students_indexing(id),
    CONSTRAINT fk_subject
        FOREIGN KEY (subject_id)
        REFERENCES subjects_indexing(id)
);



--Craete index on students_indexing table columns
 CREATE INDEX students_name ON students_indexing (name);
 CREATE INDEX students_surname ON students_indexing USING HASH (surname);
 CREATE INDEX students_primary_skill ON students_indexing USING GIN(primary_skill);
 CREATE INDEX students_phone_number ON students_indexing USING GIST (phone_number);

--Craete index on tutors_indexing table columns
 CREATE INDEX tutors_name ON tutors_indexing (name);
 CREATE INDEX tutors_email ON tutors_indexing USING HASH (email);
 CREATE INDEX tutors_phone_number ON tutors_indexing USING GIST (phone_number);

--Craete index on subjects_indexing table columns
 CREATE INDEX subjects_subject_name ON subjects_indexing (subject_name);
 CREATE INDEX subjects_course_level ON subjects_indexing USING GIST (course_level);

--Craete index on exam_results_indexing table columns
 CREATE INDEX exam_student_id ON exam_results_indexing USING HASH(student_id);
 CREATE INDEX exam_subject_id ON exam_results_indexing USING HASH(subject_id);

--Test data retrieval 
 EXPLAIN ANALYZE SELECT * FROM students_indexing WHERE name = 'oiCxNaKTTgVA'
 EXPLAIN ANALYZE SELECT * FROM students_indexing WHERE surname LIKE 'vUcPgeTFyko%'
 EXPLAIN ANALYZE SELECT * FROM students_indexing WHERE phone_number = '__3456789%'

 EXPLAIN ANALYZE SELECT * FROM tutors_indexing WHERE name = 'NvMGFqfr'
 EXPLAIN ANALYZE SELECT * FROM tutors_indexing WHERE phone_number = 'Surname98711'

 EXPLAIN ANALYZE SELECT s.id AS student_id, s.name AS student_name, s.surname, e.mark
 FROM students_indexing s
 JOIN exam_results_indexing e ON s.id = e.student_id
 WHERE s.surname LIKE 'pUUlbGxeZkax';



