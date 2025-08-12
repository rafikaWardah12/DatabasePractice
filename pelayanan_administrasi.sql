/*
SELECT d.dept_no, d.dept_name, title COUNT(*) AS number_of_employees
FROM dept_emp e
JOIN departments d ON e.emp_no = d.dept_no
WHERE e.to_date = '9999-01-01';


/*
SELECT e.emp_no AS 'Employee number', e.first_name AS 'Employee first name', e.last_name AS 'Employee last name', de.to_date AS 'Tittle', d.dept_name AS 'Department name'
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
Where de.to_date != '9999';
GROUP BY e.emp_no, e.first_name, e.last_name, de.to_date, d.dept_name;*/

/*
SELECT dept_no, dept_name, title, emp_no, jumlah_karyawan_aktif FROM (
	SELECT dept_no, dept_name, emp_no, dept_emp.to_date, titles.to_date, title, count(emp_no) jumlah_karyawan_aktif
	FROM dept_emp 
	JOIN titles USING(emp_no)
	JOIN departments USING(dept_no)
	GROUP BY dept_emp.emp_no, titles.emp_no
	HAVING YEAR(dept_emp.to_date) = '9999-01-01' AND YEAR(titles.to_date) = '9999-01-01'
);
*/

/*
SELECT d.dept_no AS 'Department number', d.dept_name AS 'Department name', e.emp_no AS 'Employee number', CONCAT(e.first_name, ' ', e.last_name) AS 'Employee full name', s.salary AS 'Salary'
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
JOIN salaries s ON e.emp_no = s.emp_no
WHERE de.to_date = '9999-01-01' AND s.to_date = '9999-01-01';
*/

/*
SELECT e.emp_no AS 'Employee number', e.first_name AS 'First Name', e.last_name AS 'Last Name', t.title AS 'Title', t.from_date AS 'Title from date', t.to_date AS 'Title to date', d.dept_name AS 'Department name', de.from_date AS 'Department employee from date', de.to_date AS 'Department employee to date'
FROM employees e
JOIN titles t ON e.emp_no = t.emp_no
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
ORDER BY e.emp_no, t.from_date;
*/
/*
SELECT e.emp_no AS 'Employee number',
       e.first_name AS 'Employee first name',
       e.last_name AS 'Employee last name',
       t.title AS 'Title',
       d.dept_name AS 'Department name'
FROM employees e
JOIN titles t ON e.emp_no = t.emp_no
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE (t.to_date = '9999-01-01' OR t.to_date IS NULL) AND
      (de.to_date = '9999-01-01' OR de.to_date IS NULL)
ORDER BY e.emp_no;

*/
/*SELECT d.dept_no AS 'Department number', d.dept_name AS 'Department name', 
       t.title AS 'Title', COUNT(e.emp_no) AS 'Number of employees'
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
JOIN titles t ON e.emp_no = t.emp_no
WHERE de.to_date = '9999-01-01'
GROUP BY d.dept_no, t.title
ORDER BY d.dept_no, t.title;
*/
/*
SELECT e.emp_no AS 'Employee number',
       e.first_name AS 'Employee first name',
       e.last_name AS 'Employee last name',
       t.title AS 'Title',
       d.dept_name AS 'Department name'
FROM employees e
JOIN titles t ON e.emp_no = t.emp_no
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE (t.to_date = '9999-01-01' OR t.to_date IS NULL) AND
      (de.to_date = '9999-01-01' OR de.to_date IS NULL)
ORDER BY e.emp_no;
*/

/*
SELECT e.first_name AS 'Employee first name',
       e.last_name AS 'Employee last name',
       t.title AS 'Title',
       d.dept_name AS 'Departemen'
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
JOIN titles t ON e.emp_no = t.emp_no
where (t.emp_no = 'Senior Engineer') AND (d.dept_no = 'Production')
ORDER BY e.emp_no;

memnampilkan data employee yang memiliki jabatan (tittle) senior engineer dan bekerja di departemen production
  
*/
/*
SELECT e.emp_no AS 'Employee number',
       e.first_name AS 'First name',
       e.last_name AS 'Last name',
       t.title AS 'Title',
       d.dept_name AS 'Department name'
FROM employees e
JOIN titles t ON e.emp_no = t.emp_no
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE t.title = 'Senior Engineer'
  AND d.dept_name = 'Production';
*/
/*
menampilkan manager terakhir dari masing-masing departemen
*/

explain Select d.dept_no AS 'Department number',
       d.dept_name AS 'Department name',
       CONCAT(e.first_name, ' ', e.last_name) AS 'Manager name',
       e.emp_no AS 'Manager number'
FROM departments d 
JOIN dept_manager dm ON d.dept_no = dm.dept_no
JOIN employees e ON dm.emp_no = e.emp_no
WHERE dm.to_date = '9999-01-01'
GROUP BY d.dept_no, d.dept_name, e.first_name, e.last_name, e.emp_no;




