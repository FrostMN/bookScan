//
//  UserViewController.swift
//  bookScanTest
//
//  Created by Aaron Souer on 11/14/17.
//  Copyright © 2017 Aaron Souer. All rights reserved.
//
//  This page s adapated from the tutorial on
//  https://www.appcoda.com/simple-barcode-reader-app-swift/
//

import UIKit
import AVFoundation
import BarcodeScanner

class ScannerViewController: UIViewController {
    
    //the defaultvalues to access user data
    let defaultValues = UserDefaults.standard
    
    // setting up outlets
    @IBOutlet weak var searchIsbnField: UITextField!
    @IBOutlet weak var searchIsbnButton: UIButton!
    
    @IBOutlet weak var scanIsbnButton: UIButton!
    
    // setting up vars
    var url = ""
    var key = ""
    var cover = UIImage(named: "defaultCover")

    // set up scanner
    private let controller = BarcodeScannerController()

    
    @IBAction func searchIsbnButton(_ sender: Any) {
        
        let ISBN = searchIsbnField.text!

        if Valid.isbn(ISBN: ISBN) {
            isbnInDB(ISBN: ISBN, URL: url, API: key)
        }
    
    }
    
    @IBAction func scanIsbnButton(_ sender: Any) {
        controller.title = "ISBN Scanner"
        present(controller, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // filling vars from user data
        url = defaultValues.string(forKey: "url")!
        key = defaultValues.string(forKey: "api")!

        // setup scanner controller on vew loading
        controller.codeDelegate = self as BarcodeScannerCodeDelegate
        controller.errorDelegate = self as BarcodeScannerErrorDelegate
        controller.dismissalDelegate = self as BarcodeScannerDismissalDelegate
        
        if defaultValues.bool(forKey: "camera") {
            print(defaultValues.bool(forKey: "camera"))
            print("in view will appers camera")
            scanIsbnButton.isHidden = false
            
        } else {
            print("in view will appers no camera")
            scanIsbnButton.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        defaultValues.set(false, forKey: "fromBookView")
        self.navigationController?.isNavigationBarHidden = true
//        searchIsbnField.text = ""
        
//        if defaultValues.bool(forKey: "camera") {
//            print(defaultValues.bool(forKey: "camera"))
//            print("in view will appers camera")
//            scanIsbnButton.isHidden = false
//
//        } else {
//            print("in view will appers no camera")
//            scanIsbnButton.isHidden = true
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        defaultValues.set(false, forKey: "fromBookView")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.isNavigationBarHidden = false
    }

    func isbnInDB(ISBN isbn:String, URL url:String, API key: String) {
        // prepares the url from the login screen to be used in the api call
        // TODO better validation and formatting of the string
        let urlString = "https://\(url)/api/v1/\(key)/exists/\(isbn)"
        let ur = url
        
//        print(urlString)
        
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
            guard let isbnExists = try? JSONSerialization.jsonObject(with: data, options: []) as! [String:Any?]
                else {
                    print("in let json guard of isbnInDB")
                    
                    return
            }
            
            if isbnExists["isbnExists"]!! as! Bool {
                print("it exists")
                self.queryISBN(ISBN: isbn, URL: ur, API: key)
                
            } else {
                print("it dosent exist")
                self.defaultValues.set(true, forKey: "showCoverImage")
                self.getBookCover(ISBN: isbn, URL: ur, API: key)

//                self.addBook(ISBN: isbn, URL: ur, API: key)
            }
            
        })
        task.resume()
    }
    
    
    func addBook( ISBN isbn: String, URL url: String, API key: String ) {
        // create url string for request
        let urlString = "https://\(url)/api/get/\(key)/\(isbn)"
//        print("in addBook()")
//        print(urlString)
        
        // creates urlsession and request
        let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                print("in let data guard")
                print("connection failure is one option why wh get here")
                return
            }
            guard let bookJson = try? JSONSerialization.jsonObject(with: data, options: []) as! [String:Any?]
                else {
                    print("in let json guard of isbnInDB")
                    
                    return
            }
            
