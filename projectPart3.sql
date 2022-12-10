SPOOL /tmp/oracle/projectPart3_spool.txt

SELECT
    to_char(sysdate, 'DD Month YYYY Year Day HH:MI:SS Am')
FROM
    dual;

/* Question 1: (user scott)
Create a procedure that accepts an employee number to display 
the name of the department where he works, his name, his annual salary 
(do not forget his one time commission)
Note that the salary in table employee is monthly salary.
Handle the error (use EXCEPTION)
hint: the name of the department can be found from table dept. */
CONNECT scott/tiger;

CREATE OR REPLACE PROCEDURE employee_info(emp_number NUMBER) AS
    dep_name DEPT.DNAME%TYPE;
    emp_name EMP.ENAME%TYPE;
    emp_sal EMP.SAL%TYPE;
    emp_comm EMP.COMM%TYPE;
    ann_sal_comm NUMBER;
BEGIN
    SELECT
        DNAME, 
        ENAME, 
        SAL, 
        COMM INTO
        dep_name,
        emp_name,
        emp_sal,
        emp_comm
    FROM
        EMP e JOIN DEPT d ON e.DEPTNO = d.DEPTNO
    WHERE
        EMPNO = emp_number;
    if emp_comm IS NULL THEN
        ann_sal_comm := emp_sal * 12;
    ELSE
        ann_sal_comm := emp_sal * 12 + emp_comm;
    END IF;
    DBMS_OUTPUT.PUT_LINE('No.: '|| emp_number || chr(10) ||
        'Name: ' || emp_name || chr(10) ||
        'Department: '|| dep_name || chr(10) ||
        'Annual Salary + Commission: $' || ann_sal_comm);
EXCEPTION
	WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee with No. ''' || emp_number || ''' doesn''t exist!');
END;
/

SET SERVEROUTPUT ON

SET LINESIZE 200;

exec employee_info(7902)

exec employee_info(7499)

exec employee_info(8000)


/* Question 2: (use schemas des02, and script 7Clearwater)
Create a procedure that accepts an inv_id to display the item description, 
price, color, inv_qoh, and the value of that inventory.
Handle the error (use EXCEPTION)
Hint: value is the product of price and quantity on hand. */
CONNECT des02/des02;

CREATE OR REPLACE PROCEDURE iventory_info(id NUMBER) AS
    i_desc ITEM.ITEM_DESC%TYPE;
    i_price INVENTORY.INV_PRICE%TYPE;
    i_color INVENTORY.COLOR%TYPE;
    i_qty_on_hand INVENTORY.INV_QOH%TYPE;
    i_value NUMBER;
BEGIN
    SELECT
        ITEM_DESC,
        INV_PRICE,
        COLOR,
        INV_QOH INTO
        i_desc,
        i_price,
        i_color,
        i_qty_on_hand
    FROM
        INVENTORY inv JOIN ITEM i ON inv.ITEM_ID = i.ITEM_ID
    WHERE
        INV_ID = id;
    i_value := i_price * i_qty_on_hand;
    DBMS_OUTPUT.PUT_LINE('Inventory ID: ' || id || chr(10) ||
        'Description: ' || i_desc || chr(10) ||
        'Price: $' || i_price || chr(10) ||
        'Color: ' || i_color || chr(10) ||
        'In Stock: ' || i_qty_on_hand || chr(10) ||
        'Total Value: $' || i_value);
EXCEPTION
	WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Item with Inventory ID ''' || id || ''' doesn''t exist!');
END;
/

SET SERVEROUTPUT ON

SET LINESIZE 200;

exec iventory_info(5)

exec iventory_info(28)

exec iventory_info(50)


/* Question 3: (use schemas des03, and script 7Northwoods)
Create a function called find_age that accepts a date and return a number.
The function will use the sysdate and the date inserted to calculate 
the age of the person with the birthdate inserted.
Create a procedure that accepts a student number to display 
his name, his birthdate, and his age using the function find_age created above. 
Handle the error (use EXCEPTION) */
CONNECT des03/des03;

CREATE OR REPLACE FUNCTION find_age(input_bday DATE)
RETURN NUMBER AS
    bday DATE;
    age NUMBER;
BEGIN
    bday := input_bday;
    age := to_number(to_char(sysdate, 'YYYY')) - to_number(to_char(bday, 'YYYY'));
    RETURN age;
END;
/

CREATE OR REPLACE PROCEDURE student_info(student_ID NUMBER) AS
    s_first_name STUDENT.S_FIRST%TYPE;
    s_last_name STUDENT.S_LAST%TYPE;
    s_bday STUDENT.S_DOB%TYPE;
    s_age NUMBER;
