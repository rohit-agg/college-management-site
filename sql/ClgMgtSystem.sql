create database ClgMgtSite

go

use ClgMgtSite

go

create schema Administration

go

create schema Employee

go

create schema Faculty

go

create schema Student

go

create schema Library

go

create schema TimeTable

go

create schema ExamCell

go

create schema Inventory

go

create schema TandP

go

create table Administration.Department
(
	DepartmentID tinyint identity(1,1) not null,
	Name varchar(100) not null,
	Type varchar(25) not null,
	constraint ADUniqueDepartment primary key (Name),
	constraint ADUniqueDepartmentID unique (DepartmentID),
	constraint ADCheckType check (Type in ('Management','Education'))
)

go

create table Administration.Degree
(
	DegreeID tinyint identity(1,1) not null,
	Degree varchar(100) not null,
	SDegree varchar(10) not null,
	Duration tinyint not null,
	NoOfSemester tinyint not null,
	constraint ADgUniqueDegree primary key (Degree),
	constraint ADgUniqueDegreeID unique (DegreeID),
	constraint ADgCheckDuration check (Duration > 0),
	constraint ADgCheckNoOfSemester check (NoOfSemester > 0),
	constraint ADgCheckSemester check (NoOfSemester = Duration or NoOfSemester = (Duration*2))
)

go

create table Administration.Batch
(
	BatchID tinyint identity(1,1) not null,
	StartYear smallint not null,
	EndYear smallint not null,
	constraint ABUniqueBatch primary key (StartYear, EndYear),
	constraint ABUniqueBatchID unique (BatchID),
	constraint ABCheckStartYear check (StartYear > 0),
	constraint ABcheckEndYear check (EndYear > 0 and EndYear > StartYear)
)

go

create table Administration.Subject
(
	SubjectCode varchar(25) not null,
	SubjectName varchar(100) not null,
	ExamCode varchar(25) not null,
	MaximumMarks tinyint not null,
	constraint ASUniqueSubject primary key (SubjectCode),
	constraint ASUniqueExamCode unique (ExamCode),
	constraint ASCheckMaximumMarks check (MaximumMarks > 0)
)

go

create function Administration.MaximumSemester(@DegreeID int)
returns int
as
begin
return (select NoOfSemester from Administration.Degree where DegreeID = @DegreeID)
end

go

create function Administration.DepartmentType(@DepartmentID int)
returns tinyint
as
begin
if exists (select * from Administration.Department where DepartmentID = @DepartmentID and Type='Education')
	return 1
return 0
end

go

create table Administration.AllowedSubject
(
	SubjectCode varchar(25) not null,
	Category varchar(20) not null,
	DegreeID tinyint not null,
	DepartmentID tinyint not null,
	Semester tinyint not null,
	constraint AASUniqueAllowedSubject primary key (SubjectCode, DegreeID, DepartmentID),
	constraint AASCheckSemester check (Semester > 0 and Semester <= Administration.MaximumSemester(DegreeID)),
	constraint AASCheckSubject foreign key (SubjectCode) references Administration.Subject(SubjectCode),
	constraint AASCheckDegree foreign key (DegreeID) references Administration.Degree(DegreeID),
	constraint AASCheckDepartment foreign key (DepartmentID) references Administration.Department(DepartmentID),
	constraint AASCheckDepartmentType check (Administration.DepartmentType(DepartmentID) = 1),
	constraint AASCheckCategory check (Category in ('Main', 'Elective'))
)

go

create table Employee.PersonalDetail
(
	EmployeeID varchar(20) not null,
	Name varchar(50) not null,
	FatherName varchar(50) not null,
	MotherName varchar(50) not null,
	Address varchar(150) not null,
	DateOfBirth date not null,
	Gender varchar(10) not null,
	ContactNo varchar(15),
	EMailID varchar(50),
	Photo varchar(250),
	constraint EPDUniqueEmployeeID primary key (EmployeeID),
	constraint EPDUniqueEmployee unique (Name, FatherName, Address, DateOfBirth),
	constraint EPDCheckGender check (Gender in ('Male', 'Female')),
	constraint EPDCheckEMailID check (EMailID like '_%@_%._%' or EMailID is null)
)

