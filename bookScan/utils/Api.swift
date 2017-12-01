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
    
    static func searchBooksTest (ISBN isbn: String) -> Array<Book> {
        let books = [getNewBook(ISBN: isbn, bookID: 1),
                     getNewBook(ISBN: isbn, bookID: 2),
                     getNewBook(ISBN: isbn, bookID: 3),
                     getNewBook(ISBN: isbn, bookID: 4)]
        return books
    }
    
    static func queryISBN (ISBN isbn: String, URL url: String, API key: String ) {
        print("in queryISBN")
        isbnInDB(ISBN: isbn, URL: url, API: key)
    }
    
    static func isbnInDB(ISBN isbn:String, URL url:String, API key: String) {
        // prepares the url from the login screen to be used in the api call
        // TODO better validation and formatting of the string
        let urlString = "https://\(url)/api/v1/\(key)/exists/\(isbn)"
        let ur = url
        
        print(urlString)
        
        // creates urlsession and request
        let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // does http request
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                print("in let data guard")
                print("connection failure is one option why wh get here")
                return
            }
            guard let isbnExists = try? JSONSerialization.jsonObject(with: data, options: []) as! [String:Any?]
                else {
                    print("in let json guard of isbnInDB")
                    
                    return
            }
            
            if isbnExists["isbnExists"]!! as! Bool {
                print("it exists")
                
    
                
            } else {
                print("it dosent exist")
                addBook(ISBN: isbn, URL: ur, API: key)
            }
            
        })
        task.resume()
    }
    
    static func searchBooks( ISBN isbn: String, action act:() ) {
        
    }
    
    static func addBook( ISBN isbn: String, URL url: String, API key: String ) {
        // create url string for request
        let urlString = "https://\(url)/api/get/\(key)/\(isbn)"
        print("in addBook()")
        print(urlString)
        
        // creates urlsession and request
        let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                print("in let data guard")
                print("connection failure is one option why wh get here")
                return
            }
            guard let bookJson = try? JSONSerialization.jsonObject(with: data, options: []) as! [String:Any?]
                else {
                    print("in let json guard of isbnInDB")
                    
                    return
            }
            
            print(bookJson["title"]!!)
            
        })
        task.resume()
        
        
    }
    
    
    
    
    
}
