# PL-SQL_SELECT_INTO

#### Question 1: (user scott)
&nbsp;Create a procedure that accepts an employee number to display the name of the department where he works, his name, 
his annual salary (do not forget his one time commission)
<br>Note that the salary in table employee is monthly salary.
<br>Handle the error (use EXCEPTION)
<br>HINT: the name of the department can be found from table dept.
#### Question 2: (use schemas des02, and script 7clearwater)
&nbsp;Create a procedure that accepts an inv_id to display the item description, price, color, inv_qoh, and the value of that inventory.
<br>Handle the error ( use EXCEPTION)
<br>Hint: value is the product of price and quantity on hand.
#### Question 3: (use schemas des03, and script 7northwoods)
&nbsp;Create a function called find_age that accepts a date and return a number.
<br>The function will use the sysdate and the date inserted to calculate the age of the person with the birthdate inserted.
<br>Create a procedure that accepts a student number to display his name, his birthdate, and his age using the function find_age created above.
Handle the error ( use EXCEPTION)
#### Question 4: (use schemas des04, and script 7software)
&nbsp;We need to INSERT or UPDATE data of table consultant_skill , create needed functions, procedures … that accepts consultant id, skill id, and certification status for the task. The procedure should be user friendly enough to handle all possible errors such as consultant id, skill id do not exist OR certification status is different than ‘Y’, ‘N’. Make sure to display: Consultant last, first name, skill description and the confirmation of the DML performed (hint: Do not forget to add COMMIT inside the procedure)