go

create table Employee.DepartmentDetail
(
	EmployeeID varchar(20) not null,
	DepartmentID tinyint not null,
	Designation varchar(50) not null,
	constraint EDDUniqueEmployee primary key (EmployeeID),
	constraint EDDUniqueEmployeeDesignation unique (EmployeeID, DepartmentID, Designation),
	constraint EDDCheckEmployee foreign key (EmployeeID) references Employee.PersonalDetail(EmployeeID),
	constraint EDDCheckDepartmentID foreign key (DepartmentID) references Administration.Department(DepartmentID)
)

go

create table Employee.EducationalQualification
(
	EmployeeID varchar(20) not null,
	XMarks tinyint not null,
	XYear smallint not null,
	XIIMarks tinyint not null,
	XIIYear smallint not null,
	GradMarks tinyint not null,
	GradYear smallint not null,
	GradUniv varchar(50) not null,
	constraint EEQUniqueEmployee primary key (EmployeeID),
	constraint EEQCheckEmployee foreign key (EmployeeID) references Employee.PersonalDetail(EmployeeID),
	constraint EEQCheckExam check (XYear < XIIYear and XIIYear < GradYear)
)

go

create table Employee.Leave
(
	EmployeeID varchar(20) not null,
	LeaveDate date not null,
	LeaveDetails varchar(150) not null,
	constraint ELUniqueLeave primary key (EmployeeID, LeaveDate),
	constraint ELCheckEmployee foreign key (EmployeeID) references Employee.PersonalDetail(EmployeeID)
)

go

create table Employee.Payroll
(
	EmployeeID varchar(20) not null,
	MonthlySalary money not null,
	constraint EPUniqueEmployee primary key (EmployeeID),
	constraint EPCheckEmployee foreign key (EmployeeID) references Employee.PersonalDetail(EmployeeID),
	constraint EPCheckAmount check (MonthlySalary > 0),	
)

go

create function Faculty.MaximumYear(@EmployeeID varchar(20))
returns smallint
as
begin
return (select GradYear from Employee.EducationalQualification where EmployeeID = @EmployeeID)
end

go

create table Faculty.AdditionalQualification
(
	EmployeeID varchar(20) not null,
	PostGradMarks tinyint not null,
	PostGradYear smallint not null,
	PostGraduniv varchar(50) not null,
	PHdYear smallint,
	PHdUniv varchar(50),
	constraint FAQUniqueEmployee primary key (EmployeeID),
	constraint FAQCheckEmployee foreign key (EmployeeID) references Employee.PersonalDetail(EmployeeID),
	constraint FAQCheckYear check (PostGradYear > Faculty.MaximumYear(EmployeeID))
)

go

create function Faculty.CheckSemester(@SubjectCode varchar(25), @DepartmentID tinyint, @DegreeID tinyint)
returns tinyint
as
begin
return (select Semester from Administration.AllowedSubject where SubjectCode = @SubjectCode and DepartmentID = @DepartmentID and DegreeID = @DegreeID)
end

go

create table Faculty.SubjectHandled
(
	EmployeeID varchar(20) not null,
	Semester tinyint not null,
	DepartmentID tinyint not null,
	DegreeID tinyint not null,
	SubjectCode varchar(25) not null,
	constraint FSHUniqueSubject primary key (EmployeeID, Semester, DepartmentID, DegreeID, SubjectCode),
	constraint FSHCheckEmployee foreign key (EmployeeID) references Employee.PersonalDetail(EmployeeID),
	constraint FSHCheckDepartment foreign key (DepartmentID) references Administration.Department(DepartmentID),
	constraint FSHCheckDegree foreign key (DegreeID) references Administration.Degree(DegreeID),
	constraint FSHCheckSubject foreign key (SubjectCode) references Administration.Subject(SubjectCode),
	constraint FSHCheckSemester check (Faculty.CheckSemester(SubjectCode, DepartmentID, DegreeID) = Semester)
)

go

