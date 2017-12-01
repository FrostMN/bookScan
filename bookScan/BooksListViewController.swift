//
//  BooksListViewController.swift
//  bookScanTest
//
//  Created by Aaron Souer on 11/15/17.
//  Copyright © 2017 Aaron Souer. All rights reserved.
//
//  This page created with help from this tutorial
//  http://blog.chrishannah.me/getting-started-with-uitableview-populating-data/
//

import Foundation
import UIKit

class BooksListViewController: UITableViewController {
    
    //the defaultvalues to access user data
    let defaultValues = UserDefaults.standard
    
    
    var books: Array<Book> = Array()
    var user_api_key = ""
    var pyBookURL = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("BooksListViewController viewDidLoad()")
        print(books)
        self.tableView.rowHeight = 75
        
        //load valeues from defaults
        pyBookURL = defaultValues.string(forKey: "url")!
        user_api_key = defaultValues.string(forKey: "api")!

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        defaultValues.set(true, forKey: "fromBookView")
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Books"
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: // Books in list
            return books.count + 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create an object of the dynamic cell "bookObject"
//        let cell = tableView.dequeueReusableCell(withIdentifier: "bookObject", for: indexPath) as! BookObjectTableViewCell
        switch indexPath.section {
        case 0:
            if indexPath.row < books.count {

                let cell = tableView.dequeueReusableCell(withIdentifier: "bookObject", for: indexPath) as! BookObjectTableViewCell

                
                // each Book from books[]
//            cell.textLabel?.text = books[indexPath.row].title
            cell.bookTitleLabel.text = books[indexPath.row].title
            cell.bookIdLabel.text = "BookID: \(books[indexPath.row].bookId)"
//            if books[]
            print(books[indexPath.row].status)
            if books[indexPath.row].status {
                cell.bookLocationLabel.text = books[indexPath.row].location
            } else {
                cell.bookLocationLabel.text = "On Shelf"
            }
            cell.bookAuthorLabel.text = "\(books[indexPath.row].author_first_name) \(books[indexPath.row].author_last_name)"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "addBook", for: indexPath) as! newBookTableViewCell
                return cell
            }
//            break
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "addBook", for: indexPath) as! newBookTableViewCell
            return cell

//            break
        }
        
        // Return the configured cell
//        return cell
//        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // determines if click is last row or not
        if indexPath.row < books.count {
  
            defaultValues.set(true, forKey: "fromBookView")
            
            //switching the screen to Boos Stastus Controller View
            let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "BookStatusViewController") as! BookStatusViewController
            profileViewController.book = books[indexPath.row]
            self.navigationController?.pushViewController(profileViewController, animated: true)
            self.dismiss(animated: false, completion: nil)

        } else {
            print("add book row")
            //switching the screen
            let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "NewBookViewController") as! NewBookViewController
            profileViewController.book = self.books[0]
            self.navigationController?.pushViewController(profileViewController, animated: true)
            self.dismiss(animated: false, completion: nil)

        }
        
    }
    
    func queryUsers(API key: String, pyBookURL url: String, Book book: Book) {
        
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
                print("connection failure is one option why wh get here")
                return
            }
            guard let users = try? JSONSerialization.jsonObject(with: data, options: []) as! [[String:Any?]]
                else {
                    print("in let json guard")
                    return
            }
            
            var spinnerData = Array<String>()
            
            print("objects in queryUsers")
            print(users)
            
            for user in users {
                print(user["name"]!! as! String)
                spinnerData.append(user["name"]!! as! String)
            }
            
            // removes first user, i.e. the admin
            // this probably needs to be more robust
            spinnerData.remove(at: 0)
            
            print("end objects in queryUsers")
            
            
            let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "LendBookView") as! LendBookView
            profileViewController.book = book
            profileViewController.users = users
            profileViewController.spinnerData = spinnerData
            self.navigationController?.pushViewController(profileViewController, animated: true)
            self.dismiss(animated: false, completion: nil)
            
            
        })
        task.resume()
    }

    
    

}
