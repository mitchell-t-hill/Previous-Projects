--A3MitchellHill3207261 Database Creation Script
--Author: Mitchell Hill (30/10/18)

--START Database Creation Script
--USE CREATE DATABASE WITH 'USE' COMMENTED OUT FOR FIRST EXECUTE.
--ON SECOND EXECUTE, COMMENT OUT CREATE AND ENABLE 'USE'.

--CREATE DATABASE SEEC_RESOURCE_MANAGEMENT

DROP TABLE IF EXISTS Reservations
DROP TABLE IF EXISTS Loan
DROP TABLE IF EXISTS StudentMember
DROP TABLE IF EXISTS StaffMember
DROP TABLE IF EXISTS Member
DROP TABLE IF EXISTS city
DROP TABLE IF EXISTS MoveableResource
DROP TABLE IF EXISTS ImmoveableResource
DROP TABLE IF EXISTS Resource
DROP TABLE IF EXISTS Acquisition
DROP TABLE IF EXISTS ResourceModel
DROP TABLE IF EXISTS CourseOffering
DROP TABLE IF EXISTS Course
DROP TABLE IF EXISTS Privilege
DROP TABLE IF EXISTS Category
DROP TABLE IF EXISTS Location
DROP TABLE IF EXISTS Building

--BEGIN CREATION OF TABLES
USE SEEC_RESOURCE_MANAGEMENT

--CATEGORY TABLE
CREATE TABLE Category (
	categoryName VARCHAR(50) NOT NULL UNIQUE,
	name VARCHAR(255),
	description TEXT,
	maxTimeAllowed VARCHAR(10),
	PRIMARY KEY(categoryName)
);

--PRIVILEGE TABLE
CREATE TABLE Privilege (
	privilegeName VARCHAR(50) NOT NULL UNIQUE,
	description TEXT,
	categoryName VARCHAR(50) NOT NULL,
	maxResources TINYINT NOT NULL,
	PRIMARY KEY(privilegeName),
	FOREIGN KEY(categoryName) REFERENCES Category ON UPDATE CASCADE ON DELETE NO ACTION
);

--CITY TABLE
CREATE TABLE City (
	city VARCHAR(100) NOT NULL,
	state CHAR(50) NOT NULL,
	postcode SMALLINT,
	PRIMARY KEY(city, state)
);

--COURSE TABLE
CREATE TABLE Course (
	courseID VARCHAR(10) NOT NULL UNIQUE,
	name VARCHAR(255) NOT NULL,
	privilegeName VARCHAR(50) NOT NULL,
	PRIMARY KEY(courseID),
	FOREIGN KEY(privilegeName) REFERENCES Privilege ON UPDATE CASCADE ON DELETE NO ACTION
);

--COURSEOFFERING TABLE
CREATE TABLE CourseOffering (
	offeringID VARCHAR(10) NOT NULL UNIQUE,
	courseID VARCHAR(10) NOT NULL,
	courseStartDate DATE NOT NULL,
	courseEndDate DATE NOT NULL,
	semesterOffered VARCHAR(20) NOT NULL,
	yearOffered SMALLINT NOT NULL,
	PRIMARY KEY(offeringID),
	FOREIGN KEY(courseID) REFERENCES Course ON UPDATE CASCADE ON DELETE NO ACTION
);

--MEMBER TABLE
CREATE TABLE Member (
	memberID VARCHAR(10) NOT NULL UNIQUE,
	name VARCHAR(255),
	address TEXT,
	street VARCHAR(255),
	city VARCHAR(100) NOT NULL,
	state CHAR(50) NOT NULL,
	phone INT,
	email VARCHAR(100),
	status VARCHAR(20) NOT NULL,
	comments TEXT,
	PRIMARY KEY(memberID),
	FOREIGN KEY(city, state) REFERENCES City ON UPDATE CASCADE ON DELETE NO ACTION
);

--STUDENTMEMBER TABLE
CREATE TABLE StudentMember (
	memberID VARCHAR(10) NOT NULL,
	points TINYINT,
	offeringID VARCHAR(10) NOT NULL,
	PRIMARY KEY(memberID),
	FOREIGN KEY(memberID) REFERENCES Member ON UPDATE CASCADE ON DELETE NO ACTION,
	FOREIGN KEY(offeringID) REFERENCES CourseOffering ON UPDATE CASCADE ON DELETE NO ACTION
);

