//
//  BookStatusViewController.swift
//  bookScanTest
//
//  Created by Aaron Souer on 11/19/17.
//  Copyright © 2017 Aaron Souer. All rights reserved.
//

import UIKit
import Foundation

class BookStatusViewController: UIViewController {
    
    //the defaultvalues to access user data
    let defaultValues = UserDefaults.standard
    
    // creates vars for this view
    var book: Book!
    var user_api_key = ""
    var pyBookURL = ""

    // creates oulets for this view
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var lendReturnButton: UIButton!
    @IBOutlet weak var newCopyButton: UIButton!
    
    // does some setup for view
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // unhides nav bar for this view
        self.navigationController?.isNavigationBarHidden = false

        // Sets text for button depending oon book status
        if book.status {
            lendReturnButton.setTitle("Return", for: .normal)
        } else {
            lendReturnButton.setTitle("Lend", for: .normal)
        }
        
        if defaultValues.bool(forKey: "fromBookView") {
            newCopyButton.isHidden = true
        } else {
            newCopyButton.isHidden = false
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // load tile of book into label
        bookTitleLabel.text = book.title

        //load valeues from defaults
        pyBookURL = defaultValues.string(forKey: "url")!
        user_api_key = defaultValues.string(forKey: "api")!
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editBookButton(_ sender: Any) {
        
        //switching the screen back to the scanner
        let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditBookViewController") as! EditBookViewController
        self.navigationController?.pushViewController(profileViewController, animated: true)
        self.dismiss(animated: false, completion: nil)

    }
    
    @IBAction func lendButton(_ sender: Any) {
        if book.status {
            //switching the screen to ReturnBookView
            let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ReturnBookViewController") as! ReturnBookViewController
            profileViewController.book = self.book
            self.navigationController?.pushViewController(profileViewController, animated: true)
            self.dismiss(animated: false, completion: nil)
        } else {
            
            queryUsers(API: user_api_key, pyBookURL: pyBookURL)

        }
    }
    
    @IBAction func newCopyButton(_ sender: UIButton) {
        //switching the screen
        let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "NewBookViewController") as! NewBookViewController
        profileViewController.book = self.book
        self.navigationController?.pushViewController(profileViewController, animated: true)
        self.dismiss(animated: false, completion: nil)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func queryUsers(API key: String, pyBookURL url: String) {
        
        // prepares the url from the login screen to be used in the api call
        // TODO better validation and formatting of the string
        let urlString = "https://\(url)/api/v1/\(key)/users"
        
        // creates urlsession and request
        let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // does http request
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                print("in let data guard")
                print("connection failure is one option why we get here")
                return
            }
            guard let users = try? JSONSerialization.jsonObject(with: data, options: []) as! [[String:Any?]]
                else {
                    print("in let json guard")
                    return
            }
            
            var spinnerData = Array<String>()
            
            // can prolly delete
//            print("objects in queryUsers")
//            print(users)
            
            for user in users {
                
                // can prolly delete
//                print(user["name"]!! as! String)
                
                spinnerData.append(user["name"]!! as! String)
            }
            
            // removes first user, i.e. the admin
            // this probably needs to be more robust
            spinnerData.remove(at: 0)
            
            // can prolly delete
//            print(self.book.author_first_name)
//            print("end objects in queryUsers")

            
            let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "LendBookView") as! LendBookView
            profileViewController.book = self.book
            profileViewController.users = users
            profileViewController.spinnerData = spinnerData
            self.navigationController?.pushViewController(profileViewController, animated: true)
            self.dismiss(animated: false, completion: nil)
        })
        task.resume()
    }
}
