import ballerinax/mongodb;
import ballerina/graphql;
import ballerina/log;
import ballerina/io;


mongodb:ConnectionConfig mongoConfig = {
    connection: {
        host: "localhost",
        port: 27017,
        auth: {
            username: "",
            password: ""
        },
        options: {
            sslEnabled: false, 
            serverSelectionTimeout: 5000
        }
    },
    databaseName: "performance_db"
};
mongodb:Client mongoClient = check new (mongoConfig);

configurable string userCollection = "users";
configurable string deptObjcollection = "department_objectives";
configurable string perfScoresCollection = "performance_scores";
configurable string supEmpRelcollection = "supervisor_employee_relationship";
configurable string loginCollection = "Login";
configurable string databaseName = "performance_db";

type User record {
string userId;
    string firstName;
    string lastName;
    string role; 
     string username;
    string password;
};

type DepartmentObjective record {
    string departmentId;
    string description;
    
    
};


type UpdatedKpiDetails record {
    string userId;
    string description;
    string unit;
};

type PerformanceScore record {
    string userId;
    string departmentId;
    string kpiId;
    string KPIdescription;
    

}; 

type EmpKPI record {
    string userId;
    string KPIdescription;
    string EmployeeKPIScore;
    

}; 

type gradeSup record {
    string userId;
    string SupervisorScore;

}; 

type SupervisorEmployeeRelationship record {
    string supervisorId;
    string employeeId;
    
};



type UpdatedUserDetails record {
    string username;
    string password;
};

@graphql:ServiceConfig {
    graphiql: {
        enabled: true
        // Path is optional, if not provided, it will be dafulted to `/graphiql`.
        // path: "/testing"
    }
}