--STAFFMEMBER TABLE
CREATE TABLE StaffMember (
	memberID VARCHAR(10) NOT NULL,
	officelocation VARCHAR(100),
	PRIMARY KEY(memberID),
	FOREIGN KEY(memberID) REFERENCES Member ON UPDATE CASCADE ON DELETE NO ACTION
);

--BUILDINGINFO TABLE
CREATE TABLE Building (
	building VARCHAR(20) NOT NULL UNIQUE,
	campus VARCHAR(50),
	PRIMARY KEY(building)
);

--LOCATION TABLE
CREATE TABLE Location (
	locationID VARCHAR(10) NOT NULL UNIQUE,
	room VARCHAR(10) NOT NULL,
	building VARCHAR(20) NOT NULL,
	PRIMARY KEY(locationID),
	FOREIGN KEY(building) REFERENCES Building ON UPDATE CASCADE ON DELETE NO ACTION
);

--RESOURCEMODEL TABLE
CREATE TABLE ResourceModel (
	manufacturer VARCHAR(100) NOT NULL,
	model VARCHAR(100) NOT NULL,
	modelYear SMALLINT,
	description TEXT,
	vendorCode VARCHAR(10) NOT NULL,
	assetValue DECIMAL(10,2),
	PRIMARY KEY(manufacturer, model)
);

--RESOURCE TABLE
CREATE TABLE Resource (
	resourceID VARCHAR(10) NOT NULL UNIQUE,
	description TEXT,
	locationID VARCHAR(10) NOT NULL,
	categoryName VARCHAR(50) NOT NULL,
	status VARCHAR(50),
	PRIMARY KEY(resourceID),
	FOREIGN KEY(locationID) REFERENCES Location ON UPDATE CASCADE ON DELETE NO ACTION,
	FOREIGN KEY(categoryName) REFERENCES Category ON UPDATE CASCADE ON DELETE NO ACTION
);

--MOVEABLERESOURCE TABLE
CREATE TABLE MoveableResource (
	resourceID VARCHAR(10) NOT NULL,
	name VARCHAR(255),
	manufacturer VARCHAR(100) NOT NULL,
	model VARCHAR(100) NOT NULL,
	PRIMARY KEY(resourceID),
	FOREIGN KEY(resourceID) REFERENCES Resource ON UPDATE CASCADE ON DELETE NO ACTION,
	FOREIGN KEY(manufacturer, model) REFERENCES ResourceModel ON UPDATE CASCADE ON DELETE NO ACTION
);

--IMMOVEABLERESOURCE TABLE
CREATE TABLE ImmoveableResource (
	resourceID VARCHAR(10) NOT NULL,
	capacity SMALLINT,
	PRIMARY KEY(resourceID),
	FOREIGN KEY(resourceID) REFERENCES Resource ON UPDATE CASCADE ON DELETE NO ACTION
);

--RESERVATION TABLE
CREATE TABLE Reservations (
	reservationID VARCHAR(10) NOT NULL UNIQUE,
	resourceID VARCHAR(10) NOT NULL,
	memberID VARCHAR(10) NOT NULL,
	dateRequired DATE NOT NULL,
	timeRequired TIME NOT NULL,
	dateDue DATE NOT NULL,
	timeDue TIME NOT NULL,
	PRIMARY KEY(reservationID),
	FOREIGN KEY(resourceID) REFERENCES Resource ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY(memberID) REFERENCES Member ON UPDATE NO ACTION ON DELETE NO ACTION,
);

--LOAN TABLE
CREATE TABLE Loan (
	loanID VARCHAR(10) NOT NULL UNIQUE,
	resourceID VARCHAR(10) NOT NULL,
	memberID VARCHAR(10) NOT NULL,
	dateLoaned DATE NOT NULL,
	timeLoaned TIME NOT NULL,
	dateDue DATE NOT NULL,
	timeDue TIME NOT NULL,
	PRIMARY KEY(loanID),
	FOREIGN KEY(resourceID) REFERENCES Resource ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY(memberID) REFERENCES Member ON UPDATE NO ACTION ON DELETE NO ACTION,
);

