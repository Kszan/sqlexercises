-- zadanie 2
SELECT count(*)'Pracownicy urodzeni po 1960 roku', gender FROM employees
WHERE year(birth_date) > 1960
group by gender;
-- zadanie 3
select concat(first_name, concat(' ', last_name)) as 'Rekin biznesu' from employees
where year(birth_date) > 1964 and gender = 'M';
-- zadanie 4 policz rekinow biznesu
select count(*) from employees
where year(birth_date) > 1964 and gender = 'M';
-- zadanie 5ile osob pracuje na danym stanowisku
SELECT count(*)'Ilosc stanowisk', concat(title) as 'Nazwa stanowiska' FROM employees.titles
group by title;
-- zadanie 6 ile kobiet i mezczyzn pracuje na danym stanowisku
SELECT e.gender Gender, t.title Nazwa_stanowiska, count(*) as 'liczb apracownikow by gender' FROM employees e, titles t
where e.emp_no = t.emp_no
group by e.gender, t.title
order by e.gender DESC;
-- zadanie 7 Wyświetl zarobki, imie i nazwisko pracownika wraz płcią,
-- którzy zarabiają powyżej 150000 w konstrukcjach z JOIN i podzapytaniem z ANY (uwaga na ALL)
SELECT s.salary Salaries, e.first_name Imie, e.last_name Nazwisko, e.gender Gender FROM employees e, salaries s
where e.emp_no = s.emp_no and salary > 150000;
-- select s.salary Salaries, e.first_name Imie, e.last_name Nazwisko, e.gender Gender
-- from employees e
-- join salaries as s on (e.emp_no = s.emp_no)
-- where s.salary > 150000;
-- SELECT s.salary Salaries, e.first_name Imie, e.last_name Nazwisko, e.gender Gender FROM employees e, salaries s
-- where e.emp_no = s.emp_no and (s.salary, e.gender) = ANY
-- (select s.salary, e.gender from employees as e, salaries as s
-- where e.emp_no = s.emp_no
-- and s.salary > 150000)
-- zadanie 8 Wyświetl zarobki, imię i nazwisko pracownika wraz płcią, którzy zarabiają pomiędzy 145000 a 150000
SELECT s.salary Salaries, e.first_name Imie, e.last_name Nazwisko, e.gender Gender FROM employees e, salaries s
where e.emp_no = s.emp_no and salary between 145000 and 150000;
-- zadanie 9 Wyświetlić mężczyznę i kobietę, którzy zarabiają najwięcej
SELECT max(s.salary), e.gender Gender FROM employees e, salaries s
where e.emp_no = s.emp_no
group by gender;
-- zadanie 10
select a.gender płeć, 
count(a.emp_no) ilośćPracowników, 
avg(b.salary) średnieZarobki, 
sum(b.salary) sumaZarobków, 
max(b.salary) maksymalneZarobki,
min(b.salary) minimalneZarobki
from employees as a 
join salaries as b on (a.emp_no=b.emp_no)
group by a.gender;
-- Zadanie 11. Dodać 250 pracowników do tabeli pracowników
select * from employees where emp_no < 250;
-- zadanie 12 Policz ile jest oddziałów
select count(dept_no) as 'Ilosc departamentow' from employees.departments;
-- zadanie 13 Wyświetl wszystkie zarobki audytowe pracowników, czyli takie, które już się zakończyły
-- select salary as 'Zakonczone zarobki' from employees.salaries
-- where year(to_date) < 9999;
-- zadanie 14 Wyświetl wszystkie zarobki audytowe pracowników, czyli takie, które już się zakończyły
-- Utworz tabele audytowa i przenies tam dane z tabeli zarobkow.
-- 3 instrukcje:
-- select z tabeli zarobkow
-- insert do tabeli audytowej
-- delete z tabeli zarobkow

-- INSERT INTO salaries_audit (emp_no, salary, salary_from_date, salary_to_date)
-- SELECT emp_no, salary, from_date, to_date
-- FROM salaries where salaries.to_date < date('2018-05-27');

-- UPDATE salaries_audit set birth_date =
-- (SELECT e.birth_date 
-- from employees e, salaries_audit sa 
-- where e.emp_no = sa.emp_no);

-- zadanie 14 Dokonać operacji zmiany płci

-- ALTER TABLE employees.employees CHANGE COLUMN gender.gender ENUM('M','F','X') NOT NULL;

-- temp = M;
-- M = F;
-- F = temp;

select * from employees where emp_no = 10001;
ALTER TABLE employees.employees
ADD COLUMN temp ENUM('M', 'F', 'X');

UPDATE employees set temp = 'M' where gender = 'M';
UPDATE employees set gender = 'M' where gender = 'F';
UPDATE employees set gender = 'F' where temp  = 'M';

ALTER TABLE employees.employees
DROP COLUMN temp;

-- zadanie 15 Dokonać odwrotnej operacji zmiany płci w celu przywrócenia danych pierwotnych

delimiter //
CREATE PROCEDURE dodaj_pracownika
(in id INT, in birthDate date, in firstName varchar(20), in lastName varchar(20), in genderParam char, in hireDate date)
 BEGIN insert into employees
 (emp_no, birth_date, first_name, last_name, gender, hire_date)
 values
 (id,birthDate,firstName,lastName,genderParam,hireDate);
END//
delimiter ;

call dodaj_pracownika(935, '1979-11-24', 'RRRRR', 'FFFFFF', 'F', '2008-06-03');

-- zadanie 16 Wykorzystaj instrukcję DATEDIFF i TIMEDIFF

-- zadanie 4  Napisz funkcję obliczającą średnią pensję dla danego stanowiska
delimiter $$
CREATE FUNCTION avgTitleSalary (title CHAR(20)) 
RETURNS INT DETERMINISTIC
-- wziac tytul i pobrac emp_no
-- polaczyc po emp_no tyt z salaries
-- pogrupowac po tytule
-- dla danego tytulu zwrocic srednia
BEGIN
RETURN (select avg(s.salary) from 
titles t,salaries s
where title = titleIn
and t.emp_no = s.emp_no);
END$$
delimiter ;
-- wywolanie
SELECT avgTitleSalary('Senior Engineer');


-- widok
create or replace view avg_salary_per_title AS
select t.title, avg(s.salary) from 
titles t, salaries s
where 
t.emp_no = s.emp_no
group by t.title;

SELECT * FROM avg_salary_per_title;

-- trigger