create table Student.PersonalDetail
(
	RollNo varchar(20) not null,
	Name varchar(50) not null,
	FatherName varchar(50) not null,
	MotherName varchar(50) not null,
	Address varchar(150) not null,
	DateOfBirth date not null,
	Gender char(10) not null,
	ContactNo varchar(15),
	EMailID varchar(150),
	Category varchar(10) not null,
	Photo varchar(250),
	constraint SPDUniqueStudentRollNo primary key (RollNo),
	constraint SPDUniqueStudent unique (Name, FatherName, Address, DateOfBirth),
	constraint SPDCheckGender check (Gender in ('Male', 'Female')),
	constraint SPDCheckEMailID check (EMailID like '_%@_%._%' or EmailID is null)
)

go

create table Student.AdmissionDetail
(
	RollNo varchar(20) not null,
	Counselling tinyint not null,
	BatchID tinyint not null,
	DegreeID tinyint not null,
	DepartmentID tinyint not null,
	XMarks int not null,
	XYear smallint not null,
	XIIMarks int,
	XIIYear smallint,
	EntranceExam varchar(50) not null,
	EERollNo varchar(15) not null,
	EEScore	smallint not null,
	EERank int not null,
	constraint SADUniqueStudent primary key (RollNo),
	constraint SADCheckStudent foreign key (RollNo) references Student.PersonalDetail(RollNo),
	constraint SADCheckBatch foreign key (BatchID) references Administration.Batch(BatchID),
	constraint SADCheckDegree foreign key (DegreeID) references Administration.Degree(DegreeID),
	constraint SADCheckDepartment foreign key (DepartmentID) references Administration.Department(DepartmentID),	
	constraint SADCheckExam check (XYear < XIIYear or XIIYear is null)
)

go

create function Student.MaximumYear(@RollNo varchar(20))
returns smallint
as
begin
if ((select XIIYear from Student.AdmissionDetail where RollNo = @RollNo) != null)
	return (select XIIYear from Student.AdmissionDetail where RollNo = @RollNo)
return (select XYear from Student.AdmissionDetail where RollNo = @RollNo)
end

go

create table Student.ExtraAdmissionDetail
(
	RollNo varchar(20) not null,
	DiplomaCollege varchar(50) not null,
	DiplomaBranch varchar(25) not null,
	DiplomaYear smallint not null,
	DiplomaMarks int not null,
	constraint SEADUniqueStudent primary key (RollNo),
	constraint SEADCheckStudent foreign key (RollNo) references Student.PersonalDetail(RollNo),
	constraint SEADCheckDiplomaYear check (DiplomaYear > Student.MaximumYear(RollNo))
)

go

create function Student.MaximumSemester(@RollNo varchar(20))
returns tinyint
as
begin
return (select NoOfSemester from Administration.Degree where DegreeID = (select DegreeID from Student.AdmissionDetail where RollNo = @RollNo))
end

go

create table Student.RegistrationDetail
(
	RegistrationNo varchar(25) not null,
	RollNo varchar(20) not null,
	Semester tinyint not null,
	constraint SRDUniqueRegistration primary key (RegistrationNo),
	constraint SRDUniqueRollNo unique (RollNo),
	constraint SRDCheckRollNo foreign key (RollNo) references Student.PersonalDetail(RollNo),
	constraint SRDCheckYear check (Semester <= Student.MaximumSemester(RollNo)),	
)

go

create table Student.Attendance
(
	RollNo varchar(20) not null,
	SubjectCode varchar(25) not null,
	Attendance tinyint not null,
	AttendanceTotal tinyint not null,
	constraint SAUniqueAttendance primary key (RollNo, SubjectCode),
	constraint SACheckRollNo foreign key (RollNo) references Student.PersonalDetail(RollNo),
	constraint SACheckSubject foreign key (SubjectCode) references Administration.Subject(SubjectCode),
	constraint SACheckAttendance check (Attendance <= AttendanceTotal),	
)

go

