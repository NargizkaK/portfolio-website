create database BreakdownCompany;
use BreakdownCompany;

create table Member
  (
   MemberId varchar (10) primary key,
   MemberFname varchar(20),
   MemberLname varchar(20),
   MemberLoc varchar(20)
  );
  
  insert into Member (MemberId,MemberFname,MemberLname,MemberLoc) values
   ('Memb01','Anna','Fox','London'),
   ('Memb02','Ava','Max','Liverpool'),
   ('Memb03','Tom','Lord','Manchester'),
   ('Memb04','Mark','Lee','London'),
   ('Memb05','Jhon','Ford','Birmingham');
   
Create table Vehicle
   (
    VehicleReg varchar(10) primary key,
	VehicleMake varchar(10),
	VehicleModel varchar(10),
	MemberID varchar(10)
   );
   
 

create table Engineer
	(
     EngineerID int primary key,
	 EngineerFName varchar(20),
	 EngineerLName varchar(20)
    );


Create table Breakdown
   (
    BreakdownID int Primary key, 
	VehicleReg varchar(10),
	EngineerID int,
	BreakdownDATE date,
	BreakdownTIME time,
	BreakdownLoc varchar(20)
   );

ALTER TABLE Vehicle ADD FOREIGN KEY(MemberId) REFERENCES Member(MemberId);
ALTER TABLE Breakdown ADD FOREIGN KEY (VehicleReg) REFERENCES Vehicle(VehicleReg);
ALTER TABLE Breakdown ADD FOREIGN KEY(EngineerID) REFERENCES Engineer(EngineerID);

insert into Vehicle (VehicleReg,VehicleMake,VehicleModel,MemberId) values
  ('ABC','BMW','X5','Memb01'),
  ('DEF','VW','Polo','Memb02'),
  ('FGH','MERCEDES','Bens','Memb03'),
  ('IJK','BMW','X3','Memb04'),
  ('KLM','FORD','PUMA','Memb05'),
  ('OPR','Ford','FIESTA','Memb01'),
  ('RST','TESLA','JET1','memb02'),
  ('TUV','TOYOTA','AURIS','Memb03');
  
insert into  Engineer (EngineerID,EngineerFName,EngineerLName) values
   (01,'Max','Ford'),
   (02,'Mickey','Mouse'),
   (03,'Tom','Kruz');
   
insert into Breakdown(BreakdownID,VehicleReg,EngineerID,BreakdownDATE,BreakdownTIME,BreakdownLoc)values
 (1000,'TUV',01,'2023-11-11', '14:20:45','Liverpool'),
 (1001,'ABC',02,'2023-11-27', '19:17:00','Manchester'),
 (1002,'KLM',03,'2023-12-15', '10:30:50','London'),
 (1003,'DEF',01,'2024-12-31', '08:30:55','Liverpool'),
 (1004,'OPR',02,'2024-01-01', '13:22:18','London'),
 (1005,'ABC',03,'2024-01-01', '08:30:55','London'),
 (1006,'KLM',01,'2024-02-05', '18:45:00','Manchester'),
 (1007,'IJK',02,'2024-02-11', '15:00:30','Birmingham'),
 (1008,'DEF',03,'2024-02-18', '20:30:30','Liverpool'),
 (1009,'RST',01,'2024-02-26', '09:00:00','London'),
 (1010,'FGH',02,'2024-03-01', '22:15:15','Birmingham'),
 (1011,'TUV',03,'2023-10-10', '17:30:00','Manchester');
  


-- Task 3
-- 1 The names of members who live in a location e.g. For example, London.
select Concat(memberFname,' ', MemberLname) as 'Member Name', memberLoc from member where memberLoc='London';


-- 2 All cars registered with the company e.g. all Nissan cars.
select VehicleMake as 'Car Make Registered', vehicleModel as 'Car Model Registered' from vehicle;

-- 3 The number of engineers that work for the company.
SELECT COUNT(engineerID) AS 'No Of Engineers' FROM Engineer;

-- 4 The number of members registered.
select count(memberID) as 'No of Members' from Member;

-- 5 All the breakdown after a particular date
select * from breakdown where breakdownDate> '2024:01:01';

-- 6 All the breakdown between 2 dates
select * from breakdown where breakdownDate between '2024:01:01:' and '2024:03:01';

-- 7 The number of time a particular vehicle has broken down
select vehicleReg, count(breakdownID)as 'No broken times' from breakdown where vehicleReg='ABC';


-- 8  The number of vehicles broken down more than once
 select vehicleReg, Count(VehicleReg)as 'No broken times' from breakdown group by VehicleReg having count(*)>1;


