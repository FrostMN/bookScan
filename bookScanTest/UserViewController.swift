//
//  UserViewController.swift
//  bookScanTest
//
//  Created by Aaron Souer on 11/14/17.
//  Copyright © 2017 Aaron Souer. All rights reserved.
//

import Foundation
import UIKit

class UserViewController: UIViewController {
    
    //the defaultvalues to access user data
    let defaultValues = UserDefaults.standard
    
    
    @IBOutlet weak var isbnField: UITextField!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!

    var url: String = ""
    var key: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("UserViewController viewDidLoad()")

        userLabel.text = defaultValues.string(forKey: "username")
        urlLabel.text = defaultValues.string(forKey: "url")

        url = defaultValues.string(forKey: "url")!
        key = defaultValues.string(forKey: "api")!
        
    }
        
    // TODO oncomment this when in production
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        isbnField.text = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func searchISBN(_ sender: UIButton) {
        print("In searchISBN")
        let ISBN = isbnField.text!
        
        
        print("ISBN form text field")
        print(ISBN)

        
        isbnInDB(ISBN: ISBN, URL: url, API: key)
    
    }
    
    @IBAction func logoutButton(_ sender: UIButton) {
        print("In logoutButton")
        
        //removing values from default
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
        //switching the screen
        let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(profileViewController, animated: true)
        self.dismiss(animated: false, completion: nil)

        
    }
    
    func isbnInDB(ISBN isbn:String, URL url:String, API key: String) {
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
                self.queryISBN(ISBN: isbn, URL: ur, API: key)
                
            } else {
                print("it dosent exist")
                self.addBook(ISBN: isbn, URL: ur, API: key)
            }
            
        })
        task.resume()
    }
    
    func addBook( ISBN isbn: String, URL url: String, API key: String ) {
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
            
            print(bookJson)
            print(bookJson["status"]!!)
            let status = bookJson["status"]!! as! Bool
            print(bookJson["title"]!!)
            let title = bookJson["title"]!! as! String
            print(bookJson["isbn_10"]!!)
            let isbn10 = bookJson["isbn_10"]!! as! String
            print(bookJson["isbn_13"]!!)
            let isbn13 = bookJson["isbn_13"]!! as! String
            print(bookJson["author"]!!)
            let author = bookJson["author"]!! as! String
            let author_fn = author.components(separatedBy: " ")[0]
            let author_ln = author.components(separatedBy: " ")[1]
            
            // create new book object to send to voew
            let newBook = Book(bookTitle: title, isbn10: isbn10, isbn13: isbn13, authorFirstName: author_fn, authorLastName: author_ln, bookStatus: status)

            //switching the screen
            let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "NewBookViewController") as! NewBookViewController
            profileViewController.book = newBook
            self.navigationController?.pushViewController(profileViewController, animated: true)
            self.dismiss(animated: false, completion: nil)
        })
        task.resume()
    }
    
    func queryISBN(ISBN isbn: String, URL url: String, API key: String ) {
        // create url string for request
        let urlString = "https://\(url)/api/v1/\(key)/books/\(isbn)"
        print("in queryISBN()")
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
            guard let booksJson = try? JSONSerialization.jsonObject(with: data, options: []) as! Array<[String:Any?]>
                else {
                    print("in let json guard of queryISBN")
                    
                    return
            }
            
            print(booksJson)
            
            var books = [Book]()
            
            for bk in booksJson {
                print("in f eeach")
                print(bk)
                let status = bk["status"]!! as! Bool
                let title = bk["title"]!! as! String
                let isbn10 = bk["isbn_10"]!! as! String
                let isbn13 = bk["isbn_13"]!! as! String
                let author = bk["author"]!! as! String
                let author_fn = author.components(separatedBy: " ")[0]
                let author_ln = author.components(separatedBy: " ")[1]
                let BookID = bk["id"]!! as! Int
                let location = bk["lendee"] as! String
                let book = Book(bookTitle: title, isbn10: isbn10, isbn13: isbn13, authorFirstName: author_fn, authorLastName: author_ln, bookID: BookID, bookStatus: status, bookLocation: location)
                books.append(book)
            }
            
            print(books)
            
            if books.count == 1 {
                //BookStatusViewController
                //switching the screen
                let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "BookStatusViewController") as! BookStatusViewController
                profileViewController.book = books[0]
                self.navigationController?.pushViewController(profileViewController, animated: true)
                self.dismiss(animated: false, completion: nil)
            } else {
            
                //switching the screen
                let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "BooksListViewController") as! BooksListViewController
                profileViewController.books = books
                self.navigationController?.pushViewController(profileViewController, animated: true)
                self.dismiss(animated: false, completion: nil)
            }
        })
        task.resume()
    }
    
}
