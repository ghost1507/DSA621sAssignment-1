import ballerina/grpc;
table<Book> key(isbn) books = table [];
table<User> key(user_id) users = table [];
table<BorrowRequest> key(user_id) borrowing = table [];
listener grpc:Listener ep = new (9090);

@grpc:Descriptor {value: ASSIGNMENT_DESC}
service "LibraryService" on ep {

    remote function addBook(Book value) returns Response|error {
         error? addBook=books.add(value);
if addBook is error {
    return addBook;
}
else {
    return {resp:"Book successfully added"};
}
    }
    remote function createUsers(User value) returns Response|error {
         error? createuser=users.add(value);
if createuser is error {
    return createuser;
    }
    else {
    return {resp:"User successfully created"};
}
    }   
    remote function updateBook(Book value) returns Response|error {

        error? updBook=books.put(value);
if updBook is error {
    return updBook;
}
else {
    return {resp:"Book successfully updated"};
}
    }
    remote function removeBook(string value) returns Response|error {
        Book rmvBook=books.remove(value);
        return {
            resp: string`${rmvBook.title} successfully removed book`
        };
    }
    remote function locateBook(string value) returns error|string{
        Book lctBook=books.get(value);
        if (lctBook.isbn=="") {
            return error("Book requested not found");
        }
        else {
            return "Response from the server , Location is: "+lctBook.location;
        }
    }
    remote function borrowBook(BorrowRequest value) returns Response|error {
       error? brw=borrowing.add(value);

       if(brw is error){
        return brw;
      }
     
      else {
        return {resp: "Book Borrowing successful"};
      }
    }
    remote function listAvailableBooks() returns stream<Book, error?>|error|string {
        stream<Book, error?> bookStream = stream from var book in books.toArray() select book;
        return bookStream;
    }
}