BEGIN
    SELECT
        S_FIRST,
        S_LAST,
        S_DOB INTO
        s_first_name,
        s_last_name,
        s_bday
    FROM
        STUDENT
    WHERE
        S_ID = student_ID;
    s_age := find_age(s_bday);
    DBMS_OUTPUT.PUT_LINE('Student No.: ' || student_ID || chr(10) ||
        'Name: ' || s_first_name || ' ' || s_last_name || chr(10) ||
        'Date of Birthday: ' || s_bday || chr(10) ||
        'Age: ' || s_age);
EXCEPTION
	WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Student with No. ''' || student_ID || ''' doesn''t exist!');
END;
/

SET SERVEROUTPUT ON

SET LINESIZE 300;

exec student_info(3)

exec student_info(6)

exec student_info(20)


/* Question 4: (use schemas des04, and script 7Software)
We need to INSERT or UPDATE data of table consultant_skill, 
create needed functions, procedures … that accepts 
consultant id, skill id, and certification status for the task. 
The procedure should be user friendly enough to handle all possible 
errors such as consultant id, skill id do not exist OR certification 
status is different than ‘Y’, ‘N’. 
Make sure to display: Consultant last, first name, skill description 
and the confirmation of the DML performed 
(hint: Do not forget to add COMMIT inside the procedure) */
CONNECT des04/des04;

CREATE OR REPLACE PROCEDURE cons_skill(input_c_id NUMBER, input_skill_id NUMBER, input_cert_status VARCHAR2) AS
    c_l_name CONSULTANT.C_LAST%TYPE;
    c_f_name CONSULTANT.C_FIRST%TYPE;
    skill_desc SKILL.SKILL_DESCRIPTION%TYPE;
    existing_skill_id NUMBER;
    existing_cons_id NUMBER;
BEGIN
    IF input_cert_status IN ('Y', 'N') THEN 
        SELECT
            C_LAST,
            C_FIRST,
            SKILL_DESCRIPTION INTO
            c_l_name,
            c_f_name,
            skill_desc
        FROM
            CONSULTANT c JOIN CONSULTANT_SKILL cs ON c.C_ID = cs.C_ID
            JOIN SKILL s ON s.SKILL_ID = cs.SKILL_ID
        WHERE
            cs.C_ID = input_c_id AND
            cs.SKILL_ID = input_skill_id;        
        UPDATE
            CONSULTANT_SKILL
        SET
            CERTIFICATION = input_cert_status
        WHERE
            C_ID = input_c_id AND
            SKILL_ID = input_skill_id;    
        DBMS_OUTPUT.PUT_LINE('Skill ID ''' || input_skill_id || ''' of Consultant with ID ''' || input_c_id || ''' has been UPDATED!');
        DBMS_OUTPUT.PUT_LINE('Consultant: ' || c_l_name || ' ' || c_f_name || chr(10) ||
            'Skill: ' || skill_desc || chr(10) ||
            'Certification: ' || input_cert_status);
        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Certification Status must be ''Y'' or ''N''!');            
    END IF;

EXCEPTION
	WHEN NO_DATA_FOUND THEN
        BEGIN
            SELECT
                count(*) INTO
                existing_skill_id
            FROM
                SKILL
            WHERE
                SKILL_ID = input_skill_id;
        END;

        BEGIN
            SELECT
                count(*) INTO
                existing_cons_id
            FROM
                CONSULTANT
            WHERE
                C_ID = input_c_id;
        END;

        IF (existing_cons_id > 0) AND (existing_skill_id > 0) THEN
            INSERT INTO CONSULTANT_SKILL(
                C_ID,
                SKILL_ID,
                CERTIFICATION
            ) VALUES(
                input_c_id,
                input_skill_id,
                input_cert_status
            );
            DBMS_OUTPUT.PUT_LINE('Skill ID ''' || input_skill_id || ''' of Consultant with ID ''' || input_c_id || ''' has been INSERTED!');
            DBMS_OUTPUT.PUT_LINE('Consultant: ' || c_l_name || ' ' || c_f_name || chr(10) ||
                'Skill: ' || skill_desc || chr(10) ||
                'Certification: ' || input_cert_status);
            COMMIT;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Consultant ID or Skill ID is INVALID!');
        END IF;
END;
/

    SET SERVEROUTPUT ON

    SET LINESIZE 200;

    exec cons_skill(100, 3, 'Y')

    exec cons_skill(100, 3, 'Z')

    exec cons_skill(100, 9, 'Y')

    exec cons_skill(100, 8, 'N')

    exec cons_skill(100, 10, 'Y')

    exec cons_skill(110, 1, 'Y')

SPOOL OFF;