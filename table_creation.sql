-- Create table for students
CREATE TABLE students (
    id               UUID PRIMARY KEY,
    name             VARCHAR(50) NOT NULL,
    surname          VARCHAR(50) NOT NULL,
    date_of_birth    DATE NOT NULL,
    phone_number     VARCHAR(20) NOT NULL,
    primary_skill    VARCHAR(30) NOT NULL,
    create_datetime  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_datetime  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for tutors
CREATE TABLE tutors (
    id UUID PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    qualification VARCHAR(100) NOT NULL,
    create_datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for subjects
CREATE TYPE COURSE_LEVEL_ENUM AS ENUM ('Beginner', 'Intermediate', 'Advanced');

CREATE TABLE subjects (
    id               UUID PRIMARY KEY,
    subject_name     VARCHAR(50) NOT NULL,
    tutor_id         UUID,
    course_level     COURSE_LEVEL_ENUM NOT NULL,
    create_datetime  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_datetime  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_tutor
        FOREIGN KEY (tutor_id)
        REFERENCES tutors(id)
);

-- Create table for exam results
CREATE TABLE exam_results (
    id               UUID PRIMARY KEY,
    student_id       UUID,
    subject_id       UUID,
    mark             INTEGER NOT NULL,
    create_datetime  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_datetime  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_student
        FOREIGN KEY (student_id)
        REFERENCES students(id),
    CONSTRAINT fk_subject
        FOREIGN KEY (subject_id)
        REFERENCES subjects(id)
);

-- Create table for enrollments
CREATE TYPE SEMESTER_ENUM AS ENUM ('Spring', 'Summer', 'Fall', 'Winter');

CREATE TABLE enrollments (
    id UUID PRIMARY KEY,
    student_id UUID,
    subject_id UUID,
    academic_year INTEGER NOT NULL,
    semester VARCHAR(10) NOT NULL,
    create_datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_student
        FOREIGN KEY (student_id)
        REFERENCES students(id),
    CONSTRAINT fk_subject
        FOREIGN KEY (subject_id)
        REFERENCES subjects(id)
);

-- Create table for departments
CREATE TABLE departments (
    id UUID PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL,
    create_datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for courses
CREATE TABLE courses (
    id UUID PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    department_id UUID ,
    create_datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_department
        FOREIGN KEY (department_id)
        REFERENCES departments(id)
);
