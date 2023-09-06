import ballerina/http;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;

type Office record
{
    string officeNumber;
    string location;
    int capacity;
};

type Staff record
{
    string staffNumber;
    string officeNumber;
    string staffName;
    string title;
};

type Courses record
{
    string courseCode;
    string courseName;
    int NQFLevel;
};

type LecturerCourse record
{
    string staffNumber;
    string courseCode;
};

final mysql:Client db = check new (
    host = "first-instance.cg4vktva35w7.eu-north-1.rds.amazonaws.com",
    user = "learning", password = "learning-db",
    port = 3306,
    database = "bal_db"
);

isolated service /api on new http:Listener(9090) {
    resource isolated function post staff(Staff staff) returns Staff|error
    {
        do
        {
            _ = check db->execute(`INSERT INTO Staff(staffNumber, officeNumber, staffName, title)
             VALUES (${staff.staffNumber}, ${staff.officeNumber}, ${staff.staffName}, ${staff.title})`);
        }
        on fail var e {
            return error(e.message());
        }
        return staff;
    }

    resource isolated function post office(Office office) returns Office|error
    {
        do
        {
            _ = check db->execute(`INSERT INTO Office(officeNumber, location, capacity)
             VALUES (${office.officeNumber}, ${office.location}, ${office.capacity})`);
        }
        on fail var e {
            return error(e.message());
        }
        return office;
    }

    resource isolated function post course(Courses course) returns Courses|error
    {
        do
        {
            _ = check db->execute(`INSERT INTO Courses(courseCode, courseName, NQFLevel)
            VALUES (${course.courseCode}, ${course.courseName}, ${course.NQFLevel})`);
        }
        on fail var e
        {
            return error(e.message());
        }
        return course;
    }

    resource isolated function post courselecture(LecturerCourse lc) returns LecturerCourse|error
    {
        do
        {
            _ = check db->execute(`INSERT INTO Lecturer_Course(staffNumber, courseCode)
            VALUES (${lc.staffNumber}, ${lc.courseCode})`);
        }
        on fail var e
        {
            return error(e.message());
        }
        return lc;
    }

}

