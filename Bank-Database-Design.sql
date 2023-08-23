
/* ## MS-SQL PROJECT on Banking Transactions by Gyan Kumar GM ! */

-- PHASE I of project begins 



create database dbBankGM;

/* NOTE: Unlike asked in question database name has been used as 'dbBankGM' instead of 'Bank' in order to make it unique 
from other students. Following code is used to select 'dbBankGM' as current database */

use dbBankGM;


-- Q2. Create all the tables mentioned in the database diagram. 
-- Q3. Create all the constraints based on the database diagram. 

-- NOTE: Solution to questions 2 and 3 are provided at once as follows. This was confirmed with teacher! 

/* CREATE TABLE & ADD CONSTRAINTS Section */
-- Creating tables only with primary keys first 

-- Creating table named UserLogins
CREATE TABLE UserLogins
(
	UserLoginID SMALLINT NOT NULL auto_increment,
	UserLogin VARCHAR(50) NOT NULL,
	UserPassword VARCHAR(20) NOT NULL,
	CONSTRAINT pk_UL_UserLoginID PRIMARY KEY(UserLoginID)
);


-- Creating table named UserSecurityQuestions
CREATE TABLE UserSecurityQuestions
(
	UserSecurityQuestionID TINYINT NOT NULL auto_increment,
	UserSecurityQuestion VARCHAR(50) NOT NULL,
	CONSTRAINT pk_USQ_UserSecurityQuestionID PRIMARY KEY(UserSecurityQuestionID)
);



-- Creating table named AccountType
CREATE TABLE AccountType
(
	AccountTypeID TINYINT NOT NULL auto_increment,
	AccountTypeDescription VARCHAR(30) NOT NULL,
	CONSTRAINT pk_AT_AccountTypeID PRIMARY KEY(AccountTypeID)
);


-- Creating table named SavingsInterestRates
/* NOTE:  Altered the table to accept datatype as NUMERIC(9,2) in order to avoid Arithmetic Conversion error using 
code "ALTER TABLE SavingsInterestRates ALTER COLUMN IntetestRatesValue NUMERIC(9,2);" */
CREATE TABLE SavingsInterestRates
(
	InterestSavingRatesID TINYINT NOT NULL auto_increment,
	InterestRatesValue NUMERIC(9,9) NOT NULL, 
	InterestRatesDescription VARCHAR(20) NOT NULL,
	CONSTRAINT pk_SIR_InterestSavingRatesID PRIMARY KEY(InterestSavingRatesID)
);
alter table savingsinterestrates
modify column InterestRatesValue decimal(9,2) NOT NULL; 


-- Creating table named AccountStatusType
CREATE TABLE AccountStatusType
(
	AccountStatusTypeID TINYINT NOT NULL auto_increment,
	AccountStatusTypeDescription VARCHAR(30) NOT NULL,
	CONSTRAINT pk_AST_AccountStatusTypeID PRIMARY KEY(AccountStatusTypeID)
);


-- Creating table named FailedTransactionErrorType
CREATE TABLE FailedTransactionErrorType
(
	FailedTransactionErrorTypeID TINYINT NOT NULL auto_increment,
	FailedTransactionErrorTypeDescription VARCHAR(50) NOT NULL,
	CONSTRAINT pk_FTET_FailedTransactionErrorTypeID PRIMARY KEY(FailedTransactionErrorTypeID)
);


-- Creating table named LoginErrorLog
CREATE TABLE LoginErrorLog
(
	ErrorLogID INT NOT NULL auto_increment,
	ErrorTime DATETIME NOT NULL,
	FailedTransactionXML TEXT,
	CONSTRAINT pk_LEL_ErrorLogID PRIMARY KEY(ErrorLogID)
);


