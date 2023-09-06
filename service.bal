import ballerina/http;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerina/time;

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

type ErrorDetails record {
    string message;
    string details;
    time:Utc timeStamp;
};

final mysql:Client db = check new (
    host = "first-instance.cg4vktva35w7.eu-north-1.rds.amazonaws.com",
    user = "learning", password = "learning-db",
    port = 3306,
    database = "bal_db"
);

isolated service /api on new http:Listener(9090) {
    resource isolated function post staff(Staff staff) returns http:Created|error
    {
        _ = check db->execute(`INSERT INTO Staff(staffNumber, officeNumber, staffName, title)
             VALUES (${staff.staffNumber}, ${staff.officeNumber}, ${staff.staffName}, ${staff.title})`);
        return http:CREATED;
    }
    resource isolated function post office(Office office) returns http:Created|error
    {
        _ = check db->execute(`INSERT INTO Office(officeNumber, location, capacity)
             VALUES (${office.officeNumber}, ${office.location}, ${office.capacity})`);

        return http:CREATED;
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

}