--ACQUISITION TABLE
CREATE TABLE Acquisition (
	acquisitionID VARCHAR(10) NOT NULL UNIQUE,
	name VARCHAR(255),
	manufacturer VARCHAR(100) NOT NULL,
	model VARCHAR(100) NOT NULL,
	urgency VARCHAR(50) NOT NULL,
	status VARCHAR(50),
	PRIMARY KEY(acquisitionID),
	FOREIGN KEY(manufacturer, model) REFERENCES ResourceModel ON UPDATE CASCADE ON DELETE NO ACTION
);

--END CREATION OF TABLES
--BEGIN LOADING OF SAMPLE DATA

--BUILDING TABLE
INSERT INTO Building VALUES('BD100', 'Callaghan')
INSERT INTO Building VALUES('BD101', 'Callaghan')
INSERT INTO Building VALUES('BD102', 'Ourimbah')
INSERT INTO Building VALUES('BD103', 'Callaghan')

--LOCATION TABLE
INSERT INTO Location VALUES('LID001', 'RM701', 'BD100')
INSERT INTO Location VALUES('LID002', 'RM702', 'BD100')
INSERT INTO Location VALUES('LID003', 'RM801', 'BD102')
INSERT INTO Location VALUES('LID004', 'RM802', 'BD102')
INSERT INTO Location VALUES('LID005', 'RM803', 'BD103')

--RESOURCEMODEL TABLE
INSERT INTO ResourceModel VALUES('Sennheiser', 'HD 300 Pro', '2014', 'High quality headphones for audio work.', 'VC201', 375.00)
INSERT INTO ResourceModel VALUES('Canon', 'Powershot SX400', '2016', 'Digital camera for photograhpy and image projects.', 'VC202', 150.50)
INSERT INTO ResourceModel VALUES('Tascam', 'DR05 MK2', NULL, 'Handheld microphone to be used in the field when recording audio.', 'VC203', 200.95)
INSERT INTO ResourceModel VALUES('SONY', 'HDR-PJ410', '2017', 'Handheld video camera for recording purposes.', 'VC202', 180.00)
INSERT INTO ResourceModel VALUES('GoPro', 'Hero7 Action Cam', '2016', 'Compact small form device for active video recording.', 'VC201', 300.00)
INSERT INTO ResourceModel VALUES('SONY', 'QuickPix 170', '2015', 'Small handheld camera for images only.', 'VC202', 120.00)

--CATEGORY TABLE
INSERT INTO Category VALUES('Microphone', 'Audio Recording Resource', 'This category includes microphones.', '72:00:00')
INSERT INTO Category VALUES('Camera', 'Video Recording Resource', NULL, '72:00:00')
INSERT INTO Category VALUES('Room', 'Teaching Space Resource', 'This category includes large immoveable resources such as classrooms/labs.', '02:00:00')
INSERT INTO Category VALUES('Speaker', 'Sound Output Resource', 'This category includes speakers used to output sound from a device.', '48:00:00')

--PRIVILEGE TABLE
INSERT INTO Privilege VALUES('audioEquipment', 'This is for audio recording equipment', 'Microphone', '3')
INSERT INTO Privilege VALUES('videoEquipment', 'This is for video recording equipment', 'Camera', '8')
INSERT INTO Privilege VALUES('teachingEquipment', 'This is for equipment that staff use for teaching.', 'Room', '2')
INSERT INTO Privilege VALUES('soundEquipment', 'This is for sound playing equipment.', 'Speaker', '5')

--COURSE TABLE
INSERT INTO Course VALUES('S201', 'Sound Production', 'audioEquipment')
INSERT INTO Course VALUES('S202', 'Film Production', 'videoEquipment')
INSERT INTO Course VALUES('S203', 'History of Australia', 'teachingEquipment')
INSERT INTO Course VALUES('S204', 'Beginners Music', 'soundEquipment')