-- Creating table named Employee
CREATE TABLE Employee
(
	EmployeeID INT NOT NULL auto_increment,
	EmployeeFirstName VARCHAR(25) NOT NULL,
	EmployeeMiddleInitial CHAR(1),
	EmployeeLastName VARCHAR(25),
	EmployeeisManager BIT,
	CONSTRAINT pk_E_EmployeeID PRIMARY KEY(EmployeeID)
);


-- Creating table named TransactionType
CREATE TABLE TransactionType
(
	TransactionTypeID TINYINT NOT NULL auto_increment,
	TransactionTypeName CHAR(10) NOT NULL,
	TransactionTypeDescription VARCHAR(50),
	TransactionFeeAmount DECIMAL(10,2),
	CONSTRAINT pk_TT_TransactionTypeID PRIMARY KEY(TransactionTypeID)
);


-- Creating tables with foreign key and combination of both primary and foreign keys 
-- Creating table named FailedTransactionLog
CREATE TABLE FailedTransactionLog
(
	FailedTransactionID INT NOT NULL auto_increment,
	FailedTransactionErrorTypeID TINYINT NOT NULL,
	FailedTransactionErrorTime DATETIME,
	FailedTransactionErrorXML text,
	CONSTRAINT pk_FTL_FailedTransactionID PRIMARY KEY(FailedTransactionID),
	CONSTRAINT fk_FTET_FailedTransactionErrorTypeID FOREIGN KEY(FailedTransactionErrorTypeID) REFERENCES FailedTransactionErrorType(FailedTransactionErrorTypeID) 
);


-- Creating table named UserSecurityAnswers
CREATE TABLE UserSecurityAnswers
(
	UserLoginID SMALLINT NOT NULL auto_increment,
	UserSecurityAnswers VARCHAR(25) NOT NULL,
	UserSecurityQuestionID TINYINT NOT NULL,
	CONSTRAINT pk_USA_UserLoginID PRIMARY KEY(UserLoginID), 
	CONSTRAINT fk_UL_UserLoginID FOREIGN KEY(UserLoginID) REFERENCES UserLogins(UserLoginID),
	CONSTRAINT fk_USQ_UserSecurityQuestionID FOREIGN KEY(UserSecurityQuestionID) REFERENCES UserSecurityQuestions(UserSecurityQuestionID)
);
-- Creating table named Account
CREATE TABLE Account
(
	AccountID INT NOT NULL auto_increment,
	CurrentBalance INT NOT NULL,
	AccountTypeID TINYINT NOT NULL REFERENCES AccountType (AccountTypeID),
	AccountStatusTypeID TINYINT NOT NULL,
	InterestSavingRatesID TINYINT NOT NULL,
	CONSTRAINT pk_A_AccounID PRIMARY KEY(AccountID),
	CONSTRAINT fk_AST_AccountStatusTypeID FOREIGN KEY(AccountStatusTypeID) REFERENCES AccountStatusType(AccountStatusTypeID),
	CONSTRAINT fk_SIR_InterestSavingRatesID FOREIGN KEY(InterestSavingRatesID) REFERENCES SavingsInterestRates(InterestSavingRatesID)
);


-- Creating table named LoginAccount
-- NOTE: Unlike ER diagram table name has been used as LoginAccounts instead of Login-Account
CREATE TABLE LoginAccount
(
	UserLoginID SMALLINT NOT NULL,
	AccountID INT NOT NULL,
	CONSTRAINT fk_UL_UserLogins FOREIGN KEY(UserLoginID) REFERENCES UserLogins(UserLoginID),
	CONSTRAINT fk_A_Account FOREIGN KEY(AccountID) REFERENCES Account(AccountID)
);


