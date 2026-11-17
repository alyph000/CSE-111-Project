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
-- Statement 01: Alyssa: 100%, Aman: 0%
-- Statement 02: Alyssa: 100%, Aman: 0%
-- Statement 03: Alyssa: 100%, Aman: 0%
-- Statement 04: Alyssa: 100%, Aman: 0%
-- Statement 05: Alyssa: 100%, Aman: 0%
-- Statement 06: Alyssa: 100%, Aman: 0%
-- Statement 07: Alyssa: 0%, Aman: 100%
-- Statement 08: Alyssa: 0%, Aman: 100%
-- Statement 09: Alyssa: 0%, Aman: 100%
-- Statement 10: Alyssa: 0%, Aman: 100%
--
-- SECTION 2: INTERMEDIATE STATEMENTS
-- Statement 11: Alyssa: 100%, Aman: 0%
-- Statement 12: Alyssa: 100%, Aman: 0%
-- Statement 13: Alyssa: 100%, Aman: 0%
-- Statement 14: Alyssa: 100%, Aman: 0%
-- Statement 15: Alyssa: 100%, Aman: 0%
-- Statement 16: Alyssa: 0%, Aman: 100%
-- Statement 17: Alyssa: 0%, Aman: 100%
-- Statement 18: Alyssa: 0%, Aman: 100%
-- Statement 19: Alyssa: 0%, Aman: 100%
-- Statement 20: Alyssa: 0%, Aman: 100%
--
-- SECTION 3: COMPLEX STATEMENTS
-- Statement 21: Alyssa: 100%, Aman: 0%
-- Statement 22: Alyssa: 100%, Aman: 0%
-- Statement 23: Alyssa: 100%, Aman: 0%
-- Statement 24: Alyssa: 100%, Aman: 0%
-- Statement 25: Alyssa: 0%, Aman: 100%
-- Statement 26: Alyssa: 0%, Aman: 100%
-- Statement 27: Alyssa: 0%, Aman: 100%
-- Statement 28: Alyssa: 0%, Aman: 100%
-- Statement 29: Alyssa: 0%, Aman: 100%
-- Statement 30: Alyssa: 0%, Aman: 100%
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

-- ----------------------------------------------------------------------------
-- Statement 09: Filter larger Lecture halls
-- Explanation: Retrieve the building, room number, and capacity of classrooms
-- that seat 100 or more students, ordered from largest to smallest.
-- ----------------------------------------------------------------------------
SELECT room_building, room_number, room_capacity
FROM Classrooms
WHERE room_capacity >= 100
ORDER BY room_capacity DESC;

-- ----------------------------------------------------------------------------
-- Statement 10: Insert a new course prereq
-- Explanation: Inserts a prerequisite requiring CSE 030 to be completed before CSE 111.
-- ----------------------------------------------------------------------------
INSERT INTO Prerequisites (prerequisite_course_id, prerequisite_prereq_course_id, prerequisite_requirement_type)
VALUES (6638, 6629, 'Required');

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

-- ----------------------------------------------------------------------------
-- Statement 16: Courses that require CSE 100
-- Explanation: Lists every course that has CSE 100 as a
-- prerequisite.
-- ----------------------------------------------------------------------------
SELECT c.course_code AS course, c.course_name, c.course_catalog_year AS catalog_year
FROM Prerequisites p
JOIN Courses c ON p.prerequisite_course_id = c.course_id
JOIN Courses pre ON p.prerequisite_prereq_course_id = pre.course_id
WHERE pre.course_code = 'CSE 100'
ORDER BY c.course_catalog_year;

