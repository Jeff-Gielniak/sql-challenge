CREATE TABLE "Departments" (
    "dept_no" varchar(30)   NOT NULL,
    "dept_name" varchar(30)   NOT NULL,
    CONSTRAINT "pk_Departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "Department_Employees" (
    "emp_no" int   NOT NULL,
    "dept_no" varchar(30)   NOT NULL,
    CONSTRAINT "pk_Department_Employees" PRIMARY KEY (
        "emp_no","dept_no"
     )
);

CREATE TABLE "Department_Manager" (
    "dept_no" varchar(30)   NOT NULL,
    "emp_no" int   NOT NULL,
    CONSTRAINT "pk_Department_Manager" PRIMARY KEY (
        "dept_no","emp_no"
     )
);

CREATE TABLE "Employees" (
    "emp_no" int   NOT NULL,
    "emp_title_id" varchar(30)   NOT NULL,
    "birth_date" varchar(30)   NOT NULL,
    "first_name" varchar(30)   NOT NULL,
    "last_name" varchar(30)   NOT NULL,
    "sex" varchar(30)   NOT NULL,
    "hire_date" varchar(30)   NOT NULL,
    CONSTRAINT "pk_Employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "Salaries" (
    "emp_no" int   NOT NULL,
    "salary" int   NOT NULL,
    CONSTRAINT "pk_Salaries" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "Titles" (
    "title_id" varchar(30)   NOT NULL,
    "title" varchar(30)   NOT NULL,
    CONSTRAINT "pk_Titles" PRIMARY KEY (
        "title_id"
     )
);

ALTER TABLE "Department_Employees" ADD CONSTRAINT "fk_Department_Employees_emp_no" FOREIGN KEY("emp_no")
REFERENCES "Employees" ("emp_no");

ALTER TABLE "Department_Employees" ADD CONSTRAINT "fk_Department_Employees_dept_no" FOREIGN KEY("dept_no")
REFERENCES "Departments" ("dept_no");

ALTER TABLE "Department_Manager" ADD CONSTRAINT "fk_Department_Manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "Departments" ("dept_no");

ALTER TABLE "Department_Manager" ADD CONSTRAINT "fk_Department_Manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "Employees" ("emp_no");

ALTER TABLE "Employees" ADD CONSTRAINT "fk_Employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "Titles" ("title_id");

ALTER TABLE "Salaries" ADD CONSTRAINT "fk_Salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "Employees" ("emp_no");


--List the employee number, last name, first name, sex, and salary of each employee

SELECT "Employees".emp_no, "Employees".first_name, "Employees".last_name, 
"Employees".sex, "Salaries".salary
FROM public."Employees"
INNER JOIN public."Salaries" 
ON "Employees".emp_no = "Salaries".emp_no;

--List the first name, last name, and hire date for the employees who were hired in 1986
SELECT "Employees".first_name, "Employees".last_name, "Employees".hire_date
FROM public."Employees"
WHERE hire_date LIKE '%1986%';

--List the manager of each department along with their department number, department name, 
--employee number, last name, and first name 
SELECT "Department_Manager".dept_no, "Department_Manager".emp_no, "Departments".dept_name, "Employees".last_name, "Employees".first_name
FROM public."Department_Manager"
JOIN public."Departments" ON "Department_Manager".dept_no = "Departments".dept_no
JOIN public."Employees" ON "Department_Manager".emp_no = "Employees".emp_no;

--List the department number for each employee along with that employee’s employee number, 
--last name, first name, and department name 
SELECT "Employees".first_name, "Employees".last_name, "Employees".emp_no, "Departments".dept_name, "Department_Employees".dept_no
FROM public."Employees"
JOIN public."Department_Employees" ON "Department_Employees".emp_no = "Employees".emp_no
JOIN public."Departments" ON "Departments".dept_no = "Department_Employees".dept_no;

--List first name, last name, and sex of each employee whose first name is Hercules 
--and whose last name begins with the letter B 
SELECT "Employees".first_name, "Employees".last_name, "Employees".sex
FROM public."Employees"
WHERE last_name LIKE 'B%' and first_name LIKE '%Hercules%';

--List each employee in the Sales department, including their employee number, last name, and first name
SELECT "Employees".first_name, "Employees".last_name, "Employees".emp_no, "Department_Employees".dept_no
FROM public."Employees"
JOIN public."Department_Employees" ON "Department_Employees".emp_no = "Employees".emp_no
WHERE dept_no = 'd007';


--List each employee in the Sales and Development departments, including their employee number, 
--last name, first name, and department name
SELECT "Departments".dept_name, "Department_Employees".dept_no, "Department_Employees".emp_no, "Employees".first_name, "Employees".last_name
FROM public."Department_Employees"
--JOIN public."Department_Employees" ON "Department_Employees".emp_no = "Employees".emp_no
JOIN public."Departments" ON "Departments".dept_no = "Department_Employees".dept_no
JOIN public."Employees" ON "Employees".emp_no = "Department_Employees".emp_no
WHERE dept_name = 'Sales' OR dept_name = 'Development';

--List the frequency counts, in descending order, of all the employee last names 
--(that is, how many employees share each last name)
SELECT last_name, COUNT(*) AS frequency
FROM public."Employees"
GROUP BY last_name
ORDER BY frequency DESC;