-- Creating table named Customer
CREATE TABLE Customer
(
	CustomerID INT NOT NULL auto_increment,
	AccountID INT NOT NULL,
	CustomerAddress1 VARCHAR(30) NOT NULL,
	CustomerAddress2  VARCHAR(30),
	CustomerFirstName  VARCHAR(30) NOT NULL,
	CustomerMiddleInitial CHAR(1),
	CustomerLastName  VARCHAR(30) NOT NULL,
	City  VARCHAR(20) NOT NULL,
	State CHAR(2) NOT NULL,
	ZipCode CHAR(10) NOT NULL,
	EmailAddress CHAR(40) NOT NULL,
	HomePhone VARCHAR(10) NOT NULL,
	CellPhone VARCHAR(10) NOT NULL,
	WorkPhone VARCHAR(10) NOT NULL,
	SSN VARCHAR(9),
	UserLoginID SMALLINT NOT NULL,
	CONSTRAINT pk_C_CustomerID PRIMARY KEY(CustomerID),
	CONSTRAINT fk_A_AccountID FOREIGN KEY(AccountID) REFERENCES Account(AccountID),
	CONSTRAINT fk_UL_C_UserLoginID FOREIGN KEY(UserLoginID) REFERENCES UserLogins(UserLoginID)  
);


-- Creating table named CustomerAccount
-- NOTE: Unlike ER diagram table name has been used as CustomerAccounts instead of Customer-Account
CREATE TABLE CustomerAccount
(
	AccountID INT NOT NULL ,
	CustomerID INT NOT NULL,
	CONSTRAINT fk_A_CA_AccountID FOREIGN KEY(AccountID) REFERENCES Account(AccountID),
	CONSTRAINT fk_C_CA_CustomerID FOREIGN KEY(CustomerID) REFERENCES Customer(CustomerID)
);


-- Creating table named TransactionLog
CREATE TABLE TransactionLog
(
	TransactionID INT NOT NULL auto_increment,
	TransactionDate DATETIME NOT NULL,
	TransactionTypeID TINYINT NOT NULL,
	TransactionAmount decimal(10,2) NOT NULL,
	NewBalance decimal(10,2) NOT NULL,
	AccountID INT NOT NULL,
	CustomerID INT NOT NULL,
	EmployeeID INT NOT NULL,
	UserLoginID SMALLINT NOT NULL,
	CONSTRAINT pk_TL_TransactionID PRIMARY KEY(TransactionID),
	CONSTRAINT fk_TT_TL_TransactionTypeID FOREIGN KEY(TransactionTypeID) REFERENCES TransactionType(TransactionTypeID),
	CONSTRAINT fk_A_TL_AccountID FOREIGN KEY(AccountID) REFERENCES Account(AccountID),
	CONSTRAINT fk_C_TL_CustomerID FOREIGN KEY(CustomerID) REFERENCES Customer(CustomerID),
	CONSTRAINT fk_E_TL_EmployeeID FOREIGN KEY(EmployeeID) REFERENCES Employee(EmployeeID),
	CONSTRAINT fk_UL_TL_UserLoginID FOREIGN KEY(UserLoginID) REFERENCES UserLogins(UserLoginID)    
);


-- Creating table named OverDraftLog
CREATE TABLE OverDraftLog
(
	AccountID INT NOT NULL auto_increment,
	OverDraftDate DATETIME NOT NULL,
	OverDraftAmount decimal(10,2) NOT NULL,
	OverDraftTransactionXML text NOT NULL,
	CONSTRAINT Pk_ODL_AccountID PRIMARY KEY(AccountID),
	CONSTRAINT fk_A_ODL_AccountID FOREIGN KEY(AccountID) REFERENCES Account(AccountID)
);


-- Q4. Insert at least 5 rows in each table. 
/** INSERT rows section **/
INSERT INTO UserLogins (UserLogin, UserPassword) VALUES ('User1', 'Pass1');

insert into UserLogins (UserLogin, UserPassword) values('User2', 'Pass2');
insert into UserLogins (UserLogin, UserPassword) values('User3', 'Pass3');
insert into UserLogins (UserLogin, UserPassword) values('User4', 'Pass4');
insert into UserLogins (UserLogin, UserPassword) values('User5', 'Pass5');