service / on new graphql:Listener(9090) {
//  remote function register(UserDetails newuser) returns error|string {

//         map<json> doc = <map<json>>{username: newuser.username, password: newuser.password};
//         _ = check mongoClient->insert(doc, loginCollection, "");
//         return string `${newuser.username} added successfully`;
//     }
// resource function get login(User user) returns User|error? {
//         stream<User, error?> usersDetails = check mongoClient->find(loginCollection, databaseName, {username: user.username, password: user.password}, {});

//         User[] users = check from var userInfo in usersDetails
//             select userInfo;
//         io:println("Users ", users);
//         // If the user is found return a user or return a string user not found
//         if users.length() > 0 {
//             return {username: users[0].username, role: users[0].role};
//         }
//         return {
//             username: "",
//             isAdmin: false
//         };
//     }
//     }

remote function changePassword(UpdatedUserDetails updatedUser) returns error|string {

        map<json> newPasswordDoc = <map<json>>{"$set": {"password": updatedUser.password}};

        int updatedCount = check mongoClient->update(newPasswordDoc, loginCollection, databaseName, {username: updatedUser.username}, true, false);
        io:println("Updated Count ", updatedCount);

        if updatedCount > 0 {
            return string `${updatedUser.username} password changed successfully`;
        }
        return "Failed to update credentials";
    }    



remote function addUser(User n1) returns string|error {
       map<json> doc =<map<json>>n1.toJson();
       _= check mongoClient->insert(doc, "userCollection", "");
      return string`${n1.firstName} added successfully`;

    }

    remote function addEmpKPI(EmpKPI newEmpKPI) returns string|error {
       map<json> doc =<map<json>>newEmpKPI.toJson();
       _= check mongoClient->insert(doc, "perfScoresCollection", "");
      return string`${newEmpKPI.userId} added successfully`;

    }

    remote function gradeSup(gradeSup newgradeSup) returns string|error {
       map<json> doc =<map<json>>newgradeSup.toJson();
       _= check mongoClient->insert(doc, "perfScoresCollection", "");
      return string`${newgradeSup.userId} added successfully`;

    }

remote function  addDepartmentObjective(DepartmentObjective newdepartmentObjective) returns string|error {
    map<json> doc =<map<json>>newdepartmentObjective.toJson();
       _= check mongoClient->insert(doc, "deptObjcollection", "");
      return string`${newdepartmentObjective.departmentId} added successfully`;
}



remote function addPerformanceScore(PerformanceScore performanceScore) returns string|error {
   map<json> doc =<map<json>>performanceScore.toJson();
       _= check mongoClient->insert(doc, "perfScoresCollection", "");
      return string`${performanceScore.kpiId} added successfully`;
}

remote function addSupervisorEmployeeRelationship(SupervisorEmployeeRelationship relationship) returns string|error {
    map<json> doc =<map<json>>relationship.toJson();
       _= check mongoClient->insert(doc, "supEmpRelcollection", "");
      return string`${relationship.employeeId} added successfully`;
}

resource function get getDepartmentObj() returns string|error {
    var allDOs = check mongoClient->find(deptObjcollection, "performance_db", {},{},{},-1,-1,[]);
   

log:printInfo(allDOs.toString());

return "Response from the server";
}


resource function get getKPI(string userId) returns string|error {
    var allKPIs = check mongoClient->find(deptObjcollection, "performance_db", {},{},{},-1,-1,[]);
    

log:printInfo(allKPIs.toString());

return "Response from the server";
}

resource function get getPerformanceScore(string kpiId) returns string|error {
    var allPSs = check mongoClient->find(deptObjcollection, "performance_db", {},{},{},-1,-1,[]);
    

log:printInfo(allPSs.toString());

return "Response from the server";
}

resource function get getSupervisorEmployeeRelationship(string supervisorId, string employeeId) returns string|error {
    var allSERs = check mongoClient->find(deptObjcollection, "performance_db", {},{},{},-1,-1,[]);
   

log:printInfo(allSERs.toString());

return "Response from the server";
}





// remote function updateKPI(UpdatedKpiDetails updatedKPI) returns string|error {
    
//     map<json> newKpiDoc = <map<json>>{"$set": {"description": updatedKPI.description}};

//     int updatedCount = check mongoClient->update(newKpiDoc, perfScoresCollection, "performance_db", {userId: updatedKPI.userId}, true, false);
//     io:println("Updated Count ", updatedCount);

//     if updatedCount > 0 {
//     return string `${updatedKPI.userId} KPI changed successfully`;
//      }
//        return "Failed to updated";


       
// }



remote function deleteDepartmentObjective(string departmentId) returns string|error {
   
       mongodb:Error|int deleteDO =  check mongoClient->delete(deptObjcollection, "performance_db",{departmentId: departmentId}, false);
       
       if deleteDO is mongodb:Error {
        return error ("Failed to delete items");
         
       }else {
        
        if deleteDO > 0{
         return string`${departmentId} deleted successfully`;

        }else {
            return string `Department objective not found `;

        }

       }
      
}

remote function deleteKPI(string kpiId) returns string|error {

    mongodb:Error|int deleteKPI =  check mongoClient->delete(perfScoresCollection, "",{kpiId: kpiId
    }, false);
       
       if deleteKPI is mongodb:Error {
        return error ("Failed to delete items");
         
       }else {
        
        if deleteKPI > 0{
         return string`${kpiId} deleted successfully`;

        }else {
            return string `KPI not found `;

        }

       }
}

remote function deletePerformanceScore(string kpiId) returns string|error {

mongodb:Error|int deletePS =  check mongoClient->delete(perfScoresCollection, "",{kpiId: kpiId
    }, false);
       
       if deletePS is mongodb:Error {
        return error ("Failed to delete items");
         
       }else {
        
        if deletePS > 0{
         return string`${kpiId} deleted successfully`;

        }else {
            return string `Performance score not found `;

        }

       }
}


remote function deleteSupervisorEmployeeRelationship(string supervisorId, string employeeId) returns string|error {
    mongodb:Error|int deleteSER =  check mongoClient->delete(perfScoresCollection, "",{supervisorId: supervisorId, employeeId: employeeId 
    }, false);
       
       if deleteSER is mongodb:Error {
        return error ("Failed to delete items");
         
       }else {
        
        if deleteSER > 0{
         return string`${supervisorId} deleted successfully`;

        }else {
            return string `Supervisor Employee Relationship not found `;

        }

       }

}

}












 