            let status = bookJson["status"]!! as! Bool
//            print(bookJson["title"]!!)
            let title = bookJson["title"]!! as! String
//            print(bookJson["isbn_10"]!!)
            let isbn10 = bookJson["isbn_10"]!! as! String
//            print(bookJson["isbn_13"]!!)
            let isbn13 = bookJson["isbn_13"]!! as! String
//            print(bookJson["author"]!!)
            let author = bookJson["author"]!! as! String
            let author_fn = author.components(separatedBy: " ")[0]
            let author_ln = author.components(separatedBy: " ")[1]
            
            // create new book object to send to view
            let newBook = Book(bookTitle: title, isbn10: isbn10, isbn13: isbn13, authorFirstName: author_fn, authorLastName: author_ln, bookStatus: status)
            
            
            //switching the screen
            let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "NewBookViewController") as! NewBookViewController
            profileViewController.book = newBook
            profileViewController.bookCover = self.cover
            self.navigationController?.pushViewController(profileViewController, animated: true)
            self.dismiss(animated: false, completion: nil)
            
        })
        task.resume()
    }
    
    func queryISBN(ISBN isbn: String, URL url: String, API key: String ) {
        // create url string for request
        let urlString = "https://\(url)/api/v1/\(key)/books/\(isbn)"
        
        // creates urlsession and request
        let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                print("in let data guard")
                print("connection failure is one option why wh get here")
                return
            }

            guard let booksJson = try? JSONSerialization.jsonObject(with: data, options: []) as! Array<[String:Any?]>
                else {
                    print("in let json guard of queryISBN")
                    
                    return
            }
            
            var books = [Book]()
            
            for bk in booksJson {
                let status = bk["status"]!! as! Bool
                let title = bk["title"]!! as! String
                let isbn10 = bk["isbn_10"]!! as! String
                let isbn13 = bk["isbn_13"]!! as! String
                let author = bk["author"]!! as! String
                let author_fn = author.components(separatedBy: " ")[0]
                let author_ln = author.components(separatedBy: " ")[1]
                let BookID = bk["id"]!! as! Int
                let location = bk["lendee"] as! String
                let book = Book(bookTitle: title, isbn10: isbn10, isbn13: isbn13, authorFirstName: author_fn, authorLastName: author_ln, bookID: BookID, bookStatus: status, bookLocation: location)
                
                books.append(book)
            }
            
            
            if books.count == 1 {
                
                //switching the screen to single book options
                let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "BookStatusViewController") as! BookStatusViewController
                profileViewController.book = books[0]
                self.navigationController?.pushViewController(profileViewController, animated: true)
                self.dismiss(animated: false, completion: nil)
            } else {
                
                //switching the screen to book list
                let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "BooksListViewController") as! BooksListViewController
                profileViewController.books = books
                self.navigationController?.pushViewController(profileViewController, animated: true)
                self.dismiss(animated: false, completion: nil)
            }
        })
        task.resume()
    }

    // the getBookCover() function is adapted from
    // https://stackoverflow.com/questions/38643686/how-to-display-image-from-api-in-swift
    
    func getBookCover(ISBN isbn: String, URL ur: String, API key: String) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        if let url = NSURL(string: "https://covers.openlibrary.org/b/isbn/\(isbn)-L.jpg"){
            
            let task = session.dataTask(with: url as URL, completionHandler: {data, response, error in
                
                if let err = error {
                    print("Error: \(err)")
                    return
                }
                
                if let http = response as? HTTPURLResponse {
                    if http.statusCode == 200 {
                        DispatchQueue.main.async {
                            guard let apiCover = UIImage(data: data!) else {
                                self.cover = UIImage(named: "defaultCover")!
                                return
                            }
                            
                            self.cover = apiCover
                            
                            self.addBook(ISBN: isbn, URL: ur, API: key)

                        }
                    }
                }
            })
            task.resume()
        }
    }
}


// adds action to scanner
extension ScannerViewController: BarcodeScannerCodeDelegate {
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
//        print("Barcode Data: \(code)")
//        print("Symbology Type: \(type)")
        
        isbnInDB(ISBN: code, URL: url, API: key)
        
        let delayTime = DispatchTime.now() + Double(Int64(12 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            controller.resetWithError()
        }
    }
}

extension ScannerViewController: BarcodeScannerErrorDelegate {
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        print(error)
    }
}

extension ScannerViewController: BarcodeScannerDismissalDelegate {
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
