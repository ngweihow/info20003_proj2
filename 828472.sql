/*SQL Queries Database Systems Project 2
 *Code written by Wei How Ng (828472)
 */

/*Q1*/
SELECT name, COUNT(Student.firstname) AS NumberOfStudents
FROM Course INNER JOIN Student ON Course.id = Student.course
GROUP BY name
ORDER BY name, NumberOfStudents;

/*Q2*/
SELECT code, COUNT(Student.firstname) AS NumberOfStudents  	
FROM Student INNER JOIN StudentTakesSubject ON StudentTakesSubject.student = Student.id
WHERE result <= 50 AND result IS NOT NULL 
GROUP BY code
	HAVING COUNT(Student.firstname) > 1
ORDER BY code, NumberOfStudents;

/*Q3*/
SELECT Student.id, 300 -SUM(Subject.creditpoints) AS CreditRemaining
FROM StudentTakesSubject NATURAL JOIN Subject 
	INNER JOIN Student ON StudentTakesSubject.student = Student.id
WHERE Subject.yearlevel != 9 
	AND StudentTakesSubject.result >= 50
    AND StudentTakesSubject.result IS NOT NULL
GROUP BY Student.id;

/*Q4*/
SELECT Student.id, lastname, Course.name, 
	   SUM(StudentTakesSubject.result * Subject.creditpoints)/
       SUM(Subject.creditpoints) AS GPA
FROM StudentTakesSubject NATURAL JOIN Subject 
	INNER JOIN Student ON StudentTakesSubject.student = Student.id
    INNER JOIN Course ON Student.course = Course.id
WHERE Subject.yearlevel != 9 
    AND StudentTakesSubject.result IS NOT NULL
GROUP BY Student.id
	HAVING COUNT(StudentTakesSubject.code) > 4;

/*Q5*/
SELECT CONCAT(Lecturer.firstname," " ,Lecturer.lastname),
	   StudentTakesSubject.result,
	   CONCAT(Subject.area,Subject.yearlevel,Subject.code)
FROM StudentTakesSubject NATURAL JOIN Subject
	 INNER JOIN Lecturer ON Subject.lecturer = Lecturer.id
ORDER BY StudentTakesSubject.result DESC
LIMIT 1;

/*Q6*/
SELECT CONCAT(Student.firstname," ", Student.lastname) AS StudentName,
	StudentTakesSubject.result,
	CASE 
		WHEN StudentTakesSubject.result < 50 THEN 'N'
		WHEN StudentTakesSubject.result >= 50 
			AND StudentTakesSubject.result < 65 THEN 'P'
		WHEN StudentTakesSubject.result >= 65 
			AND StudentTakesSubject.result < 70 THEN 'H3'
		WHEN StudentTakesSubject.result >= 70 
			AND StudentTakesSubject.result < 75 THEN 'H2B'
		WHEN StudentTakesSubject.result >= 75 
			AND StudentTakesSubject.result < 80 THEN 'H2A' 
		WHEN StudentTakesSubject.result >= 80 THEN 'H1' 
    END AS 'Grade' 
FROM Student INNER JOIN StudentTakesSubject 
		ON Student.id = StudentTakesSubject.student
     INNER JOIN
	 (SELECT *
	  FROM Student INNER JOIN StudentTakesSubject 
		ON Student.id = StudentTakesSubject.student
	  WHERE CONCAT(StudentTakesSubject.area, 
		   StudentTakesSubject.yearlevel,
		   StudentTakesSubject.code) = 'COMP10001'
		   AND StudentTakesSubject.result >= 50
		   AND StudentTakesSubject.result IS NOT NULL) AS T
	 ON Student.id = T.id
WHERE StudentTakesSubject.result IS NOT NULL;

/*Q7*/
SELECT DISTINCT CONCAT(Lecturer.firstname," " ,Lecturer.lastname) AS Lecturers
FROM Lecturer INNER JOIN Subject
	ON Lecturer.id = Subject.lecturer
GROUP BY Lecturer.id
HAVING SUM(CASE WHEN Subject.yearlevel < 4 THEN 1 ELSE 0 END) > 0
	AND SUM(CASE WHEN Subject.yearlevel = 9 THEN 1 ELSE 0 END) > 0;


/*Q8*/
SELECT CONCAT(Lecturer.firstname," " ,Lecturer.lastname) AS Lecturer
FROM Lecturer INNER JOIN Subject
	ON Subject.lecturer = Lecturer.id
GROUP BY Lecturer.id
HAVING (SELECT COUNT(DISTINCT StudyArea.id)
		FROM StudyArea) = COUNT(DISTINCT Subject.area);

/*Q9*/
SELECT CONCAT(Student.firstname, " ", Student.lastname) AS Students
FROM Student INNER JOIN Suburb ON Suburb.postcode = Student.postcode
	 INNER JOIN Course ON Course.id = Student.course
     INNER JOIN StudentTakesSubject ON StudentTakesSubject.student = Student.id
WHERE Suburb.name = "Gilberton" AND Course.id = "B-SCI"
GROUP BY Student.id, 
		 StudentTakesSubject.area, 
         StudentTakesSubject.yearlevel,
         StudentTakesSubject.code
HAVING COUNT(*) > 1;

/*Q10*/
DROP TABLE IF EXISTS `StudentEvaluations`;
CREATE TABLE `StudentEvaluations` (
  `lecturer` mediumint(8) unsigned NOT NULL,
  `student` mediumint(8) unsigned NOT NULL,
  `area` char(4) NOT NULL,
  `yearlevel` tinyint(3) unsigned NOT NULL,
  `code` char(4) NOT NULL,
  `year` year(4) NOT NULL,
  `sem` enum('1','2') NOT NULL,
  `score` tinyint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`lecturer`, `student`,`area`,`yearlevel`,`code`,`year`,`sem`),
  KEY `StudentEvaluations` (`area`,`yearlevel`,`code`),
CONSTRAINT `fk_StudentEvaluations_Lecturer` 
  	FOREIGN KEY (`lecturer`) 
  	REFERENCES `Lecturer` (`id`) 
  		ON DELETE NO ACTION 
  		ON UPDATE NO ACTION,
  CONSTRAINT `fk_StudentEvaluations_Student1` 
  	FOREIGN KEY (`student`) 
  	REFERENCES `Student` (`id`) 
  		ON DELETE NO ACTION 
  		ON UPDATE NO ACTION,
  CONSTRAINT `fk_StudentEvaluations_Subject1` 
  	FOREIGN KEY (`area`, `yearlevel`, `code`) 
  	REFERENCES `Subject` (`area`, `yearlevel`, `code`) 
  		ON DELETE NO ACTION 
  		ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;