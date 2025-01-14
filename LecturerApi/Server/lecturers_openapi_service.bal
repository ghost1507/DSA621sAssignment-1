// AUTO-GENERATED FILE.
// This file is auto-generated by the Ballerina OpenAPI tool.

import ballerina/io;
import ballerina/http;

listener http:Listener ep0 = new (9090, config = {host: "localhost"});

service / Lecturers on ep0 {
    # Insert a new lecturer
    #
    # + payload - parameter description 
    # + return - Lecturer record successfully created 
    resource function post addlecturer(@http:Payload Lecturer payload) returns string {
        io:println(payload);
        error? err = lecturer.add(payload);
         if (err is error) {
            return string `Error, ${err.message()}`;
        }
        return string `${payload.staff_name} 's record saved successfully`;
    }
    # Update an existing lecturer
    #
    # + payload - parameter description 
    # + return - Lecturer record successfully updated 
    resource function post update_lecturer(@http:Payload Lecturer payload) returns string {
        io:println(payload);
        error? err = lecturer.put(payload);
        if (err is error) {
            return string `Error, ${err.message()}`;
        }
        return string `${payload.staff_name} 's record updated successfully`;
    }
    # Retrieve a lecturer record
    #
    # + staffno - Staff number of Lecturer to be Retrieved. 
    # + return - Ok 
    resource function get lecturerId(string staffno) returns Lecturer|string {

     foreach Lecturer lect in lecturer {
            if (lect.staff_number === staffno) {
                return lect;
            }
            else {
                
            }
        }

        return "Staff number "+staffno+" is invalid";

    }
    # Retrieve's lecturers records
    #
    # + return - Ok 
    resource function get all_lecturers() returns table<Lecturer> key(staff_number) {
        return lecturer;  
    }
    # Delete a Lecturer
    #
    # + staffno - Staff number of the lecturer record to be deleted. 
    # + return - Ok 
    resource function delete remove_lecturer(string staffno) returns string {
        _=lecturer.remove(staffno);
        return "Staff Number: "+staffno+" successfully removed ";
    }
    # Retrieve a lecturer by office number.
    #
    # + office_number - Office number of the lecturers to be retrieved. 
    # + return - Ok 
    resource function get lecturer_office(string office_number) returns Lecturer|string {
             foreach Lecturer staff in lecturer {
    if(staff.office_number==office_number){
        return staff;
    }
  }  
  return "Invalid Office number";
    }
}