insert into UserSecurityQuestions (UserSecurityQuestion) values('What is your favourite food?');
insert into UserSecurityQuestions (UserSecurityQuestion) values('What is your favourite food?');
insert into UserSecurityQuestions(UserSecurityQuestion) values('What is your favourite food?');
insert into UserSecurityQuestions (UserSecurityQuestion) values('What is your favourite food?');
insert into UserSecurityQuestions (UserSecurityQuestion) values('What is your favourite food?');


Insert into AccountType(AccountTypeDescription) values('Savings');
Insert into AccountType (AccountTypeDescription) values('Checking');

-- Inserting 5 records into table SavingsInterestRates
insert into SavingsInterestRates (InterestRatesValue, InterestRatesDescription) values(0.5, 'Low');
insert into SavingsInterestRates (InterestRatesValue, InterestRatesDescription) values(2, 'Medium');
insert into SavingsInterestRates (InterestRatesValue, InterestRatesDescription) values(3, 'High');
insert into SavingsInterestRates (InterestRatesValue, InterestRatesDescription) values(4, 'Very high');
insert into SavingsInterestRates (InterestRatesValue, InterestRatesDescription) values(5, 'Super high');


select * from AccountStatusType;
insert into AccountStatusType (AccountStatusTypeDescription) values('Closed');
insert into AccountStatusType (AccountStatusTypeDescription) values('Active');
insert into AccountStatusType (AccountStatusTypeDescription) values('Dormant');
insert into AccountStatusType (AccountStatusTypeDescription) values('Passive');
insert into AccountStatusType (AccountStatusTypeDescription) values('Active');


insert into FailedTransactionErrorType (FailedTransactionErrorTypeDescription) values('Withdraw limit reached');
insert into FailedTransactionErrorType (FailedTransactionErrorTypeDescription) values('Daily limit reached');
insert into FailedTransactionErrorType (FailedTransactionErrorTypeDescription) values('No tenough balance');
insert into FailedTransactionErrorType (FailedTransactionErrorTypeDescription) values('Invalid denomination');
insert into FailedTransactionErrorType (FailedTransactionErrorTypeDescription) values('ATM machine down');


insert into LoginErrorLog (ErrorTime,FailedTransactionXML) values(CAST('2015-06-04 07:30:56' AS DATETIME), 'Bad Connection');
insert into LoginErrorLog (ErrorTime,FailedTransactionXML) values(CAST('2018-6-9 12:34:57' AS DATETIME), 'Invalid User');
insert into LoginErrorLog (ErrorTime,FailedTransactionXML) values(CAST('2016-4-5 02:14:00' AS DATETIME), 'Wrong Password');
insert into LoginErrorLog (ErrorTime,FailedTransactionXML) values(CAST('2014-7-5 05:56:59' AS DATETIME), 'Server issue');
insert into LoginErrorLog (ErrorTime,FailedTransactionXML) values(CAST('2009-10-12 08:34:15' AS DATETIME), 'Datacenter down');


insert into Employee (EmployeeFirstName, EmployeeMiddleInitial,EmployeeLastName, EmployeeisManager) values('E3', 'K', 'E3', 0);
insert into Employee (EmployeeFirstName, EmployeeMiddleInitial,EmployeeLastName, EmployeeisManager) values('E5', 'B', 'E5', 1);
insert into Employee (EmployeeFirstName, EmployeeMiddleInitial,EmployeeLastName, EmployeeisManager) values('E7', 'P', 'E7', 0);
insert into Employee (EmployeeFirstName, EmployeeMiddleInitial,EmployeeLastName, EmployeeisManager) values('E9', 'R', 'E9', 1);
insert into Employee (EmployeeFirstName, EmployeeMiddleInitial,EmployeeLastName, EmployeeisManager) values('E11', 'K', 'E11', 1);


