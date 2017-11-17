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
    var book: Book!
    
    @IBOutlet weak var bookTitle: UITextField!
    @IBOutlet weak var isbn10Field: UITextField!
    @IBOutlet weak var isbn13Field: UITextField!
    @IBOutlet weak var authoFirstNameField: UITextField!
    @IBOutlet weak var authorLastNameField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("NewBookViewCOntroller viewDidLoad()")
        print(book.title)
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

}
