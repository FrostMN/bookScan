//
//  ReturnBookViewController.swift
//  bookScanTest
//
//  Created by Aaron Souer on 11/20/17.
//  Copyright © 2017 Aaron Souer. All rights reserved.
//

import UIKit

class ReturnBookViewController: UIViewController {
    
    //the defaultvalues to access user data
    let defaultValues = UserDefaults.standard


    var book: Book? = nil
    var user_api_key = ""
    var pyBookURL = ""
    
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var lendeeNameLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        // loads info into labels
        bookTitleLabel.text = book?.title
        lendeeNameLabel.text = book?.location
        
        // unhides nav bar for this view
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        pyBookURL = defaultValues.string(forKey: "url")!
        user_api_key = defaultValues.string(forKey: "api")!

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func returnBookButton(_ sender: Any) {
        
        let bookID = String(describing: book!.bookId)
        let userID = String(1)
        
        returnBook(API: user_api_key, pyBookURL: pyBookURL, BookID: bookID, UserID: userID)
    }
    
    func returnBook(API key: String, pyBookURL url: String, BookID bookID: String, UserID userID: String ) {
        
        // prepares the url from the login screen to be used in the api call
        // TODO better validation and formatting of the string
        
        //need to chane url call
        let urlString = "https://\(url)/api/v1/\(key)/books/\(userID)"
        
        // creates urlsession and request
        let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        let putData = "{ \"action\": \"return\", \"bookID\": \"\(bookID)\", \"userID\": \"\(userID)\" }"
        
        request.httpBody = putData.data(using: .utf8)
        
        // does http request
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                print("in let data guard")
                print("connection failure is one option why whe get here")
                return
            }
            
            print(data)
            
            //return to the scanner screen
            let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! TabBarController
            self.navigationController?.pushViewController(profileViewController, animated: true)
            self.dismiss(animated: false, completion: nil)

        })
        task.resume()
    }

}