create table Student.Fees
(
	RollNo varchar(20) not null,
	DateOfSubmit date not null,
	ReceiptNo int not null,
	Amount money not null,
	Type varchar(20) not null,
	Details varchar(50),
	constraint SFUniqueFees primary key (RollNo, DateOfSubmit),
	constraint SFCheckRollNo foreign key (RollNo) references Student.PersonalDetail(RollNo),
	constraint SFCheckType check (Type in ('Cash', 'Cheque', 'Demand Draft')),
	constraint SFCheckAmount check (Amount > 0)
)

go

create table Library.Book
(
	ISBNNo varchar(20) not null,
	Title varchar(100) not null,
	Author varchar(50) not null,
	Publisher varchar(100) not null,
	Price smallmoney not null,
	constraint LBUniqueBookNo primary key (ISBNNo),
	constraint LBCheckPrice check (Price > 0)
)

go

create table Library.BookRecord
(
	ReferenceNo varchar(25) not null,
	ISBNNo varchar(20) not null,
	Category varchar(15) not null,
	Status char(15) not null,
	constraint LBRUniqueBook primary key (ReferenceNo),
	constraint LBRCheckBookNo foreign key (ISBNNo) references Library.Book(ISBNNo),
	constraint LBRCheckCategory check (Category in ('Reserved', 'General')),
	constraint LBRCheckStatus check (Status in ('Available', 'Issued'))
)

go

create table Library.CurrentFaculty
(
	EmployeeID varchar(20) not null,
	ReferenceNo varchar(25) not null,
	DateOfIssue date not null,
	constraint LCFUniqueTransaction primary key (EmployeeID, ReferenceNo),
	constraint LCFUniqueBook unique (ReferenceNo),
	constraint LCFCheckBook foreign key (ReferenceNo) references Library.BookRecord(ReferenceNo),
	constraint LCFCheckEmployeeID foreign key (EmployeeID) references Employee.PersonalDetail(EmployeeID)
)

go

create table Library.FacultyTransaction
(
	EmployeeID varchar(20) not null,
	ReferenceNo varchar(25) not null,
	DateOfIssue date not null,
	DateOfReturn date not null,
	constraint LFTUniqueTransaction primary key (EmployeeID, ReferenceNo, DateOfIssue),
	constraint LFTCheckBook foreign key (ReferenceNo) references Library.BookRecord(ReferenceNo),
	constraint LFTCheckEmployeeID foreign key (EmployeeID) references Employee.PersonalDetail(EmployeeID),
	constraint LFTCheckDate check (DateOfIssue < DateOfReturn)
)

go

create function Library.CheckBook(@ReferenceNo varchar(25))
returns tinyint
as
begin
if exists (select * from Library.BookRecord where ReferenceNo = @ReferenceNo and Category = 'General')
	return 1;
return 0;
end

go

create table Library.CurrentStudent
(
	RollNo varchar(20) not null,
	ReferenceNo varchar(25) not null,
	DateOfIssue date not null,
	DateOfReturn date not null,
	constraint LCSUniqueTransaction primary key (RollNo, ReferenceNo),
	constraint LCSUniqueBook unique (ReferenceNo),
	constraint LCSCheckBook foreign key (ReferenceNo) references Library.BookRecord(ReferenceNo),
	constraint LCSCheckRollNo foreign key (RollNo) references Student.PersonalDetail(RollNo),
	constraint LCSCheckBookType check (Library.CheckBook(ReferenceNo) = 1),
	        constraint LCSCheckDate check (DateOfIssue < DateOfReturn)
)

go

create table Library.StudentTransaction
(
	RollNo varchar(20) not null,
	ReferenceNo varchar(25) not null,
	DateOfIssue date not null,
	ActualDateOfReturn date not null,
	DateOfReturn date not null,
	Fine tinyint not null,
	constraint LSTUniqueTransaction primary key (RollNo, ReferenceNo, DateOfIssue),
	constraint LSTCheckBook foreign key (ReferenceNo) references Library.BookRecord(ReferenceNo),
	constraint LSTCheckRollNo foreign key (RollNo) references Student.PersonalDetail(RollNo),
	constraint LSTCheckDate check (DateOfIssue < DateOfReturn),
	constraint LSTCheckFine check (Fine >= 0)
)

