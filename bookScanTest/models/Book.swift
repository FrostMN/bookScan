//
//  Book.swift
//  bookScanTest
//
//  Created by Aaron Souer on 11/15/17.
//  Copyright © 2017 Aaron Souer. All rights reserved.
//

import Foundation

class Book {
    let title, isbn10, isbn13,
    author_first_name, author_last_name: String
    let bookId: Int
    init(bookTitle Title:String, isbn10 ISBN10:String, isbn13 ISBN13:String,
         authorFirstName first:String, authorLastName last:String, bookID id:Int=1) {
        self.title = Title
        self.isbn10 = ISBN10
        self.isbn13 = ISBN13
        self.author_first_name = first
        self.author_last_name = last
        self.bookId = id
    }

    init(bookInfoArray BookInfo:[String]) {
        self.title = BookInfo[0]
        self.isbn10 = BookInfo[1]
        self.isbn13 = BookInfo[2]
        self.author_first_name = BookInfo[3]
        self.author_last_name = BookInfo[4]
        self.bookId = Int(BookInfo[5])!
    }

}