insert into TransactionType (TransactionTypeName, TransactionTypeDescription, TransactionFeeAmount) values('Balance', 'See money', '0');
insert into TransactionType (TransactionTypeName, TransactionTypeDescription, TransactionFeeAmount) values('Transfer', 'Send money', '450');
insert into TransactionType (TransactionTypeName, TransactionTypeDescription, TransactionFeeAmount) values('Receive', 'Get money', '300');
insert into TransactionType (TransactionTypeName, TransactionTypeDescription, TransactionFeeAmount) values('Paid', 'Paid to John', '45000');
insert into TransactionType (TransactionTypeName, TransactionTypeDescription, TransactionFeeAmount) values('Statement', 'Checked monthly transaction', '0');


insert into FailedTransactionLog (FailedTransactionErrorTypeID, FailedTransactionErrorTIME, FailedTransactionErrorXML) values(1, CAST('2015-6-4 07:30:56' AS DATETIME), 'First');
insert into FailedTransactionLog (FailedTransactionErrorTypeID, FailedTransactionErrorTIME, FailedTransactionErrorXML) values(2, CAST('2018-6-9 12:34:57' AS DATETIME), 'Second');
insert into FailedTransactionLog (FailedTransactionErrorTypeID, FailedTransactionErrorTIME, FailedTransactionErrorXML) values(3, CAST('2016-4-5 02:14:00' AS DATETIME), 'Third');
insert into FailedTransactionLog (FailedTransactionErrorTypeID, FailedTransactionErrorTIME, FailedTransactionErrorXML) values(4, CAST('2014-7-5 05:56:59' AS DATETIME), 'Fourth');
insert into FailedTransactionLog (FailedTransactionErrorTypeID, FailedTransactionErrorTIME, FailedTransactionErrorXML) values(5, CAST('2009-10-12 08:34:15' AS DATETIME), 'Fifth');


insert into UserSecurityAnswers (UserSecurityAnswers, UserSecurityQuestionID) values('Apples', 1);
insert into UserSecurityAnswers (UserSecurityAnswers, UserSecurityQuestionID) values('Spiderman', 2);
insert into UserSecurityAnswers (UserSecurityAnswers, UserSecurityQuestionID) values('School1', 3);
insert into UserSecurityAnswers (UserSecurityAnswers, UserSecurityQuestionID) values('Ram', 4);
insert into UserSecurityAnswers (UserSecurityAnswers, UserSecurityQuestionID) values('Toyota', 5);


insert into Account (CurrentBalance, AccountTypeID, AccountStatusTypeID, InterestSavingRatesID) values(15000.7, 1, 1, 1);
insert into Account (CurrentBalance, AccountTypeID, AccountStatusTypeID, InterestSavingRatesID) values(25000.5, 2, 2, 2);
insert into Account (CurrentBalance, AccountTypeID, AccountStatusTypeID, InterestSavingRatesID) values(17000.2, 1, 1, 1);
insert into Account (CurrentBalance, AccountTypeID, AccountStatusTypeID, InterestSavingRatesID) values(45000, 2, 2, 2);
insert into Account (CurrentBalance, AccountTypeID, AccountStatusTypeID, InterestSavingRatesID) values(2320, 2, 2, 2);
select * from Account;


insert into LoginAccount (UserLoginID, AccountID) values(1, 1);
insert into LoginAccount (UserLoginID, AccountID) values(2, 2);
insert into LoginAccount (UserLoginID, AccountID) values(3, 3);
insert into LoginAccount (UserLoginID, AccountID) values(4, 4);
insert into LoginAccount (UserLoginID, AccountID) values(5, 5);


insert into Customer (AccountID, CustomerAddress1, CustomerAddress2, CustomerFirstName, CustomerMiddleInitial, CustomerLastName, City, State,
	ZipCode,
	EmailAddress,
	HomePhone,
	CellPhone,
	WorkPhone,
	SSN,
	UserLoginID) values (1, 'Address1', 'Address2', 'Customer1', 'U', 'CLastname1', 'Ottawa', 'ON', '3A5z9z', 'user5@user.com', '141655555', '453554464', '3462325', 'A12345', 1);