go

create table TimeTable.ClassDetail
(
	TimeTableID int identity(1,1) not null,
	Semester tinyint not null,
	BatchID tinyint not null,
	DegreeID tinyint not null,
	DepartmentID tinyint not null,
	constraint TTCDUniqueTimeTable primary key (Semester, BatchID, DegreeID, DepartmentID),
	constraint TTCDUniqueTimeTableID unique (TimeTableID),
	constraint TTCDCheckDegree foreign key (DegreeID) references Administration.Degree(DegreeID),
	constraint TTCDCheckDepartment foreign key (DepartmentID) references Administration.Department(DepartmentID),
	constraint TTCDCheckBatch foreign key (BatchID) references Administration.Batch(BatchID),
	constraint TTCDCheckSemester check (Semester <= Administration.MaximumSemester(DegreeID))
)

go

create table TimeTable.Timings
(
	Lecture tinyint not null,
	StartTime datetime not null,
	EndTime datetime not null,
	constraint TTTUniqueLectureNo primary key (Lecture),
	constraint TTTUniqueStartTime unique (StartTime),
	constraint TTTUniqueEndTime unique (EndTime),
	constraint TTTCheckTime check (StartTime < EndTime)
)

go

create function Faculty.EmployeeSubject(@EmployeeID varchar(20), @SubjectCode varchar(25))
returns bit
as
begin
if(@EmployeeID is null and @SubjectCode is null)
	return 1
else if exists (select * from Faculty.SubjectHandled where EmployeeID = @EmployeeID and SubjectCode = @SubjectCode)
	return 1
return 0
end

go

create table TimeTable.Monday
(
	TimeTableID int not null,
	Lecture tinyint not null,
	SubjectCode varchar(25),
	EmployeeID varchar(20),
	constraint TTMUniqueLecture primary key (TimeTableID, Lecture),
	constraint TTMUniqueTeaching unique (Lecture, EmployeeID),
	constraint TTMCheckTimeTable foreign key (TimeTableID) references TimeTable.ClassDetail(TimeTableID),
	constraint TTMCheckLecture foreign key (Lecture) references TimeTable.Timings(Lecture),
	constraint TTMCheckSubject foreign key (SubjectCode) references Administration.Subject(SubjectCode),
	constraint TTMCheckEmployee foreign key (EmployeeID) references Employee.PersonalDetail(EmployeeID),
	constraint TTMCheckEmployeeSubject check (Faculty.EmployeeSubject(EmployeeID, SubjectCode) = 1)
)

go

create table TimeTable.Tuesday
(
	TimeTableID int not null,
	Lecture tinyint not null,
	SubjectCode varchar(25),
	EmployeeID varchar(20),
	constraint TTTUniqueLecture primary key (TimeTableID, Lecture),
	constraint TTTUniqueTeaching unique (Lecture, EmployeeID),
	constraint TTTCheckTimeTable foreign key (TimeTableID) references TimeTable.ClassDetail(TimeTableID),
	constraint TTTCheckLecture foreign key (Lecture) references TimeTable.Timings(Lecture),
	constraint TTTCheckSubject foreign key (SubjectCode) references Administration.Subject(SubjectCode),
	constraint TTTCheckEmployee foreign key (EmployeeID) references Employee.PersonalDetail(EmployeeID),
	constraint TTTCheckEmployeeSubject check (Faculty.EmployeeSubject(EmployeeID, SubjectCode) = 1)	
)

go

create table TimeTable.Wednesday
(
	TimeTableID int not null,
	Lecture tinyint not null,
	SubjectCode varchar(25),
	EmployeeID varchar(20),
	constraint TTWUniqueLecture primary key (TimeTableID, Lecture),
	constraint TTWUniqueTeaching unique (Lecture, EmployeeID),
	constraint TTWCheckTimeTable foreign key (TimeTableID) references TimeTable.ClassDetail(TimeTableID),
	constraint TTWCheckLecture foreign key (Lecture) references TimeTable.Timings(Lecture),
	constraint TTWCheckSubject foreign key (SubjectCode) references Administration.Subject(SubjectCode),
	constraint TTWCheckEmployee foreign key (EmployeeID) references Employee.PersonalDetail(EmployeeID),
	constraint TTWCheckEmployeeSubject check (Faculty.EmployeeSubject(EmployeeID, SubjectCode) = 1)
)

