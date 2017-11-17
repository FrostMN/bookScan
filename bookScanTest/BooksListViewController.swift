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
    
    var books: Array<Book> = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("BooksListViewController viewDidLoad()")
        print(books)
        self.tableView.rowHeight = 75
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            return books.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create an object of the dynamic cell "bookObject"
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookObject", for: indexPath) as! BookObjectTableViewCell
        switch indexPath.section {
        case 0:
            // each Book from books[]
//            cell.textLabel?.text = books[indexPath.row].title
            cell.bookTitleLabel.text = books[indexPath.row].title
            cell.bookIdLabel.text = "BookID: \(books[indexPath.row].bookId)"
            cell.bookLocationLabel.text = "On Shelf" // needs to be implemented
            cell.bookAuthorLabel.text = "\(books[indexPath.row].author_first_name) \(books[indexPath.row].author_last_name)"
            break
        default:
            break
        }
        
        // Return the configured cell
        return cell
    }
}