-- ----------------------------------------------------------------------------
-- Statement 17: Underenrolled CSE sections in Fall 2026
-- Explanation: Lists Fall 2026 CSE sections with fewer than 5 students enrolled. 
-- ----------------------------------------------------------------------------
SELECT s.section_id, c.course_code, s.section_capacity, COUNT(e.enrollment_student_id) AS enrolled
FROM Sections s
JOIN Courses c ON s.section_course_id = c.course_id
LEFT JOIN Enrollments e ON s.section_id = e.enrollment_section_id
WHERE c.course_department_id = 4 AND s.section_term = 'Fall 2026'
GROUP BY s.section_id
HAVING COUNT(e.enrollment_student_id) < 5
ORDER BY enrolled, s.section_id;

-- ----------------------------------------------------------------------------
-- Statement 18: Full or overenrolled Sections
-- Explanation: Lists sections whose enrollment count has reached or passed the
-- capacity of the classroom they meet in, along with the room details.
-- ----------------------------------------------------------------------------
SELECT s.section_id, s.section_term, r.room_building, r.room_number, r.room_capacity,
    COUNT(e.enrollment_student_id) AS enrolled
FROM Sections s
JOIN Classrooms r ON s.section_room_id = r.room_id
JOIN Enrollments e ON s.section_id = e.enrollment_section_id
GROUP BY s.section_id
HAVING COUNT(e.enrollment_student_id) >= r.room_capacity
ORDER BY s.section_term, s.section_id;

-- ----------------------------------------------------------------------------
-- Statement 19: Move full Fall 2026 sections to the largest room
-- Explanation: For Fall 2026 sections that are full, moves them into the largest
-- classroom and raises their capacity to match that room.
-- ----------------------------------------------------------------------------
UPDATE Sections
SET section_room_id = (SELECT room_id FROM Classrooms ORDER BY room_capacity DESC, room_id LIMIT 1),
    section_capacity = (SELECT MAX(room_capacity) FROM Classrooms)
WHERE section_term = 'Fall 2026'
  AND section_capacity <= (SELECT COUNT(*) FROM Enrollments WHERE enrollment_section_id = Sections.section_id);

-- ----------------------------------------------------------------------------
-- Statement 20: Instructors with heavy teaching loads
-- Explanation: Lists instructors who teach more than twice the average number of
-- sections per instructor.
-- ----------------------------------------------------------------------------
SELECT i.instructor_firstname, i.instructor_lastname, i.instructor_email, COUNT(s.section_id) AS sections_taught
FROM Instructors i
JOIN Sections s ON i.instructor_id = s.section_instructor_id
GROUP BY i.instructor_id
HAVING COUNT(s.section_id) > 2 * (
    SELECT COUNT(*) * 1.0 / COUNT(DISTINCT section_instructor_id) FROM Sections
)
ORDER BY sections_taught DESC;

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

-- ----------------------------------------------------------------------------
-- Statement 25: Students Eligible to Take CSE 120
-- Explanation: Finds students who have passed (C- or better) every prerequisite of
-- CSE 120.
-- ----------------------------------------------------------------------------
SELECT st.student_id, st.student_firstname, st.student_lastname, st.student_email
FROM Students st
WHERE NOT EXISTS (
    SELECT 1
    FROM Prerequisites p
    JOIN Courses pre ON p.prerequisite_prereq_course_id = pre.course_id
    WHERE p.prerequisite_course_id = 6639
      AND NOT EXISTS (
          SELECT 1
          FROM Enrollments e
          JOIN Sections s ON e.enrollment_section_id = s.section_id
          JOIN Courses c ON s.section_course_id = c.course_id
          WHERE e.enrollment_student_id = st.student_id
            AND c.course_code = pre.course_code
            AND e.enrollment_grade NOT IN ('D+', 'D', 'D-', 'F')
      )
)
ORDER BY st.student_lastname;