go

create table TimeTable.Thursday
(
	TimeTableID int not null,
	Lecture tinyint not null,
	SubjectCode varchar(25),
	EmployeeID varchar(20),
	constraint TTThUniqueLecture primary key (TimeTableID, Lecture),
	constraint TTThUniqueTeaching unique (Lecture, EmployeeID),
	constraint TTThCheckTimeTable foreign key (TimeTableID) references TimeTable.ClassDetail(TimeTableID),
	constraint TTThCheckLecture foreign key (Lecture) references TimeTable.Timings(Lecture),
	constraint TTThCheckSubject foreign key (SubjectCode) references Administration.Subject(SubjectCode),
	constraint TTThCheckEmployee foreign key (EmployeeID) references Employee.PersonalDetail(EmployeeID),
	constraint TTThCheckEmployeeSubject check (Faculty.EmployeeSubject(EmployeeID, SubjectCode) = 1)
)

go

create table TimeTable.Friday
(
	TimeTableID int not null,
	Lecture tinyint not null,
	SubjectCode varchar(25),
	EmployeeID varchar(20),
	constraint TTFUniqueLecture primary key (TimeTableID, Lecture),
	constraint TTFUniqueTeaching unique (Lecture, EmployeeID),
	constraint TTFCheckTimeTable foreign key (TimeTableID) references TimeTable.ClassDetail(TimeTableID),
	constraint TTFCheckLecture foreign key (Lecture) references TimeTable.Timings(Lecture),
	constraint TTFCheckSubject foreign key (SubjectCode) references Administration.Subject(SubjectCode),
	constraint TTFCheckEmployee foreign key (EmployeeID) references Employee.PersonalDetail(EmployeeID),
	constraint TTFCheckEmployeeSubject check (Faculty.EmployeeSubject(EmployeeID, SubjectCode) = 1)
)

go

create table ExamCell.Exam
(
	ExamID int identity(1,1) not null,
	BatchID tinyint not null,
	DegreeID tinyint not null,
	DepartmentID tinyint not null,
	Semester tinyint not null,
	Type varchar(15) not null,
	constraint ECEUniqueExam primary key (ExamID),
	constraint ECEUniqueCourseExam unique (BatchID, DepartmentID, DegreeID, Semester, Type),
	constraint ECECheckType check (Type in ('Main', 'Reappear')),
	constraint ECECheckBatch foreign key (BatchID) references Administration.Batch(BatchID),
	constraint ECECheckDegree foreign key (DegreeID) references Administration.Degree(DegreeID),
	constraint ECECheckDepartment foreign key (DepartmentID) references Administration.Department(DepartmentID),
	constraint ECECheckSemester check (Semester > 0 and Semester <= Administration.MaximumSemester(DegreeID))
)

go

create function Student.StudentExam(@RegistrationNo varchar(25), @ExamID tinyint)
returns bit
as
begin
if exists (select * from (Student.RegistrationDetail SRD join Student.AdmissionDetail SAD on SRD.RollNo = SAD.RollNo) 
				join ExamCell.Exam ECE on (ECE.BatchID = SAD.BatchID and ECE.DegreeID = SAD.DegreeID and ECE.DepartmentID = SAD.DepartmentID)
					where SRD.RegistrationNo = @RegistrationNo and ECE.ExamID = @ExamID)
	return 1
return 0
end

go

create table Student.ExamDetail
(
	RegistrationNo varchar(25) not null,
	ExamRollNo varchar(15) not null,
	ExamID int not null,
	constraint SEDUniqueRollNo primary key (ExamRollNo),
	constraint SEDUniqueExam unique (RegistrationNo, ExamID),
	constraint SEDCheckRegistrationNo foreign key (RegistrationNo) references Student.RegistrationDetail(RegistrationNo),
	constraint SEDCheckExam foreign key (ExamID) references ExamCell.Exam(ExamID),
	constraint SEDCheckStudentExam check (Student.StudentExam(RegistrationNo, ExamID) = 1)
)

