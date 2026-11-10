PRAGMA foreign_keys = ON;

/*

Relationships (8)
    M:N
        Courses M : N Courses 
        Students M : N Sections ("enrolled in")
    1:M
        Departments 1 : M Students
        Departments 1 : M Instructors 
        Departments 1 : M Courses 
        Courses 1 : N Sections 
        Instructors 1 : N Sections 
        Classrooms 1 : N Sections 
    1:1
    

*/

CREATE TABLE Departments (
    department_id INTEGER PRIMARY KEY,
    department_prefix CHAR(4) UNIQUE NOT NULL,
    department_name VARCHAR(40) NOT NULL
);

CREATE TABLE Classrooms (
    room_id INTEGER PRIMARY KEY,
    room_building VARCHAR(40) NOT NULL,
    room_number DECIMAL(3, 0) NOT NULL,
    room_capacity INTEGER NOT NULL,
    UNIQUE (room_building, room_number)
);

CREATE TABLE Students (
    student_id INTEGER PRIMARY KEY,
    student_firstname VARCHAR(20) NOT NULL,
    student_lastname VARCHAR(20) NOT NULL,
    student_email VARCHAR(40) UNIQUE NOT NULL,
    student_enrollment_year DECIMAL(4, 0),
    student_major_department_id INTEGER,
    FOREIGN KEY (student_major_department_id) REFERENCES Departments(department_id)
);

CREATE TABLE Instructors (
    instructor_id INTEGER PRIMARY KEY,
    instructor_firstname VARCHAR(20) NOT NULL,
    instructor_lastname VARCHAR(20) NOT NULL,
    instructor_email VARCHAR(40) UNIQUE NOT NULL,
    instructor_department_id INTEGER,
    FOREIGN KEY (instructor_department_id) REFERENCES Departments(department_id)
);

CREATE TABLE Courses (
    course_id INTEGER PRIMARY KEY,
    course_department_id INTEGER NOT NULL,
    course_code VARCHAR(10) UNIQUE NOT NULL,
    course_name VARCHAR(40) NOT NULL,
    course_credits INTEGER,
    course_description VARCHAR(255),
    course_catalog_year VARCHAR(10),
    FOREIGN KEY (course_department_id) REFERENCES Departments(department_id)
);

CREATE TABLE Prerequisites (
    prerequisite_course_id INTEGER NOT NULL,
    prerequisite_prereq_course_id INTEGER NOT NULL,
    prerequisite_requirement_type VARCHAR(20),
    PRIMARY KEY (prerequisite_course_id, prerequisite_prereq_course_id),
    FOREIGN KEY (prerequisite_course_id) REFERENCES Courses(course_id),
    FOREIGN KEY (prerequisite_prereq_course_id) REFERENCES Courses(course_id),
    CHECK (prerequisite_course_id <> prerequisite_prereq_course_id)
);


CREATE TABLE Sections (
    section_id INTEGER PRIMARY KEY,
    section_course_id INTEGER NOT NULL,
    section_instructor_id INTEGER,
    section_room_id INTEGER,
    section_term VARCHAR(10) NOT NULL,
    section_capacity INTEGER,
    section_meeting_days VARCHAR(10),
    section_start_time TIME,
    section_end_time TIME,
    FOREIGN KEY (section_course_id) REFERENCES Courses(course_id),
    FOREIGN KEY (section_instructor_id) REFERENCES Instructors(instructor_id),
    FOREIGN KEY (section_room_id) REFERENCES Classrooms(room_id)
);

CREATE TABLE Enrollments (
    enrollment_student_id INTEGER NOT NULL,
    enrollment_section_id INTEGER NOT NULL,
    enrollment_grade VARCHAR(2),
    enrollment_enrollment_date DATE,
    PRIMARY KEY (enrollment_student_id, enrollment_section_id),
    FOREIGN KEY (enrollment_student_id) REFERENCES Students(student_id),
    FOREIGN KEY (enrollment_section_id) REFERENCES Sections(section_id)
);
