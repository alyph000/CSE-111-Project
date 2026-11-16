-- ============================================================================
-- CSE 111 Fall 2026: Project Checkpoint 2 Script
-- Project Title: UC Merced Course Catalog & Registration Manager
-- Team Members: Alyssa Phouangpanya, Aman Kalkat
-- File: Checkpoint2-script.sql
-- ============================================================================

-- ============================================================================
-- SCHEMA MODIFICATIONS SINCE CHECKPOINT 1
-- ============================================================================
-- Explain any modifications to your relational schema made since Checkpoint 1.
-- (e.g., added indexes, modified check constraints, renamed columns, or 
--  clarified weak entity vs. junction relationships). If no changes were made, 
--  explicitly state: "No modifications made to the Checkpoint 1 schema."
--
-- Modifications:
-- 1. Removed unique constraints for some attributes to work with data
-- ============================================================================

-- ============================================================================
-- MEMBER CONTRIBUTIONS SUMMARY (GROUPED AT THE TOP)
-- ============================================================================
-- Identify the member contributions to each query or modification statement
-- below. Each statement must sum to 100% across the 2 team members.
--
-- SECTION 1: SIMPLE STATEMENTS
-- Statement 01: Alyssa: 100%, Aman: XX%
-- Statement 02: Alyssa: 100%, Aman: XX%
-- Statement 03: Alyssa: 100%, Aman: XX%
-- Statement 04: Alyssa: 100%, Aman: XX%
-- Statement 05: Alyssa: 100%, Aman: XX%
-- Statement 06: Alyssa: 100%, Aman: XX%
-- Statement 07: Alyssa: 0%, Aman: 100%
-- Statement 08: Alyssa: 0%, Aman: 100%
-- Statement 09: Alyssa: XX%, Aman: XX%
-- Statement 10: Alyssa: XX%, Aman: XX%
--
-- SECTION 2: INTERMEDIATE STATEMENTS
-- Statement 11: Alyssa: 100%, Aman: XX%
-- Statement 12: Alyssa: 100%, Aman: XX%
-- Statement 13: Alyssa: 100%, Aman: XX%
-- Statement 14: Alyssa: 100%, Aman: XX%
-- Statement 15: Alyssa: 100%, Aman: XX%
-- Statement 16: Alyssa: XX%, Aman: XX%
-- Statement 17: Alyssa: XX%, Aman: XX%
-- Statement 18: Alyssa: XX%, Aman: XX%
-- Statement 19: Alyssa: XX%, Aman: XX%
-- Statement 20: Alyssa: XX%, Aman: XX%
--
-- SECTION 3: COMPLEX STATEMENTS
-- Statement 21: Alyssa; 100%, Aman: XX%
-- Statement 22: Alyssa: 100%, Aman: XX%
-- Statement 23: Alyssa: 100%, Aman: XX%
-- Statement 24: Alyssa: 100%, Aman: XX%
-- Statement 25: Alyssa: XX%, Aman: XX%
-- Statement 26: Alyssa: XX%, Aman: XX%
-- Statement 27: Alyssa: XX%, Aman: XX%
-- Statement 28: Alyssa: XX%, Aman: XX%
-- Statement 29: Alyssa: XX%, Aman: XX%
-- Statement 30: Alyssa: XX%, Aman: XX%
-- ============================================================================

-- Ensure SQLite foreign key constraints are enforced
PRAGMA foreign_keys = ON;

-- Set output format for readability during evaluation
.headers on
.mode column


-- ============================================================================
-- SECTION 1: SIMPLE STATEMENTS (Roughly 10 Statements)
-- Focus: Single-table projections/filters, simple inserts/updates/deletes, 
--        basic sorting, simple aggregate functions, and pattern matching.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Statement 01: Filter CSE Students
-- Explanation: Retrieve the student first and last names, student email, and 
--              student enrollment year for students majoring in CSE.
-- ----------------------------------------------------------------------------
SELECT student_firstname, student_lastname, student_email, student_enrollment_year
FROM Students
WHERE student_major_department_id = 4;

-- ----------------------------------------------------------------------------
-- Statement 02: Insert New Student Data
-- Explanation: Inserts data for a new student majoring in CSE.
-- ----------------------------------------------------------------------------
INSERT INTO Students (student_id, student_firstname, student_lastname, student_email, student_enrollment_year, student_major_department_id)
VALUES (10001, "John","Smith", "jsmith@ucmerced.edu", 2026, 4);

