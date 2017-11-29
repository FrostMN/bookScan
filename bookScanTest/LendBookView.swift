//
//  LendBookView.swift
//  bookScanTest
//
//  Created by Aaron Souer on 11/20/17.
//  Copyright © 2017 Aaron Souer. All rights reserved.
//

import UIKit

class LendBookView: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //the defaultvalues to access user data
    let defaultValues = UserDefaults.standard

    // sets vars for view
    var book: Book? = nil
    var users = Array<[String:Any?]>()
    var spinnerData = Array<String>()
    var selectedUser = ""
    var pyBookURL = ""
    var user_api_key = ""
    
    @IBOutlet weak var namePicker: UIPickerView!

    // functions to setup spinner
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return spinnerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int ) -> String? {
        return spinnerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedUser = spinnerData[row]
        let userID = getUserIDbyName(userName: selectedUser)
        print("\(selectedUser): \(userID)")
    }

    // Tasks to setup view
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // unhides nav bar for this view
        self.navigationController?.isNavigationBarHidden = false
}

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        print("in LendBookView")
        
//        print(book!)
//        print(users)
//        print(spinnerData)
        selectedUser = spinnerData[0]
        
        //load valeues from defaults
        pyBookURL = defaultValues.string(forKey: "url")!
        user_api_key = defaultValues.string(forKey: "api")!

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // perform the lending of a book
    @IBAction func lendBookButton(_ sender: Any) {
        let bookID = String(book!.bookId)
        let userID = String(getUserIDbyName(userName: selectedUser))
        
        // prolly can delete
        //        print(bookID)
        
        lendBook(API: user_api_key, pyBookURL: pyBookURL, BookID: bookID, UserID: userID )
    }
    
    // prolly can delete
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func lendBook(API key: String, pyBookURL url: String, BookID bookID: String, UserID userID: String ) {
    
        // prepares the url from the login screen to be used in the api call
        // TODO better validation and formatting of the string
        
        //need to chane url call
        let urlString = "https://\(url)/api/v1/\(key)/books/\(userID)"
        
        // creates urlsession and request
        let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        let putData = "{ \"action\": \"lend\", \"bookID\": \"\(bookID)\", \"userID\": \"\(userID)\" }"
        
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

    func getUserIDbyName(userName user: String) -> Int {
        for usr in self.users {
            print( usr )
            print( usr["name"]!! )
            if usr["name"]!! as! String == user {
                return usr["id"]!! as! Int
            }
        }
        return -1
    }

}
