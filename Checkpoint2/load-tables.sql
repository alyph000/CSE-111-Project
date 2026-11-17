.open Checkpoint2-dbase.sqlite3
.mode csv
.import --skip 1 departments.csv Departments
.import --skip 1 instructors.csv Instructors
.import --skip 1 classrooms.csv Classrooms
.import --skip 1 students.csv Students
.import --skip 1 courses.csv Courses
.import --skip 1 sections.csv Sections
.import --skip 1 enrollments.csv Enrollments
.import --skip 1 prerequisites.csv Prerequisites