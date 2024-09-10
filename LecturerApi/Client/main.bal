import ballerina/http;
import ballerina/io;

 public type Lecturer record {

    string staff_number?;
    
    string office_number?;

    string staff_name?;
    
    string title?;
   
    string []courses_taken?;
};

public function main() returns error? {
http:Client cli = check new ("localhost:9090/Lecturers");

     io:println("1.  Add a new lecturer");
    io:println("2.  Retrieve a list of all lecturers within the faculty");
    io:println("3.  Update an existing lecturer's information");
    io:println("4.  Retrieve the details of a specific lecturer by their staff number.");
    io:println("5.  Delete a lecturer's record by their staff number");
    io:println("6. Retrieve all the lecturers that sit in the same office.");
    string selection = io:readln("Choose an option from(1-6): ");
    
    match selection {
         
        "1" => {
            Lecturer lect = {};
            lect.staff_name = io:readln("Enter name of the lecturer to be added: ");
            lect.staff_number = io:readln("Enter "+<string>lect.staff_name+" 's staff number: ");
            lect.title=io:readln("Enter "+<string>lect.staff_name+" 's title: ");
            lect.office_number=io:readln("Enter "+<string>lect.staff_name+" 's office number: ");
            string courseName = addCourses();
            lect.courses_taken = [courseName];
            check createLect(cli, lect);
        }
        "3" => {
            Lecturer lect = {};
            lect.staff_name = io:readln("Enter name of the lecturer to be updated: ");
            lect.staff_number = io:readln("Enter "+<string>lect.staff_name+" 's  staff number: ");
            lect.title=io:readln("Enter "+<string>lect.staff_name+" 's new title: ");
            lect.office_number=io:readln("Enter "+<string>lect.staff_name+" 's new office number: ");
            string courseName = addCourses();
            lect.courses_taken = [courseName];
            check updateLecturer(cli, lect);
        }
        "5" => {
            string staffno = io:readln("Enter Staff Number for record to be deleted: ");
            check deleteID(cli, staffno);
        }
        "2" => {
            check getAllLect(cli);
        }
        "6" => {
            string officeno = io:readln("Enter Office number: ");
            check getByOffice(cli, officeno);
        }
        "4" => {
            string staffno = io:readln("Enter Staff Number");
            check getByID(cli, staffno);
        }
        _ => {
            io:println("Invalid Key");
            check main();
        }
    }
}
public function addCourses() returns string {
    string course_name = io:readln("Enter Course Taken: ");
    return course_name;
}

public function createLect(http:Client http, Lecturer lect) returns error? {
    if (http is http:Client) {
        string resp = check http->/addlecturer.post(lect);
        io:println(resp);
        string exitSys = io:readln("Press 0 to go back");

        if (exitSys === "0") {
            error? rerun = main();
            if rerun is error {
                io:println("Error, You can't go back to options page.");
            }
        }
    }
}

public function updateLecturer(http:Client http, Lecturer updt) returns error? {
    // var create = check http.post("/createCourse", course);
     if (http is http:Client) {
        string resp = check http->/addlecturer.put(updt);
        io:println(resp);
        string exitSys = io:readln("Press 0 to go back");

        if (exitSys === "0") {
            error? rerun = main();
            if rerun is error {
                io:println("Error, You can't go back to options page.");
            }
        }
    }
    io:println(updt);
}
public function deleteID(http:Client http, string staffno) returns error? {
    if (http is http:Client) {
        string message = check http->/remove_lecturer.delete(staffnos=staffno);
        io:println(message);
        io:println("--------------------------");
        string exitSys = io:readln("Press 0 to go back");
        if (exitSys == "0") {
            error? rerun = main();
            if rerun is error {
                io:println("Error, You can't go back.");
            }
        }
    }
}
public function getAllLect(http:Client http) returns error? {
    if (http is http:Client) {
        Lecturer[] lect = check http->/all_lecturers;
        foreach Lecturer lc in lect {
            io:println("--------------------------");
            io:println("Staff Number: ", lc.staff_number);
            io:println("Staff Name: ", lc.staff_name);
            io:println("Title: ", lc.title);
            io:println("Office Number: ", lc.office_number);
            io:println("Courses Taken: ", lc.courses_taken);
        }

        io:println("--------------------------");
        string exitSys = io:readln("Press 0 to go back");

        if (exitSys == "0") {
            error? rerun = main();
            if rerun is error {
                io:println("Error, You can't go back.");
            }
        }
    }
}

public function getByOffice(http:Client http, string officeno) returns error? {
    if (http is http:Client) {
        Lecturer lc = check http->/lecturer_office(office_number = officeno);
            io:println("--------------------------");
            io:println("Staff Number: ", lc.staff_number);
            io:println("Staff Name: ", lc.staff_name);
            io:println("Title: ", lc.title);
            io:println("Office Number: ", lc.office_number);
            io:println("Courses Taken: ", lc.courses_taken);
        
        io:println("--------------------------");
        string exitSys = io:readln("Press 0 to go back");

        if (exitSys == "0") {
            error? rerun = main();
            if rerun is error {
                io:println("Error, You can't go back.");
            }
        }
    }
}

public function getByID(http:Client http, string staffno) returns error? {
    if (http is http:Client) {
        Lecturer lect = check http->/lecturerId(staffno = staffno);
        io:println("--------------------------");
        io:println("Lecturer Name: ", lect.staff_name);
        io:println("Staff Number: ", lect.staff_number);
        io:println("Title: ", lect.title);
        io:println("Office Number: ", lect.office_number);
        io:println("Courses taken: ", lect.courses_taken);

        io:println("--------------------------");
        string exitSys = io:readln("Press 0 to go back");

        if (exitSys == "0") {
            error? rerun = main();
            if rerun is error {
                io:println("Error, You can't go back.");
            }
        }
    }
    //jojo
}