-- ----------------------------------------------------------------------------
-- Statement 03: Update Section Meeting Times
-- Explanation: Changes meeting times of section by 1 hour.
-- ----------------------------------------------------------------------------
UPDATE Sections
SET section_start_time = "5:00", section_end_time = "6:45"
WHERE section_id = 45;

-- ----------------------------------------------------------------------------
-- Statement 04: Delete Student Data
-- Explanation: Deletes data for a specific student.
-- ----------------------------------------------------------------------------
DELETE FROM Students
WHERE student_id = 10001;

-- ----------------------------------------------------------------------------
-- Statement 05: Filter Upper Division CSE Courses
-- Explanation: Retrieve codes and names of upper division CSE courses.
-- ----------------------------------------------------------------------------
SELECT DISTINCT course_code, course_name
FROM Courses
WHERE course_department_id = 4 AND course_code LIKE 'CSE 1%'
ORDER BY course_code ASC;

-- ----------------------------------------------------------------------------
-- Statement 06: Insert New Course Section
-- Explanation: Inserts new course section data for CSE 100 in Fall 2025.
-- ----------------------------------------------------------------------------
INSERT INTO Sections (section_id, section_course_id, section_instructor_id, section_room_id, section_term, section_capacity, section_meeting_days, section_start_time, section_end_time)
VALUES (30000, 4433, 25, 22, "Fall 2025", 150, "TR", "4:30", "5:45");

-- ----------------------------------------------------------------------------
-- Statement 07: Count Total Students
-- Explanation: Print the total number of students stored in the database using COUNT.
-- ----------------------------------------------------------------------------
SELECT COUNT(*) AS total_students
FROM Students;

-- ----------------------------------------------------------------------------
-- Statement 08: Update Student Major
-- Explanation: Changes the major of a student (id=1) to CSE, simulating a student changing majors.
-- ----------------------------------------------------------------------------
UPDATE Students
SET student_major_department_id = 4
WHERE student_id = 1;

-- ============================================================================
-- SECTION 2: INTERMEDIATE STATEMENTS (Roughly 10 Statements)
-- Focus: Multi-table inner joins, left outer joins, aggregation with GROUP BY 
--        and HAVING, scalar subqueries, table aliasing, and conditional updates.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Statement 11: Group Students by Major
-- Explanation: Groups number of students by major/department and orders by 
--              descending values (starting from the top majors)
-- ----------------------------------------------------------------------------
SELECT department_name AS major, COUNT(*) AS count
FROM Students
JOIN Departments ON student_major_department_id = department_id
GROUP BY department_id
ORDER BY count DESC;

-- ----------------------------------------------------------------------------
-- Statement 12: Sections Taught by Instructor
-- Explanation: Lists the sections taught by a specific instructor.
-- ----------------------------------------------------------------------------
SELECT *
FROM Sections
JOIN Instructors On section_instructor_id = instructor_id
WHERE instructor_id = 25;

-- ----------------------------------------------------------------------------
-- Statement 13: Sections With More Than 20 Students Enrolled
-- Explanation: Lists the sections that have more than 20 students enrolled
-- ----------------------------------------------------------------------------
SELECT *
FROM Sections
WHERE section_id IN (
    SELECT enrollment_section_id 
    FROM (
        SELECT enrollment_section_id, COUNT(*) AS cnt
        FROM Enrollments
        GROUP BY enrollment_section_id
        HAVING cnt > 20
    )
);

-- ----------------------------------------------------------------------------
-- Statement 14: Number of A Students in Each Major
-- Explanation: Groups students with A grades in course sections by major. 
--              Ordered by descending values (starts from top majors).
-- ----------------------------------------------------------------------------
SELECT department_name AS major, COUNT(*) AS "number of students with As"
FROM Enrollments
JOIN Sections ON enrollment_section_id = section_id
JOIN Courses ON section_course_id = course_id
JOIN Departments ON course_department_id = department_id
WHERE enrollment_grade IN ("A", "A-", "A+")
GROUP BY department_name
ORDER BY "number of students with As" DESC;

-- ----------------------------------------------------------------------------
-- Statement 15: Students in a Section
-- Explanation: Lists students enrolled in a specific section. 
-- ----------------------------------------------------------------------------
SELECT section_id, student_email
FROM Students
JOIN enrollments ON student_id = enrollment_student_id
JOIN sections ON enrollment_section_id = section_id
WHERE section_id = 105;