insert into Customer (AccountID, CustomerAddress1, CustomerAddress2, CustomerFirstName, CustomerMiddleInitial, CustomerLastName, City, State,
	ZipCode,
	EmailAddress,
	HomePhone,
	CellPhone,
	WorkPhone,
	SSN,
	UserLoginID) values(2, 'Address1', 'Address2', 'Customer2', 'K', 'CLastname2', 'Hamilton', 'ON', 'fe3453', 'user6@user.com', '141655555', '567435345', '6332423', 'D34353', 2);
insert into Customer (AccountID, CustomerAddress1, CustomerAddress2, CustomerFirstName, CustomerMiddleInitial, CustomerLastName, City, State,
	ZipCode,
	EmailAddress,
	HomePhone,
	CellPhone,
	WorkPhone,
	SSN,
	UserLoginID) values(3, 'Address1', 'Address2', 'Customer3', 'P', 'CLastname3', 'Vacouver', 'BC', 'fdf45', 'user7@user.com', '141655555', '681316226', '9202521', 'J56361', 3);
insert into Customer (AccountID, CustomerAddress1, CustomerAddress2, CustomerFirstName, CustomerMiddleInitial, CustomerLastName, City, State,
	ZipCode,
	EmailAddress,
	HomePhone,
	CellPhone,
	WorkPhone,
	SSN,
	UserLoginID) values(4, 'Address1', 'Address2', 'Customer4', 'B', 'CLastname4', 'London', 'ON', '23ffbfs', 'user8@user.com', '141655555', '795197107', '8674252', 'I78369', 4);
insert into Customer (AccountID, CustomerAddress1, CustomerAddress2, CustomerFirstName, CustomerMiddleInitial, CustomerLastName, City, State,
	ZipCode,
	EmailAddress,
	HomePhone,
	CellPhone,
	WorkPhone,
	SSN,
	UserLoginID) values(5, 'Address1', 'Address2', 'Customer5', 'K', 'CLastname5', 'Calgary', 'AB', 'hg4536', 'user9@user.com', '141655555', '909077988', '9209371', 'K10377', 5);


insert into CustomerAccount values(1, 1);
insert into CustomerAccount values(2, 2);
insert into CustomerAccount values(3, 3);
insert into CustomerAccount values(4, 4);
insert into CustomerAccount values(5, 5);


insert into TransactionLog (TransactionDate, TransactionTypeID,
	TransactionAmount,
	NewBalance,
	AccountID,
	CustomerID,
	EmployeeID,
	UserLoginID)  values('2015-6-4 07:30:56', 1,15000.7, 7869878, 1, 1, 1, 1);
insert into TransactionLog (TransactionDate, TransactionTypeID,
	TransactionAmount,
	NewBalance,
	AccountID,
	CustomerID,
	EmployeeID,
	UserLoginID) values('2018-6-9 12:34:57', 2,435435, 675687, 2, 2, 2, 2);
insert into TransactionLog (TransactionDate, TransactionTypeID,
	TransactionAmount,
	NewBalance,
	AccountID,
	CustomerID,
	EmployeeID,
	UserLoginID) values('2016-4-5 02:14:00', 3,855869.3, 34512356, 3, 3, 3, 3);
insert into TransactionLog (TransactionDate, TransactionTypeID,
	TransactionAmount,
	NewBalance,
	AccountID,
	CustomerID,
	EmployeeID,
	UserLoginID) values('2014-7-5 05:56:59', 4,1276303.6, 4643234, 4, 4, 4, 4);
insert into TransactionLog (TransactionDate, TransactionTypeID,
	TransactionAmount,
	NewBalance,
	AccountID,
	CustomerID,
	EmployeeID,
	UserLoginID) values('2009-10-12 08:34:15', 5,1696737.9, 325344, 5, 5, 5, 5);