-- ----------------------------------------------------------------------------
-- Statement 26: Full Prerequisite Chain for CSE 120
-- Explanation: Uses a recursive CTE to list every course that must be completed
--              before CSE 120, and how many levels down it is.
-- ----------------------------------------------------------------------------
WITH RECURSIVE chain(course_id, depth) AS (
    SELECT prerequisite_prereq_course_id, 1
    FROM Prerequisites
    WHERE prerequisite_course_id = 6639
    UNION
    SELECT p.prerequisite_prereq_course_id, ch.depth + 1
    FROM Prerequisites p
    JOIN chain ch ON p.prerequisite_course_id = ch.course_id
)
SELECT c.course_code, c.course_name, MAX(ch.depth) AS levels_below_cse120
FROM chain ch
JOIN Courses c ON ch.course_id = c.course_id
GROUP BY c.course_id
ORDER BY levels_below_cse120 DESC;

-- ----------------------------------------------------------------------------
-- Statement 27: Top 3 iinstructos per dept. by number of students taught
-- Explanation: Ranks instructors within each department by total students taught
-- using DENSE_RANK, and shows the top 3 in every department.
-- ----------------------------------------------------------------------------
SELECT department_prefix, instructor_name, total_students, dept_rank
FROM (
    SELECT d.department_prefix,
           i.instructor_firstname || ' ' || i.instructor_lastname AS instructor_name,
           COUNT(e.enrollment_student_id) AS total_students,
           DENSE_RANK() OVER (PARTITION BY d.department_id ORDER BY COUNT(e.enrollment_student_id) DESC) AS dept_rank
    FROM Instructors i
    JOIN Departments d ON i.instructor_department_id = d.department_id
    LEFT JOIN Sections s ON i.instructor_id = s.section_instructor_id
    LEFT JOIN Enrollments e ON s.section_id = e.enrollment_section_id
    GROUP BY i.instructor_id
)
WHERE dept_rank <= 3
ORDER BY department_prefix, dept_rank;

-- ----------------------------------------------------------------------------
-- Statement 28: Student transcript View
-- Explanation: Creates a view joining each student to the courses, terms, and grades
-- they have enrolled in, then queries it to show student 1's transcript.
-- ----------------------------------------------------------------------------
DROP VIEW IF EXISTS StudentTranscript;
CREATE VIEW StudentTranscript AS
SELECT st.student_id, st.student_firstname, st.student_lastname,
       s.section_term, c.course_code, c.course_name, c.course_credits, e.enrollment_grade
FROM Students st
JOIN Enrollments e ON st.student_id = e.enrollment_student_id
JOIN Sections s ON e.enrollment_section_id = s.section_id
JOIN Courses c ON s.section_course_id = c.course_id;

SELECT section_term, course_code, course_name, course_credits, enrollment_grade
FROM StudentTranscript
WHERE student_id = 1
ORDER BY section_term;

-- ----------------------------------------------------------------------------
-- Statement 29: CSE dept directory using UNION
-- Explanation: Combines CSE students and CSE instructors into one contact list,
-- labeling each person's role and sorting by last name.
-- ----------------------------------------------------------------------------
SELECT 'Student' AS role, student_firstname AS firstname, student_lastname AS lastname, student_email AS email
FROM Students
WHERE student_major_department_id = 4
UNION
SELECT 'Instructor', instructor_firstname, instructor_lastname, instructor_email
FROM Instructors
WHERE instructor_department_id = 4
ORDER BY lastname;

-- ----------------------------------------------------------------------------
-- Statement 30: Students who took both CSE 30 and CSE 100 
-- Explanation: Finds names and emails of students who have enrolled in both CSE 030
--  and CSE 100, using INTERSECT to keep only students in both lists.
-- ----------------------------------------------------------------------------
SELECT student_firstname, student_lastname, student_email
FROM Students
JOIN Enrollments ON student_id = enrollment_student_id
JOIN Sections ON enrollment_section_id = section_id
JOIN Courses ON section_course_id = course_id
WHERE course_code = 'CSE 030'
INTERSECT
SELECT student_firstname, student_lastname, student_email
FROM Students
JOIN Enrollments ON student_id = enrollment_student_id
JOIN Sections ON enrollment_section_id = section_id
JOIN Courses ON section_course_id = course_id
WHERE course_code = 'CSE 100';
