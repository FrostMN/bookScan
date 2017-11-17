//
//  Api.swift
//  bookScanTest
//
//  Created by Aaron Souer on 11/15/17.
//  Copyright © 2017 Aaron Souer. All rights reserved.
//

import Foundation

class Api {
    
    static func getNewBook(ISBN isbn:String, bookID id:Int = 1) -> Book {
        // just returns test book right now
        // neds to be implemented
        let newBook = Book(bookTitle: "The Book of Book", isbn10: "1234567890", isbn13: "1234567890123",
                           authorFirstName: "Joe", authorLastName: "Everybody", bookID: id)
        return newBook
    }
    
    static func bookExists(ISBN isbn:String) -> Bool {
        // need to acually query the API
        let testISBN10 = "1234567890"
        let testISBN13 = "1234567890123"
        if ((isbn == testISBN10) || (isbn == testISBN13)) {
            return true
        } else {
            return false
        }
    }
    
    static func searchBooks (ISBN isbn: String) -> Array<Book> {
        let books = [getNewBook(ISBN: isbn, bookID: 1),
                     getNewBook(ISBN: isbn, bookID: 2),
                     getNewBook(ISBN: isbn, bookID: 3),
                     getNewBook(ISBN: isbn, bookID: 4)]
        return books
    }
    
    static func queryUser (userName user:String, password pword: String, pyBookURL url: String) -> [String: String] {
        let urlString = "https://\(url)/api/v1/login"
        print(urlString)
        let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postString = "{ \"user\": \"\(user)\", \"password\": \"\(pword)\" }"
        request.httpBody = postString.data(using: .utf8)
        
        var test = [String: Any]()
        
        
//        let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                print("in let data guard")
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
                print("in let json guard")
                return
            }
            print("in completed request")
            print(json)
            test = json as! [String:String]
            print("test in task")
            print(test)
        })
        
        
        task.resume()
        print("test")
        print(test)
        let user = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]
        print(user)
        return user
    }


    static func testURL (pyBookURL url: String) {
        let url = NSURL(string: "https://\(url)")
        let data = NSData(contentsOf: url! as URL)
        do {
            let json = try JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
            print(json)
            for gym in json as! [AnyObject] {
                print(gym)
            }
        } catch {
            print("Error")
        }
    }
}
