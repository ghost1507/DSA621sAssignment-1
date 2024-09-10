import ballerina/io;
import ballerina/graphql;

 
public type DOResponse record {|
    record {|anydata dt;|} data;
|};  

public type UserResp record {|
    record {|anydata dt;|} data;
|};

public type KPIResp record {|
    record {|anydata dt;|} data;
|};

public type deleteResp record {|
    record {|anydata dt;|} data;
|};

public type gradekpiResp record {|
    record {|anydata dt;|} data;
|};

public type gradeSupervisor record {|
    record {|anydata dt;|} data;
|};

public type UserDetails record {
string userId?;
    string firstName?;
    string lastName?;
    string role?; 
     string username?;
    string password?;

};

public type PerformanceScore record {
    string userId?;
    string departmentId?;
    string kpiId?;
    string KPIdescription?;

};

public type DepartmentObjectives record {
    string departmentId?;
    string description?;
    
    
};



type UpdatedUserDetails record {
    string username?;
    string password?;
};

type EmpKPI record {
    string userId?;
    string KPIdescription?;
    string EmployeeKPIScore?;
    

}; 

public type gradeSup record {
    string userId?;
    string SupScore?;

};

public function main() returns error? {
    
graphql:Client graphQlclient = check new ("localhost:9090");

io:println("_______________________________________________________________________________");
io:println("----------------Performance Management System-----------------------");
io:println("_______________________________________________________________________________");



    

    io:println("1.Register");
    io:println("2. Create department objectives(HOD)");
    io:println("3.  Create  KPI(Employee)");
    io:println("4. Update employee KPI(Supervisor)");
    io:println("5. Delete employee KPI(Supervisor)");
    io:println("6. Delete Department Objective(HOD)");
    io:println("7. Grade Employee KPI(Supervisor)");
    io:println("8. Grade your Supervisor(Employee)");
    string selection = io:readln("Choose an option from(1-8): ");
io:println("_______________________________________________________________________________");
  
    
    match selection {
         
        "1" => {
            UserDetails user = {};
           
           string _ = io:readln("Please fill in the following information->Press enter to continue");

          _ = check createUser(graphQlclient, user);
        }
        "3" => {

        PerformanceScore kpi ={};
           string _ = io:readln("Please fill in the following information->Press enter to continue"); 
           _= check createKPI(graphQlclient, kpi);
        }
        // "4" => {
        //     KPIDetails kpi = {description: "", userId: ""};
        //     kpi.userId = io:readln("Enter userId of the employees KPI to be updated: ");
        //     kpi.description = io:readln("Enter the updated description: ");
        //     check UpdateKPI(cli, kpi);
        //}
        "2" => {
           DepartmentObjectives DO = {};
        
           string _ = io:readln("Please fill in the following information->Press enter to continue");
            _ = check createDO(graphQlclient, DO);
        }
        "6" => {
             
              string _ = io:readln("Please fill in the following information->Press enter to continue"); 
               string departmentIds = io:readln("Enter department objective id of the objective to be deleted:");
            check deleteDO(graphQlclient, departmentIds);
        }

         "7" => {

        EmpKPI kpiScore ={};
           string _ = io:readln("Please fill in the following information->Press enter to continue"); 
           _= check gradeEMPKPI(graphQlclient, kpiScore);
        }

         "8" => {

        gradeSup SupScore ={};
           string _ = io:readln("Please fill in the following information->Press enter to continue"); 
           _= check creategradeSup(graphQlclient, SupScore);
        }
        // "5" => {
        //    string employeeKPI = io:readln("Enter userId for employee kpi to be deleted: ");
        //     check deleteEmp(cli, employeeKPI);
        // }
//         _ => {
//             io:println("Invalid Key");
//             check main();
//         }
//     }
// }
}
}
public function createUser(graphql:Client graphql, UserDetails ud) returns error? {
     graphql:Client graphQlclient = check new ("localhost:9090");
   
    string doc  = string `
    
     mutation addUser($userId:String!, $firstName:String!, $lastName:String!, $role:String!,$username:String!, $password:String!){
           addUser(n1:{userId: $userId, firstName:
    $firstName, lastName: $lastName, role: $role, username:$username, password:$password})
        }
       

    `;
    

  string userId = io:readln("Please enter userID:");
    string firstName = io:readln("Please enter first name:");
    string lastName = io:readln("Please enter last name:");
    string role = io:readln("Please enter role/position:");
    string username = io:readln("Enter desired username(Must be the combination of your firstname(s) and ID eg tashi1): ");
    string password = io:readln("Please enter password to be used for Authentication(Must be 8 characters or longer): ");
    
    UserResp resp = check graphQlclient->execute(doc, {"userId":userId, "firstName":firstName, "lastName":lastName, "role":role,"username":username, "password":password});
   
    io:println(resp);
  
        string exitSys = io:readln("Press 0 to go back");

        if (exitSys === "0") {
            error? rerun = main();
            if rerun is error {
                io:println("Error, You can't go back to options page.");
            }
        }
    }