-- Task 4
-- Perform the following queries:
-- 1.	All the vehicles a member owns. For example, Matt
 SELECT MemberFName as'First Name', MemberlName as 'Last Name', VehicleMake FROM MEMBER right JOIN VEHICLE
 ON member.memberID=vehicle.memberID WHERE MemberFName='Ava';

--  2.	The number of vehicles each member has – sort the data based on the number of car from highest to lowest.
select MemberFname, count(VehicleReg) from member left join vehicle 
on member.memberID=vehicle.memberID group by MemberFname;


-- 3.	All vehicles that have broken down in a particular location along with member details.
select MemberFname, MemberLname, Member.MemberId, BreakdownID, vehicle.vehicleReg,  breakdownLoc from member inner join vehicle 
on member.memberID=vehicle.memberID inner join breakdown on vehicle.vehicleReg=breakdown.vehicleReg and breakdownLoc='London';

-- 4.	A list of all breakdown along with member and engineer details between two dates.
select MemberFname, MemberLname, Member.MemberId, vehicle.vehicleReg, BreakdownID, Breakdown.VehicleReg,BreakdownDATE,BreakdownLoc,
Breakdown.engineerId, engineer.engineerId, engineerFname from member inner join vehicle 
on member.memberID=vehicle.memberID inner join breakdown on vehicle.vehicleReg=breakdown.vehicleReg left join engineer on  
breakdown.engineerId = engineer.engineerID where breakdownDate between '2024:01:01' and '2024:03:01';


-- 5.	A further 3 relational queries of your choice that are meaningful to the company.

-- Query 1
# Number of times each engineer fixed cars.
select engineerID, Count(engineerID)as 'No Times Engineer Fixed a car' from breakdown 
group by EngineerID having count(*);

-- Query 2
# Count total number of members and their ID who live in specific location.
select concat(memberFname,' ',memberLname) as 'Member Name' , count(memberID) as 'MemberID', memberLoc 
from member 
where memberLoc='London' group by memberId having count(*);

-- Query 3
# Trigger to Delete member from table and log all info about: 'Why it was deleted by, when and what info deleted
 
create table logInfo
   (
      Message Text Not Null
   );

Delimiter &&
CREATE TRIGGER DeleteMember AFTER DELETE ON Member
   FOR EACH ROW
	BEGIN
        INSERT INTO LogInfo (Message) VALUES(CONCAT(OLD.stdName,' was deleted on ',CURRENT_TIME(),' by ',CURRENT_USER()));
    END&&
 
SELECT * FROM Member;
DELETE FROM Member WHERE MemberName='Ava';
SELECT * FROM LogInfo;
DROP TRIGGER DeletingData;

-- Query 4
# Function to count how many times specific car has been brokendown

DELIMITER $$
create procedure BrkdownCount(in VehicleName varchar(30))
   begin 
     select concat(VehicleReg) as 'Vehicle Name' from breakdown 
     inner join vehicle  on  breakdown.breakdownId=vehicle.vehicleReg
     and vehicle.Make=vehicleName where vehicle.VehicleReg=VehicleMake;
   end$$
 
call  BrkdownCount('BMW');

select
-- Task 5
Using W3Schools or any other resource research the following functions – Avg, Max, Min, Sum.  Explain with examples how each one is used. 
-- The MIN() function returns the smallest value of the selected column.
select min(EngineerID) from engineer;
-- The MAX() function returns the largest value of the selected column.
select max(memberId) from member;
-- The AVG() function returns the average value of a numeric column.
select avg(breakdownId) from breakdown;
-- The SUM() function returns the total sum of a numeric column.
select sum(price) from member;


-- Task 6
-- 1)	If a member has more than one vehicle, then display multi-car policy
SELECT MemberFname, count(vehicleReg) as 'Number of cars',
	CASE
        when count(vehicleReg) > 1 THEN 'Multi-car Policy'
        ELSE 'Not Eligable'
	END AS 'Multi-Car Policy'
FROM member left join  vehicle
on member.memberId=vehicle.memberID group by memberFname having count(vehicleReg) > 1;



select memberFname, count(vehicleReg) as 'Number of cars' from member inner join vehicle 
on member.memberID=vehicle.memberId group by memberFname
having count(vehicleReg)>1;


-- 2)	Create a stored procedure which will display number of cars for any member whose first name 
-- and last name you are passing as argument while calling the stored procedure!

DELIMITER $$
create procedure MemberVehicles (in memFname varchar(30), in memLname varchar(30))
   begin 
      SELECT count(VehicleReg)FROM MEMBER left JOIN VEHICLE 
      ON vehicle.memberID=member.memberID
      where MemberFName=memFname and MemberlName=memLname;
   end $$
 
call MemberVehicles('Anna','Fox');