go

create function Student.SubjectExists(@ExamRollNo varchar(15), @SubjectExamCode varchar(25))
returns bit
as
begin
if exists (select * from (Administration.Subject ASA join Administration.AllowedSubject AAS on ASA.SubjectCode = AAS.SubjectCode) 
				join (Student.AdmissionDetail SAD join Student.RegistrationDetail SRD on SAD.RollNo = SRD.RollNo) 
					on (AAS.DepartmentID = SAD.DepartmentID and AAS.DegreeID = SAD.DegreeID)
				where ASA.ExamCode = @SubjectExamCode and SRD.RegistrationNo = (select ED.RegistrationNo from ExamDetail ED where ED.ExamRollNo = @ExamRollNo))
	return 1
return 0
end

go

create table ExamCell.StudentExam
(
	ExamRollNo varchar(15) not null,
	ExamID int not null,
	SubjectCode varchar(25) not null,
	SheetNo varchar(20) not null,
	constraint ECSEUniqueStudentExam primary key (ExamRollNo, SheetNo),
	constraint ECSEUniqueSheet unique (SheetNo),
	constraint ECSECheckExam foreign key (ExamID) references ExamCell.Exam(ExamID),
	constraint ECSECheckStudent foreign key (ExamRollNo) references Student.ExamDetail(ExamRollNo),
	constraint ECSECheckSubject foreign key (SubjectCode) references Administration.Subject(ExamCode),
	constraint ECSECheckSubjectExists check (Student.SubjectExists(ExamRollNo, SubjectCode) = 1)
)

go

create table ExamCell.PaperChecking
(
	EmployeeID varchar(20) not null,
	SheetNo varchar(20) not null,
	MarksObtained tinyint not null,
	constraint ECPCUniqueChecking primary key (EmployeeID, SheetNo),
	constraint ECPCCheckEmployee foreign key (EmployeeID) references Employee.PersonalDetail(EmployeeID),
	constraint ECPCCheckSheet foreign key (SheetNo) references ExamCell.StudentExam(SheetNo),
	constraint ECPCCheckMarks check (MarksObtained > 0)
)

go

create function Administration.SubjectMaximumMarks(@SubjectExamCode varchar(25))
returns tinyint
as 
begin
return (select MaximumMarks from Administration.Subject where ExamCode = @SubjectExamCode)
end

go

create table Student.Result
(
	ExamRollNo varchar(15) not null,
	SubjectExamCode varchar(25) not null,
	MarksObtained tinyint not null,
	constraint SRUniqueResult primary key (ExamRollNo, SubjectExamCode),
	constraint SRCheckRollNo foreign key (ExamRollNo) references Student.ExamDetail(ExamRollNo),
	constraint SRCheckSubject foreign key (SubjectExamCode) references Administration.Subject(ExamCode),
	constraint SRCheckMarks check (MarksObtained > 0 and MarksObtained <= Administration.SubjectMaximumMarks(SubjectExamCode)),
	constraint SRCheckSubjectExists check (Student.SubjectExists(ExamRollNo, SubjectExamCode) = 1)
)

go

create table Inventory.Item
(
	ItemID int identity(1,1) not null,
	ItemName varchar(50) not null,
	ItemDetails varchar(250) not null,
	constraint IIUniqueItem primary key (ItemID)
)

go

create table Inventory.Supplier
(
	SupplierID int identity(1,1) not null,
	SupplierName varchar(100) not null,
	Address varchar(100) not null,
	ContactNo char(15) not null,
	constraint ISUniqueSupplierID primary key (SupplierID),
	constraint ISUniqueSupplier unique (SupplierName)
)

go

create table Inventory.BillDetail
(
	PurchaseID int identity(1,1) not null,
	BillNo varchar(25) not null,
	SupplierID int not null,	
	BillDate date not null,
	Amount money not null,
	constraint IBDUniqueBill primary key (BillNo),
	constraint IBDUniquePurchase unique (PurchaseID),
	constraint IBDCheckSupplier foreign key (SupplierID) references Inventory.Supplier(SupplierID),
	constraint IBDCheckAmount check (Amount > 0)
)

