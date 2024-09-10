import ballerina/io;

LibraryServiceClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    Book addBookRequest = {isbn: "ballerina", title: "ballerina", author_1: "ballerina", author_2: "ballerina", location: "ballerina", status: "ballerina"};
    Response addBookResponse = check ep->addBook(addBookRequest);
    io:println(addBookResponse);

    Book ad = {isbn: "2554647838", title: "Psychology Facts", author_1: "RASHEEDA", author_2: "Jojo", location: "Aisle 2", status: "Available"};
    Response adresp= check ep->addBook(ad);
    io:println(adresp);

    User createUsersRequest = {user_id: "ballerina", username: "ballerina"};
    Response createUsersResponse = check ep->createUsers(createUsersRequest);
    io:println(createUsersResponse);
    

    Book updateBookRequest = {isbn: "ballerina", title: "ballerina", author_1: "ballerina", author_2: "ballerina", location: "ballerina", status: "ballerina"};
    Response updateBookResponse = check ep->updateBook(updateBookRequest);
    io:println(updateBookResponse);

    string removeBookRequest = "ballerina";
    Response removeBookResponse = check ep->removeBook(removeBookRequest);
    io:println(removeBookResponse);

    BorrowRequest borrowBookRequest = {user_id: "ballerina", isbn: "ballerina"};
    Response borrowBookResponse = check ep->borrowBook(borrowBookRequest);
    io:println(borrowBookResponse);
    stream<

    Book, error?> listAvailableBooksResponse = check ep->listAvailableBooks();
    check listAvailableBooksResponse.forEach(function(Book value) {
        io:println(value);
    });

   string locateBookRequest = "2554647838";
   Book locateBookResponse = check ep->locateBook(locateBookRequest);
   io:println(locateBookResponse);


}

