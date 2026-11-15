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
-- 1. [Description of schema modification 1, or None]
-- 2. [Description of schema modification 2]
-- ============================================================================

-- ============================================================================
-- MEMBER CONTRIBUTIONS SUMMARY (GROUPED AT THE TOP)
-- ============================================================================
-- Identify the member contributions to each query or modification statement
-- below. Each statement must sum to 100% across the 2 team members.
--
-- SECTION 1: SIMPLE STATEMENTS
-- Statement 01: [Member 1]: XX%, [Member 2]: XX%
-- Statement 02: [Member 1]: XX%, [Member 2]: XX%
-- Statement 03: [Member 1]: XX%, [Member 2]: XX%
-- Statement 04: [Member 1]: XX%, [Member 2]: XX%
-- Statement 05: [Member 1]: XX%, [Member 2]: XX%
-- Statement 06: [Member 1]: XX%, [Member 2]: XX%
-- Statement 07: [Member 1]: XX%, [Member 2]: XX%
-- Statement 08: [Member 1]: XX%, [Member 2]: XX%
-- Statement 09: [Member 1]: XX%, [Member 2]: XX%
-- Statement 10: [Member 1]: XX%, [Member 2]: XX%
--
-- SECTION 2: INTERMEDIATE STATEMENTS
-- Statement 11: [Member 1]: XX%, [Member 2]: XX%
-- Statement 12: [Member 1]: XX%, [Member 2]: XX%
-- Statement 13: [Member 1]: XX%, [Member 2]: XX%
-- Statement 14: [Member 1]: XX%, [Member 2]: XX%
-- Statement 15: [Member 1]: XX%, [Member 2]: XX%
-- Statement 16: [Member 1]: XX%, [Member 2]: XX%
-- Statement 17: [Member 1]: XX%, [Member 2]: XX%
-- Statement 18: [Member 1]: XX%, [Member 2]: XX%
-- Statement 19: [Member 1]: XX%, [Member 2]: XX%
-- Statement 20: [Member 1]: XX%, [Member 2]: XX%
-- Statement 21: [Member 1]: XX%, [Member 2]: XX%
--
-- SECTION 3: COMPLEX STATEMENTS
-- Statement 22: [Member 1]: XX%, [Member 2]: XX%
-- Statement 23: [Member 1]: XX%, [Member 2]: XX%
-- Statement 24: [Member 1]: XX%, [Member 2]: XX%
-- Statement 25: [Member 1]: XX%, [Member 2]: XX%
-- Statement 26: [Member 1]: XX%, [Member 2]: XX%
-- Statement 27: [Member 1]: XX%, [Member 2]: XX%
-- Statement 28: [Member 1]: XX%, [Member 2]: XX%
-- Statement 29: [Member 1]: XX%, [Member 2]: XX%
-- Statement 30: [Member 1]: XX%, [Member 2]: XX%
-- Statement 31: [Member 1]: XX%, [Member 2]: XX%
-- Statement 32: [Member 1]: XX%, [Member 2]: XX%
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
SET section_start_time = "3:30", section_end_time = "4:45"
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
VALUES (1001, 4433, 25, 22, "Fall 2025", 150, "TR", "4:30", "5:45");

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
-- Statement 13: Sections With More Than 5 Students Enrolled
-- Explanation: Lists the sections that have more than 5 students enrolled
-- ----------------------------------------------------------------------------
SELECT *
FROM Sections
WHERE section_id IN (
    SELECT enrollment_section_id 
    FROM (
        SELECT enrollment_section_id, COUNT(*) AS cnt
        FROM Enrollments
        GROUP BY enrollment_section_id
        HAVING cnt > 5
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
-- Statement 21: Difference in Enrollment Between Years (2024-2025, 2025-2026)
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

-- [Continue Statements 23 through 32...]