--COURSEOFFERING TABLE
INSERT INTO CourseOffering VALUES('CO301', 'S201', '2018-08-12', '2018-11-03', 'Semester Two', '2018')
INSERT INTO CourseOffering VALUES('CO302', 'S201', '2018-08-12', '2018-11-03', 'Semester Two', '2018')
INSERT INTO CourseOffering VALUES('CO303', 'S203', '2018-02-06', '2018-06-15', 'Semester One', '2018')
INSERT INTO CourseOffering VALUES('CO304', 'S204', '2018-02-06', '2018-06-15', 'Semester Two', '2018')
INSERT INTO CourseOffering VALUES('CO305', 'S203', '2018-02-28', '2018-07-01', 'Semester One', '2018')
INSERT INTO CourseOffering VALUES('CO306', 'S202', '2018-09-23', '2018-11-26', 'Semester Two', '2018')

--CITY TABLE
INSERT INTO City VALUES('Newcastle', 'NSW', '3333')
INSERT INTO City VALUES('Brisbane', 'QLD', '1111')
INSERT INTO City VALUES('Melbourne', 'VIC', '2222')

--MEMBER TABLE
INSERT INTO Member VALUES('M0601', 'John Smith', '1a', 'Fake Road', 'Newcastle', 'NSW', '0404333000', 'john.smith@email.com', 'active', NULL)
INSERT INTO Member VALUES('M0602', 'Jane Citizen', '13b', 'Hidden Street', 'Brisbane', 'QLD', '0404777111', 'jane.citizen@coolemail.com', 'active', 'Orange shirt.')
INSERT INTO Member VALUES('M0603', 'Paul Nobody', '58', 'Sesame Street', 'Newcastle', 'NSW', '0421888222', 'paul.nobody@email.com', 'active', 'Come on down.')
INSERT INTO Member VALUES('M0604', 'Kerry Ingham', '49', 'Walbort Cresent', 'Newcastle', 'NSW', '0482333888', 'kerry.ingham@email.com', 'active', 'Whos on first, whats on second.')
INSERT INTO Member VALUES('M0001', 'Julian Wong', '23', 'Martin Place', 'Melbourne', 'VIC', '0467555666', 'julian.wong@email.com', 'active', 'Staff better than students.')
INSERT INTO Member VALUES('M0002', 'Kevin McDougal', '703', 'High Street', 'Newcastle', 'NSW', '0422444777', 'kevin.mcdougal@email.com', 'active', 'Member is a responsible person.')
INSERT INTO Member VALUES('M0003', 'Patricia White', '12a', 'Longman Road', 'Newcastle', 'NSW', '0431999555', 'patricia.white@email.com', 'active', NULL)

--STUDENTMEMBER TABLE
INSERT INTO StudentMember VALUES('M0601', '5', 'CO303')
INSERT INTO StudentMember VALUES('M0602', '3', 'CO302')
INSERT INTO StudentMember VALUES('M0603', '5', 'CO304')
INSERT INTO StudentMember VALUES('M0604', '2', 'CO301')

--STAFFMEMBER TABLE
INSERT INTO StaffMember VALUES('M0001', 'RM213')
INSERT INTO StaffMember VALUES('M0002', 'RM481')
INSERT INTO StaffMember VALUES('M0003', 'RM921')

--RESOURCE TABLE
INSERT INTO Resource VALUES('RID001', 'This is a Canon camera resource.', 'LID002', 'Camera', 'Available')
INSERT INTO Resource VALUES('RID002', 'This is a microphone resource.', 'LID001', 'Microphone', 'Available')
INSERT INTO Resource VALUES('RID003', 'This is a headphone resource.', 'LID001', 'Microphone', 'Available')
INSERT INTO Resource VALUES('RID004', 'This is a SONY camera rseource.', 'LID002', 'Camera', 'Available')
INSERT INTO Resource VALUES('RID201', 'This is a computer lab resource.', 'LID003', 'Room', 'Available')
INSERT INTO Resource VALUES('RID202', 'This is a teaching classroom.', 'LID004', 'Room', 'Available')
INSERT INTO Resource VALUES('RID203', 'This is a lecture hall/theatre.', 'LID005', 'Room', 'Available')