insert into OverDraftLog (OverDraftDate, OverDraftAmount, OverDraftTransactionXML) values('2015-6-4 07:30:56', 0, 'Clear');
insert into OverDraftLog (OverDraftDate, OverDraftAmount, OverDraftTransactionXML) values('2018-6-9 12:34:57', 5, 'Pending');
insert into OverDraftLog (OverDraftDate, OverDraftAmount, OverDraftTransactionXML) values('2016-4-5 02:14:00', 10, 'Clear');
insert into OverDraftLog (OverDraftDate, OverDraftAmount, OverDraftTransactionXML) values('2014-7-5 05:56:59', 15, 'Pending');
insert into OverDraftLog (OverDraftDate, OverDraftAmount, OverDraftTransactionXML) values('2009-10-12 08:34:15', 20, 'Clear');


-- PHASE II of project begins

-- Q1. Create a view to get all customers with checking account from ON province. 

DROP VIEW VW_Customer_ON;


CREATE VIEW VW_Customer_ON AS
SELECT DISTINCT c.* FROM Customer c
JOIN Account a
ON c.AccountID = a.AccountId
JOIN AccountType at
ON a.AccountTypeID = at.AccountTypeID
WHERE at.AccountTypeDescription = 'Checking' and c.State = 'ON';


-- Q2. Create a view to get all customers with total account balance (including interest rate) greater than 5000. 

DROP VIEW VW_Customer_AMT;


CREATE VIEW VW_Customer_AMT AS
SELECT c.CustomerFirstName, SUM(a.CurrentBalance) AS Ac_Balance, SUM(a.CurrentBalance + (a.CurrentBalance * s.InterestSavingRatesID)/100) AS Total_Ac_Balance 
FROM Customer c
JOIN Account a
ON c.AccountID = a.AccountId
JOIN SavingsInterestRates s
ON a.InterestSavingRatesID = s.InterestSavingRatesID 
GROUP BY c.CustomerFirstName
HAVING SUM(a.CurrentBalance + (a.CurrentBalance * s.InterestRatesValue)/100) > 5000;


-- Q3. Create a view to get counts of checking and savings accounts by customer. 

DROP VIEW VW_Customer_ACC;


CREATE VIEW VW_Customer_ACC 
AS
SELECT c.CustomerFirstName, at.AccountTypeDescription, COUNT(*) AS Total_AC_Types FROM Customer c
JOIN Account a
ON c.AccountID = a.AccountId
JOIN AccountType at
ON a.AccountTypeID = at.AccountTypeID
GROUP BY c.CustomerFirstName, at.AccountTypeDescription;


-- Q4. Create a view to get any particular user�s login and password using AccountId. 

DROP VIEW VW_Account_UL;


CREATE VIEW VW_Account_UL 
AS
SELECT DISTINCT ul.UserLogin, ul.UserPassword
FROM UserLogins ul
JOIN LoginAccount la
ON ul.UserLoginID = la.UserLoginID
JOIN Account a
ON la.AccountID = a.AccountID
WHERE la.AccountID = '1';



-- Q5. Create a view to get all customers� overdraft amount. 

DROP VIEW VW_Customer_OD;


CREATE VIEW VW_Customer_OD 
AS
SELECT DISTINCT c.CustomerFirstName, o.OverDraftAmount
FROM OverDraftLog o
JOIN Customer c
ON o.AccountID = c.AccountID;


-- Q6. Create a stored procedure to add "User_" as a prefix to everyone's login (username). 

DROP PROCEDURE sp_Update_Login;


DELIMITER //

CREATE PROCEDURE sp_Update_Login()
BEGIN
    UPDATE UserLogins
    SET UserLogin = CONCAT('User_', UserLogin);
END //

DELIMITER ;

