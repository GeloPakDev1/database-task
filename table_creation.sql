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

-- Create table for subjects
CREATE TYPE COURSE_LEVEL_ENUM AS ENUM ('Beginner', 'Intermediate', 'Advanced');

CREATE TABLE subjects (
    id               UUID PRIMARY KEY,
    subject_name     VARCHAR(50) NOT NULL,
    tutor            VARCHAR(50) NOT NULL,
    course_level     COURSE_LEVEL_ENUM NOT NULL,
    create_datetime  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_datetime  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for exam results
CREATE TABLE exam_results (
    id               UUID PRIMARY KEY,
    student_id       UUID REFERENCES students(id),
    subject_id       UUID REFERENCES subjects(id),
    mark             INTEGER NOT NULL,
    create_datetime  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_datetime  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