--MOVEABLERESOURCE TABLE
INSERT INTO MoveableResource VALUES('RID001', 'Canon Camera', 'Canon', 'Powershot SX400')
INSERT INTO MoveableResource VALUES('RID002', 'Tascam Microphone', 'Tascam', 'DR05 MK2')
INSERT INTO MoveableResource VALUES('RID003', 'Sennheiser Headphones', 'Sennheiser', 'HD 300 Pro')
INSERT INTO MoveableResource VALUES('RID004', 'SONY Camera', 'SONY', 'QuickPix 170')

--IMMOVEABLERESOURCE TABLE
INSERT INTO ImmoveableResource VALUES('RID201', 20)
INSERT INTO ImmoveableResource VALUES('RID202', 30)
INSERT INTO ImmoveableResource VALUES('RID203', 120)

--ACQUISITION TABLE
INSERT INTO Acquisition VALUES('AID001', 'Sony Video Camera', 'SONY', 'HDR-PJ410', 'LOW', 'Ordered')
INSERT INTO Acquisition VALUES('AID002', 'Tascam Microphone', 'Tascam', 'DR05 MK2', 'HIGH', 'Received')
INSERT INTO Acquisition VALUES('AID003', 'GoPro Camera', 'GoPro', 'Hero7 Action Cam', 'LOW', 'Ordered')

--RESERVATIONS TABLE
INSERT INTO Reservations VALUES('RVID0001', 'RID001', 'M0602', '2018-08-13', '11:30:00', '2018-08-16', '11:30:00')
INSERT INTO Reservations VALUES('RVID0002', 'RID201', 'M0003', '2018-03-28', '09:00:00', '2018-03-28', '11:00:00')
INSERT INTO Reservations VALUES('RVID0003', 'RID003', 'M0602', '2018-08-14', '10:45:00', '2018-08-17', '10:45:00')
INSERT INTO Reservations VALUES('RVID0004', 'RID201', 'M0002', '2018-03-28', '12:00:00', '2018-03-28', '14:00:00')
INSERT INTO Reservations VALUES('RVID0005', 'RID201', 'M0002', '2018-05-01', '10:30:00', '2018-03-28', '12:30:00')

--LOAN TABLE
INSERT INTO Loan VALUES('LID0001', 'RID002', 'M0601', '2017-05-07', '14:25:00', '2017-05-10', '14:25:00')
INSERT INTO Loan VALUES('LID0002', 'RID001', 'M0603', '2017-09-17', '11:25:00', '2017-09-20', '11:25:00')
INSERT INTO Loan VALUES('LID0003', 'RID201', 'M0002', '2018-09-09', '12:45:00', '2018-09-09', '14:45:00')
INSERT INTO Loan VALUES('LID0004', 'RID001', 'M0602', '2018-10-01', '09:35:00', '2018-09-12', '09:35:00')
INSERT INTO Loan VALUES('LID0005', 'RID004', 'M0603', '2018-04-22', '10:15:00', '2018-04-25', '10:15:00')
INSERT INTO Loan VALUES('LID0006', 'RID001', 'M0001', '2018-07-05', '15:30:00', '2018-07-08', '15:30:00')
INSERT INTO Loan VALUES('LID0007', 'RID001', 'M0601', '2018-08-02', '12:15:00', '2018-07-05', '12:15:00')

--END LOADING OF SAMPLE DATA
--BEGIN TEST STATEMENTS (USE THESE TO VIEW ALL TABLES AND DATA IF NECESSARY)

/*SELECT * FROM Category
SELECT * FROM Privilege
SELECT * FROM Course
SELECT * FROM CourseOffering
SELECT * FROM City
SELECT * FROM StudentMember
SELECT * FROM StaffMember
SELECT * FROM Member
SELECT * FROM Location
SELECT * FROM ResourceModel
SELECT * FROM Resource
SELECT * FROM MoveableResource
SELECT * FROM ImmoveableResource
SELECT * FROM Reservations
SELECT * FROM Loan
SELECT * FROM Acquisition
SELECT * FROM Building*/

--END TEST STATEMENTS
--END Database Creation Script