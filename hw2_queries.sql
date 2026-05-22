CREATE TABLE works(
    eid int NOT NULL, 
    did int NOT NULL, 
    pct_time int, 
    PRIMARY KEY(eid, did),
    FOREIGN KEY( eid ) REFERENCES emp ( eid ),
    FOREIGN KEY( did ) REFERENCES dept( did )
);

CREATE TABLE Dept(
    did int NOT NULL UNIQUE, 
    dname varchar(200),
    budget real, 
    managerid int, 
    PRIMARY KEY (did),
    FOREIGN KEY (managerid) REFERENCES Emp(eid)
);

1.1)
SELECT DISTINCT D.managerid 
FROM dept D 
WHERE D.budget >= 1000000;

1.2)
SELECT e.ename
FROM emp e, works w
WHERE e.eid=w.eid
GROUP BY e.eid
HAVING COUNT(e.eid)>=2;

1.3)
SELECT DISTINCT ename
FROM emp 
WHERE eid IN (SELECT managerid
FROM dept
WHERE budget = (SELECT MIN(budget) FROM dept))

1.4)
SELECT ename
FROM emp INNER JOIN works ON emp.eid = works.eid
GROUP BY emp.eid
HAVING COUNT(emp.eid) =
(SELECT MAX(mc.c)
FROM
(SELECT COUNT(works.eid) as c, works.eid
FROM works
GROUP BY works.eid) mc )

1.5) ?

1.6)
SELECT ename
FROM works INNER JOIN emp ON works.eid=emp.eid
GROUP BY works.eid
HAVING COUNT(works.eid) = (SELECT DISTINCT COUNT(did) FROM dept)

2.1) 
CREATE TABLE emp (
    eid INT NOT NULL UNIQUE,
    ename varchar(200) NOT NULL,
    age int,
    salary real CHECK (salary > 1000),
    PRIMARY KEY(eid)
);

2.2)
CREATE TABLE dept(
    did int NOT NULL UNIQUE, 
    dname varchar(200),
    budget real, 
    managerid int, 
    PRIMARY KEY (did),
    FOREIGN KEY (managerid) REFERENCES Emp(eid)
);

CREATE ASSERTION ManagerEmployee
CHECK ( ( SELECT COUNT (*)
        FROM dept
        WHERE managerid NOT IN
        (SELECT * FROM emp)) = 0)

2.3)
CREATE TABLE dept(
    did int NOT NULL UNIQUE, 
    dname varchar(200),
    budget real CHECK (budget > (SELECT SUM(salary)
    FROM emp INNER JOIN works ON emp.eid=works.eid INNER JOIN dept ON works.did = dept.did)),
    managerid int, 
    PRIMARY KEY (did),
    FOREIGN KEY (managerid) REFERENCES Emp(eid)
);

2.4)
CREATE ASSERTION MoreForManager
CHECK ( SELECT e.eid
        FROM emp e, emp m, works w, dept d
        WHERE e.eid = w.eid
        AND w.did = d.did
        AND d.managerid = m.eid
        AND e.salary > m.salary)

2.5)
CREATE TRIGGER ManagerRaise AFTER UPDATE ON emp
    WHEN old.salary < new.salary
    FOR EACH ROW
    BEGIN
        UPDATE emp m
        SET m.salary = new.salary
        WHERE m.salary < new.salary
        AND m.eid IN 
            (SELECT d.mangerid
            FROM emp e, works w, dept d
            WHERE e.eid = new.eid
            AND e.eid = w.eid
            AND w.did = d.did);
END