public function createDO(graphql:Client graphql, DepartmentObjectives DO) returns error? {
     graphql:Client graphQlclient = check new ("localhost:9090");
   
    string doc  = string `
    
     mutation addDepartmentObjective($departmentId:String!, $description:String!){
           addDepartmentObjective(newdepartmentObjective:{departmentId: $departmentId, description:
    $description})
        }
       

    `;
  string departmentId = io:readln("Enter departmentId:");
    string description = io:readln("Enter department description:");
        DOResponse resp = check graphQlclient->execute(doc, {"departmentId":departmentId, "description":description});
    io:println(resp);
        string exitSys = io:readln("Press 0 to go back");

        if (exitSys === "0") {
            error? rerun = main();
            if rerun is error {
                io:println("Error, You can't go back to options page.");
            }
        }
    }

public function createKPI(graphql:Client graphql, PerformanceScore KPI) returns error? {
     graphql:Client graphQlclient = check new ("localhost:9090");
   
    string doc  = string `
    
     mutation addPerformanceScore($userId:String!, $departmentId:String!, $kpiId:String!, $KPIdescription:String!){
           addPerformanceScore(performanceScore:{userId: $userId, departmentId:
    $departmentId, kpiId: $kpiId, KPIdescription: $KPIdescription})
        }
       

    `;
  string userId = io:readln("Please enter userId for employees KPI to be created :");
    string departmentId = io:readln("Please enter department objective ID:");
    string kpiId = io:readln("Please enter KPI ID:");
    string KPIdescription = io:readln("Please enter KPI description:");
        KPIResp resp = check graphQlclient->execute(doc, {"userId":userId, "departmentId":departmentId, "kpiId":kpiId, "KPIdescription":KPIdescription});
    io:println(resp);
        string exitSys = io:readln("Press 0 to go back");

        if (exitSys === "0") {
            error? rerun = main();
            if rerun is error {
                io:println("Error, You can't go back to options page.");
            }
        }
        
    }
    

public function deleteDO(graphql:Client graphql, string departmentId ) returns error? {
     graphql:Client graphQlclient = check new ("localhost:9090");
   

     string doc = string `
        mutation deleteDepartmentObjective($departmentId: String!) {
            deleteDepartmentObjective(departmentId: $departmentId)
        }
    `;

 
       deleteResp resp = check graphQlclient->execute(doc, {"departmentId":departmentId});
    io:println(resp);
        string exitSys = io:readln("Press 0 to go back");

        if (exitSys === "0") {
            error? rerun = main();
            if rerun is error {
                io:println("Error, You can't go back to options page.");
            }
        }
    }


    public function gradeEMPKPI(graphql:Client graphql, PerformanceScore KPI) returns error? {
     graphql:Client graphQlclient = check new ("localhost:9090");
   
    string doc  = string `
    
     mutation addEmpKPI($userId:String!, $KPIdescription:String!, $EmployeeKPIScore:String!){
           addEmpKPI(newEmpKPI:{userId: $userId, KPIdescription: $KPIdescription, EmployeeKPIScore: $EmployeeKPIScore})
        }
       

    `;
  string userId = io:readln("Please enter userId for employees KPI to be graded :");
    string KPIdescription = io:readln("Please enter the description of the KPI:");
    string EmployeeKPIScore = io:readln("Please enter the employees KPI score:");
    
        gradekpiResp resp = check graphQlclient->execute(doc, {"userId":userId, "KPIdescription":KPIdescription, "EmployeeKPIScore":EmployeeKPIScore});
    io:println(resp);
        string exitSys = io:readln("Press 0 to go back");

        if (exitSys === "0") {
            error? rerun = main();
            if rerun is error {
                io:println("Error, You can't go back to options page.");
            }
        }
        
    }


    public function creategradeSup(graphql:Client graphql, gradeSup SupScore ) returns error? {
     graphql:Client graphQlclient = check new ("localhost:9090");
   
    string doc  = string `
    
     mutation gradeSup($userId:String!, $SupervisorScore:String!){
           gradeSup(newgradeSup:{userId: $userId, SupervisorScore: $SupervisorScore})
        }
       
++
    `;
  string userId = io:readln("Please enter userId for your assigned Supervisor :");
    string SupervisorScore = io:readln("Please grade your supervisor:");
    
    
       gradeSupervisor resp = check graphQlclient->execute(doc, {"userId":userId, "SupervisorScore":SupervisorScore});
    io:println(resp);
        string exitSys = io:readln("Press 0 to go back");

        if (exitSys === "0") {
            error? rerun = main();
            if rerun is error {
                io:println("Error, You can't go back to options page.");
            }
        }
        
    }
 

