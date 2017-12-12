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
    
    // the defaultvalues to access user data
    let defaultValues = UserDefaults.standard
    
    // creates vars for view
    var books: Array<Book> = Array()
    var user_api_key = ""
    var pyBookURL = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // set table cell height
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

    // sets title of table view
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Books"
    }

    // sets number of columns in table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // sets number of rows in table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count + 1
    }
    
    // pupulated table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < books.count {
            // Create an object of the dynamic cell "bookObject"
            let cell = tableView.dequeueReusableCell(withIdentifier: "bookObject", for: indexPath) as! BookObjectTableViewCell

            // sets book title for cell
            cell.bookTitleLabel.text = books[indexPath.row].title
            
            // sets book id for cell
            cell.bookIdLabel.text = "BookID: \(books[indexPath.row].bookId)"
            
            // sets book location for cell
            if books[indexPath.row].status {
                cell.bookLocationLabel.text = books[indexPath.row].location
            } else {
                // todo, add location object to db
                cell.bookLocationLabel.text = "On Shelf"
            }
            
            // sets author name for cell
            cell.bookAuthorLabel.text = "\(books[indexPath.row].author_first_name) \(books[indexPath.row].author_last_name)"
            return cell
        }
        else {
            // Create an object of the dynamic cell "addBook"
            let cell = tableView.dequeueReusableCell(withIdentifier: "addBook", for: indexPath) as! newBookTableViewCell
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // determines if click is last row or not
        if indexPath.row < books.count {
  
            // tells the next view it came from the table view so it displays differently
            defaultValues.set(true, forKey: "fromBookView")
            
            //switching the screen to Boos Stastus Controller View
            let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "BookStatusViewController") as! BookStatusViewController
            profileViewController.book = books[indexPath.row]
            self.navigationController?.pushViewController(profileViewController, animated: true)
            self.dismiss(animated: false, completion: nil)
        } else {
            
            print("just before image assign in list view")
            let cover = UIImage(named: "testCover")!
            
//            print(cover)
            
            // switching the screen to 'NewBookViewController' to allow for adding copy of book
            let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "NewBookViewController") as! NewBookViewController
            profileViewController.book = self.books[0]
            profileViewController.bookCover = cover
            self.navigationController?.pushViewController(profileViewController, animated: true)
            self.dismiss(animated: false, completion: nil)
        }
    }
}
