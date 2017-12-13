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
    var bookCover: UIImage!
    
    @IBOutlet weak var bookCoverView: UIImageView!
    
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    
    @IBOutlet weak var isbn10Label: UILabel!
    @IBOutlet weak var isbn13Label: UILabel!
    
    var url = ""
    var api = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //load valeues from defaults
        url = defaultValues.string(forKey: "url")!
        api = defaultValues.string(forKey: "api")!
        
        bookTitleLabel.text = book.title
        bookAuthorLabel.text = "\(book.author_first_name) \(book.author_last_name)"
        
        isbn10Label.text = book.isbn10
        isbn13Label.text = book.isbn13

        print("just before assignment in viewDidLoad")
        print(bookCover)
        
        let resizedCover = self.resizeImage(image: bookCover, targetSize: self.bookCoverView.frame.size)
        
        self.bookCoverView.image = resizedCover
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // unhides nav bar for this view
        self.navigationController?.isNavigationBarHidden = false
        
        // tells the next view it came from the table view so it displays differently
        defaultValues.set(true, forKey: "fromBookView")
        
        if defaultValues.bool(forKey: "showCoverImage") {
            self.bookCoverView.isHidden = false
        } else {
            self.bookCoverView.isHidden = true
        }
        print("just before assignment in viewWillAppear")
//        self.bookCoverView.image = bookCover
    }
    
    @IBAction func saveBookButton(_ sender: UIButton) {
        let bookTitleStr = book.title
        let isbn10Str = book.isbn10
        let isbn13Str = book.isbn13
        let authorFNameStr = book.author_first_name
        let authorLNameStr = book.author_last_name

        let requestData = "{ \"title\": \"\(bookTitleStr)\", \"isbn_ten\": \"\(isbn10Str)\", \"isbn_thr\": \"\(isbn13Str)\", \"author_fname\": \"\(authorFNameStr)\", \"author_lname\": \"\(authorLNameStr)\" }"
        
        addBook(postData: requestData, API: api, pyBookURL: url)
        
        //switching the screen back to the scanner
        let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! TabBarController
        self.navigationController?.pushViewController(profileViewController, animated: true)
        self.dismiss(animated: false, completion: nil)

    }
    
    @IBAction func editBookButton(_ sender: Any) {
        let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditBookViewController") as! EditBookViewController
        
        print(book)
        
        profileViewController.book = book!
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
    
    // the resizeImage() func is adapted from
    // https://stackoverflow.com/questions/31314412/how-to-resize-image-in-swift
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}