-- ============================================================================
-- SECTION 3: COMPLEX STATEMENTS (Roughly 10 Statements)
-- Focus: Correlated subqueries (EXISTS/NOT EXISTS), set operations 
--        (UNION, INTERSECT, EXCEPT), Common Table Expressions (WITH / CTEs), 
--        window functions (ROW_NUMBER, DENSE_RANK), VIEW creation/querying, 
--        multi-condition triggers, and complex analytics.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Statement 21: Difference in Enrollment Between Years (2024-2025, 2025-2026) Using CASE
-- Explanation: Calculate the difference in major enrollment between 2024-2025 and 2025-2026.
-- ----------------------------------------------------------------------------
SELECT 
    major,
    ABS(SUM(CASE WHEN student_enrollment_year = '2024' THEN weight ELSE 0 END) - SUM(CASE WHEN student_enrollment_year = '2025' THEN weight ELSE 0 END)) AS '2024-2025',
    ABS(SUM(CASE WHEN student_enrollment_year = '2025' THEN weight ELSE 0 END) - SUM(CASE WHEN student_enrollment_year = '2026' THEN weight ELSE 0 END)) AS '2025-2026'
FROM (
    SELECT department_name AS major, student_enrollment_year, 1 AS weight
    FROM Students
    JOIN Departments ON student_major_department_id = department_id
    WHERE student_enrollment_year = '2024' OR student_enrollment_year = '2025' OR student_enrollment_year = '2026'
) 
GROUP BY major;

-- ----------------------------------------------------------------------------
-- Statement 22: Set Difference (EXCEPT) for CSE Students Enrolled in CSE Courses
-- Explanation: Find names and emails of CSE students enrolled in CSE 120 who have not been enrolled in CSE 107.
-- ----------------------------------------------------------------------------
SELECT student_firstname, student_lastname, student_email
FROM Students
JOIN Enrollments ON student_id = enrollment_student_id
JOIN Sections ON enrollment_section_id = section_id
JOIN Courses ON section_course_id = course_id
WHERE course_code = 'CSE 120'
EXCEPT
SELECT student_firstname, student_lastname, student_email
FROM Students
JOIN Enrollments ON student_id = enrollment_student_id
JOIN Sections ON enrollment_section_id = section_id
JOIN Courses ON section_course_id = course_id
WHERE course_code = 'CSE 107';

-- ----------------------------------------------------------------------------
-- Statement 23: CTE for Students with 3.0 GPA or Higher in Each Major
-- Explanation: Calculate the number of students with a cumulative GPA of 3.0 or higher
--              in each major.
-- ----------------------------------------------------------------------------

WITH grades AS (
    SELECT 
        student_id,
        department_prefix AS major,
        AVG(CASE enrollment_grade
            WHEN 'A+' THEN 4.0
            WHEN 'A' THEN 4.0
            WHEN 'A-' THEN 3.7
            WHEN 'B+' THEN 3.3
            WHEN 'B' THEN 3.0
            WHEN 'B-' THEN 2.7
            WHEN 'C+' THEN 2.3
            WHEN 'C' THEN 2.0
            WHEN 'C-' THEN 1.7
            WHEN 'D+' THEN 1.3
            WHEN 'D' THEN 1.0
            WHEN 'D-' THEN 0.7
            WHEN 'F' THEN 0.0
        END) AS gpa
    FROM Students 
    JOIN Departments ON student_major_department_id = department_id
    JOIN Enrollments ON student_id = enrollment_student_id
    GROUP BY student_id
    HAVING gpa > 3.0
)
SELECT 
    major,
    COUNT(*) AS 'students with a cumulative GPA of 3.0 or higher'
FROM grades
GROUP BY major;

-- ----------------------------------------------------------------------------
-- Statement 24: CTE For Instructor Workload vs Department Avg Workload
-- Explanation: Calculate total sections taught and total students per instructor and compares
--              against the average workload in their department.
-- ----------------------------------------------------------------------------

WITH instructor_load AS (
    SELECT 
        instructor_id,
        instructor_department_id,
        instructor_email,
        COUNT(DISTINCT section_id) AS sections_taught,
        COUNT(enrollment_student_id) AS total_students
    FROM Instructors 
    LEFT JOIN Sections ON instructor_id = section_instructor_id
    LEFT JOIN Enrollments ON section_id = enrollment_section_id
    GROUP BY instructor_id
)
SELECT 
    department_prefix,
    instructor_email,
    sections_taught,
    total_students,
    ROUND(AVG(total_students) OVER (PARTITION BY instructor_department_id), 1) AS dept_avg_students
FROM instructor_load 
JOIN Departments ON instructor_department_id = department_id;
