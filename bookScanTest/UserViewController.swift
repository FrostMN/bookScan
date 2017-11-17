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
    
    @IBOutlet weak var isbnField: UITextField!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    let testISBN = "1234567890"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("UserViewController viewDidLoad()")
        let defaultValues = UserDefaults.standard

        userLabel.text = defaultValues.string(forKey: "username")
        urlLabel.text = defaultValues.string(forKey: "url")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isbnField.text = ""
    }
    
    @IBAction func searchISBN(_ sender: UIButton) {
        print("In searchISBN")
        let ISBN = isbnField.text!
        print(ISBN)
        if (Api.bookExists(ISBN: ISBN)) {
            print("isbn matches")
            let books = Api.searchBooks(ISBN: ISBN)
            print(books)
            
            if (books.count == 1) {
                
            } else {
                
                //switching the screen
                let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "BooksListViewController") as! BooksListViewController
                profileViewController.books = books
                self.navigationController?.pushViewController(profileViewController, animated: true)
                self.dismiss(animated: false, completion: nil)
            }
            
        } else {
            print("isbn does not match")
            
            let ISBN10 = isbnField.text!
            let newBook = Api.getNewBook(ISBN: ISBN10)
            
            
            print(newBook.title)
            
            
            //switching the screen
            let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "NewBookViewController") as! NewBookViewController
            profileViewController.book = newBook
            self.navigationController?.pushViewController(profileViewController, animated: true)
            self.dismiss(animated: false, completion: nil)

        }
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
    
}
