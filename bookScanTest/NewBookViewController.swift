//
//  NewBookViewController.swift
//  bookScanTest
//
//  Created by Aaron Souer on 11/15/17.
//  Copyright © 2017 Aaron Souer. All rights reserved.
//

import Foundation
import UIKit

class NewBookViewController: UIViewController {
    
    //the defaultvalues to access user data
    let defaultValues = UserDefaults.standard
    
    var book: Book!
    
    @IBOutlet weak var bookTitle: UITextField!
    @IBOutlet weak var isbn10Field: UITextField!
    @IBOutlet weak var isbn13Field: UITextField!
    @IBOutlet weak var authoFirstNameField: UITextField!
    @IBOutlet weak var authorLastNameField: UITextField!
    
    var url = ""
    var api = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //load valeues from defaults
        url = defaultValues.string(forKey: "url")!
        api = defaultValues.string(forKey: "api")!
        
        bookTitle.text = book.title
        isbn10Field.text = book.isbn10
        isbn13Field.text = book.isbn13
        authoFirstNameField.text = book.author_first_name
        authorLastNameField.text = book.author_last_name
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // unhides nav bar for this view
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func saveBookButton(_ sender: UIButton) {
        let bookTitleStr = bookTitle.text
        let isbn10Str = isbn10Field.text
        let isbn13Str = isbn13Field.text
        let authorFNameStr = authoFirstNameField.text
        let authorLNameStr = authorLastNameField.text

        let requestData = "{ \"title\": \"\(bookTitleStr!)\", \"isbn_ten\": \"\(isbn10Str!)\", \"isbn_thr\": \"\(isbn13Str!)\", \"author_fname\": \"\(authorFNameStr!)\", \"author_lname\": \"\(authorLNameStr!)\" }"

        
        // prolly can delete
//        print(requestData)
//        print(api)
//        print(url)
        
        addBook(postData: requestData, API: api, pyBookURL: url)
        
        //switching the screen back to the scanner
        let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! TabBarController
        self.navigationController?.pushViewController(profileViewController, animated: true)
        self.dismiss(animated: false, completion: nil)

    }
    
    func addBook(postData post: String, API key: String, pyBookURL url: String) {
        // prepares the url from the login screen to be used in the api call
        // TODO better validation and formatting of the string
        let urlString = "https://\(url)/api/v1/\(key)/add"
        
        // prolly can delete
//        print(urlString)
        
        // creates urlsession and request
        let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postString = post
        request.httpBody = postString.data(using: .utf8)
        
        
        // does http request
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                print("in let data guard")
                print("connection failure is one option why wh get here")
                return
            }
            
            print(data)
        })
        task.resume()
    }
}