-- Call the procedure
CALL sp_Update_Login();

-- Q7. Create a stored procedure that accepts AccountId as a parameter and returns customer's full name. 

DROP PROCEDURE sp_Customer_Details;


DELIMITER //

CREATE PROCEDURE sp_Customer_Details(IN AccountID INT)
BEGIN
    SELECT CONCAT(c.CustomerFirstName, ' ', c.CustomerMIddleInitial, ' ', c.CustomerLastName) AS Customer_Full_Name
    FROM Customer c
    JOIN Account a ON c.AccountID = a.AccountId
    WHERE a.AccountID = AccountID;
END //

DELIMITER ;

-- Call the procedure
CALL sp_Customer_Details(2);


-- Q8. Create a stored procedure that returns error logs inserted in the last 24 hours. 

DROP PROCEDURE sp_Errors_24;


DELIMITER //

CREATE PROCEDURE sp_Errors_24()
BEGIN
    SELECT *
    FROM LoginErrorLog
    WHERE ErrorTime BETWEEN NOW() - INTERVAL 24 HOUR AND NOW();
END //

DELIMITER ;

-- Call the procedure
CALL sp_Errors_24();

-- Q9. Create a stored procedure that takes a deposit as a parameter and updates CurrentBalance value for that particular account.  

DROP PROCEDURE sp_Update_cBalance_After_Deposit;


DELIMITER //

CREATE PROCEDURE sp_Update_cBalance_After_Deposit(IN AccountID INT, IN Deposit INT)
BEGIN
    UPDATE Account
    SET CurrentBalance = CurrentBalance + Deposit
    WHERE AccountID = AccountID;
END //

DELIMITER ;

-- Call the procedure
CALL sp_Update_cBalance_After_Deposit(3, 300);


-- Q10. Create a stored procedure that takes a withdrawal amount as a parameter and updates CurrentBalance value for that particular account. 

DROP PROCEDURE sp_Update_cBalance_After_Withdraw;


DELIMITER //

CREATE PROCEDURE sp_Update_cBalance_After_Withdraw(IN AccountID INT, IN Withdraw INT)
BEGIN
    UPDATE Account
    SET CurrentBalance = CurrentBalance - Withdraw
    WHERE AccountID = AccountID;
END //

DELIMITER ;

-- Call the procedure
CALL sp_Update_cBalance_After_Withdraw(3, 300);


-- Q11. Create a stored procedure to remove all security questions for a particular login. 

DROP PROCEDURE sp_Delete_Question;


DELIMITER //

CREATE PROCEDURE sp_Delete_Question(IN UserLoginID SMALLINT)
BEGIN
    DELETE uq
    FROM UserSecurityQuestions uq
    JOIN UserSecurityAnswers ua ON ua.UserSecurityQuestionID = uq.UserSecurityQuestionID
    JOIN UserLogins ul ON ua.UserLoginID = ul.UserLoginID
    WHERE ul.UserLoginID = UserLoginID;
END //

DELIMITER ;

-- Call the procedure
CALL sp_Delete_Question(5);


-- Q12. Delete all error logs created in the last hour. 

DROP PROCEDURE sp_Delete_Errors;


DELIMITER //

CREATE PROCEDURE sp_Delete_Errors()
BEGIN
    DELETE FROM LoginErrorLog
    WHERE ErrorTime BETWEEN NOW() - INTERVAL 1 HOUR AND NOW();
END //

DELIMITER ;

-- Call the procedure
CALL sp_Delete_Errors();


-- Q13. Write a query to remove SSN column from Customer table. 

DROP PROCEDURE sp_Remove_Column;


DELIMITER //

CREATE PROCEDURE sp_Remove_Column()
BEGIN
    ALTER TABLE CUSTOMER
    DROP COLUMN CustomerAddress1;
END //

DELIMITER ;

-- Call the procedure
CALL sp_Remove_Column();