go

create table Inventory.Purchase
(
	PurchaseID int not null,
	ItemID int not null,
	Quantity int not null,
	constraint IPUniquePurchase primary key (PurchaseID, ItemID),
	constraint IPCheckItem foreign key (ItemID) references Inventory.Item(ItemID),
	constraint IPCheckPurchase foreign key (PurchaseID) references Inventory.BillDetail(PurchaseID),
	constraint IPCheckQuantity check (Quantity > 0)
)

go

create table TandP.CompanyDetails
(
	CompanyID int identity(1,1) not null,
	Name varchar(100) not null,	
	Address varchar(150) not null,
	ContactNo varchar(15) not null,
	Placements int not null,
	constraint TPCDUniqueCompany primary key (Name),
	constraint TPCDUniqueCompanyID unique (CompanyID),
	constraint TPCDCheckPlacements check (Placements >= 0)
)

go

create table TandP.CompanyCriteria
(
	CompanyID int not null,
	AveragePercentage tinyint not null,
	Backlogs char(15) not null,
	Supplementary char(15) not null,
	MaxSupplementary tinyint,
	SemesterPercentile tinyint,
	constraint TPCCUniqueCriteria primary key (CompanyID),
	constraint TPCCCheckCompany foreign key (CompanyID) references TandP.CompanyDetails(CompanyID),
	constraint TPCCCheckBacklogs check (Backlogs in ('Allowed', 'Not Allowed')),
	constraint TPCCCheckSupplementary check (Supplementary in ('Allowed' ,'Not Allowed'))
)

go

create table TandP.PlacedStudent
(
	RollNo varchar(20) not null,
	CompanyID int not null,
	Package money not null,
	Designation varchar(50) not null,
	constraint TPPSUniquePlacement primary key (RollNo, CompanyID),
	constraint TPPSCheckStudent foreign key (RollNo) references Student.PersonalDetail(RollNo),
	constraint TPPSCheckCompany foreign key (CompanyID) references TandP.CompanyDetails(CompanyID)
)

go

create table TandP.StudentCV
(
	RollNo varchar(20) not null,
	CVLocation varchar(250) not null,
	constraint TPSCVUniqueCV primary key (RollNo),
	constraint TPSCVCheckStudent foreign key (RollNo) references Student.RegistrationDetail(RollNo)
)

go

create function CheckUniqueID(@UniqueID varchar(25), @Category varchar(25))
returns bit
as
begin
if(@Category = 'Student')
	if exists(select * from Student.RegistrationDetail where RegistrationNo = @UniqueID)
		return (1)
	else
		return (0)
if exists(select * from Employee.PersonalDetail where EmployeeID = @UniqueID)
	return(1)
return(0)
end

go

create table Login
(
	UserName varchar(25) not null,
	Password varchar(25) not null,
	Category varchar(25) not null,
	UniqueID varchar(25) not null,
	constraint LUniqueLoginID primary key (UserName),
	constraint LUniqueUniqueID unique (UniqueID),
	constraint LCheckUniqueID check (dbo.CheckUniqueID(UniqueID, Category) = 1)
)

go

create table ForgotPassword
(
	Question varchar(200) not null,
	Answer varchar(100) not null,
	UserName varchar(25) not null,
	constraint FPUniqueLoginID primary key(UserName),
	constraint FPCheckLoginID foreign key (UserName) references Login(UserName)
)

go

insert into Administration.Department (Name, Type) values ('Administrator', 'Management')
insert into Employee.PersonalDetail (EmployeeID, Name, FatherName, MotherName, Address, DateOfBirth, Gender, ContactNo, EMailID, Photo) values ('ADMIN001', 'null', 'null', 'null', 'null', GETDATE(), 'Male', null, null, null)
insert into Employee.DepartmentDetail values ('ADMIN001', 1, 'Head Of Department')
insert into Login values ('admin', 'admin', 'Administrator', 'ADMIN001')

