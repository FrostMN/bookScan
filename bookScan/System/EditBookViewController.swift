//
//  EditBookViewController.swift
//  bookScanTest
//
//  Created by Aaron Souer on 11/20/17.
//  Copyright © 2017 Aaron Souer. All rights reserved.
//

import UIKit

class EditBookViewController: UIViewController {
    
    //the defaultvalues to access user data
    let defaultValues = UserDefaults.standard

    var book: Book!
    
    var user_api_key = ""
    var pyBookURL = ""

    @IBOutlet weak var bookTitleField: UITextField!
    @IBOutlet weak var isbnTenField: UITextField!
    @IBOutlet weak var isbnThirteenField: UITextField!
    @IBOutlet weak var authorFirstNameField: UITextField!
    @IBOutlet weak var authorLastNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //load valeues from defaults
        pyBookURL = defaultValues.string(forKey: "url")!
        user_api_key = defaultValues.string(forKey: "api")!

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // unhides nav bar for this view
        self.navigationController?.isNavigationBarHidden = false
        
        
        
        bookTitleField.text = book.title
        isbnTenField.text = book.isbn10
        isbnThirteenField.text = book.isbn13
        authorFirstNameField.text = book.author_first_name
        authorLastNameField.text = book.author_last_name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        
        let bookTitleStr = book.title
        let isbn10Str = book.isbn10
        let isbn13Str = book.isbn13
        let authorFNameStr = book.author_first_name
        let authorLNameStr = book.author_last_name
        
        let requestData = "{ \"title\": \"\(bookTitleStr)\", \"isbn_ten\": \"\(isbn10Str)\", \"isbn_thr\": \"\(isbn13Str)\", \"author_fname\": \"\(authorFNameStr)\", \"author_lname\": \"\(authorLNameStr)\" }"
        
        addBook(postData: requestData, API: user_api_key, pyBookURL: pyBookURL)
        
        //switching the screen back to the scanner
        let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! TabBarController
        self.navigationController?.pushViewController(profileViewController, animated: true)
        self.dismiss(animated: false, completion: nil)
        
    }
    
    func addBook(postData post: String, API key: String, pyBookURL url: String) {
        // prepares the url from the login screen to be used in the api call
        // TODO better validation and formatting of the string
        let urlString = "https://\(url)/api/v1/\(key)/add"
        
        // creates urlsession and request
        let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postString = post
        request.httpBody = postString.data(using: .utf8)
        
        
        // does http request
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard data != nil else {
                print("in let data guard")
                print("connection failure is one option why wh get here")
                return
            }
        })
        task.resume()
    }

    
}
