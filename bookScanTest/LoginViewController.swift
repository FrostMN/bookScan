//
//  ViewController.swift
//  bookScanTest
//
//  Created by Aaron Souer on 11/14/17.
//  Copyright © 2017 Aaron Souer. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    //the defaultvalues to store user data
    let defaultValues = UserDefaults.standard

    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var pyBookURL: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButton(_ sender: UIButton) {
        print("in loginButton")
        let username = usernameField.text!
        let password = passwordField.text!
        let url = pyBookURL.text!
        doLogin(username: username, password: password, pyBookURL: url)
    }
    
    func doLogin(username user: String, password pword: String, pyBookURL url: String) {
        
        let jsonData = getLoginData(userName: user, password: pword, pyBookURL: url)!
        
        Api.queryUser(userName: user, password: pword, pyBookURL: url)
//        Api.testURL(pyBookURL: url)

        print(jsonData)

        if !(jsonData["error"] as! Bool) {
            print("They match")
            
            print(jsonData["username"]!)
            
            //saving user values to defaults
            self.defaultValues.set(jsonData["username"]!, forKey: "username")
            self.defaultValues.set(jsonData["UserID"]!, forKey: "id")
            self.defaultValues.set(jsonData["admin"]!, forKey: "admin")
            self.defaultValues.set(pyBookURL.text, forKey: "url")

            //switching the screen
            let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! TabBarController
            self.navigationController?.pushViewController(profileViewController, animated: true)
            self.dismiss(animated: false, completion: nil)

        } else {
            print("bad bassword or username")
        }
    }
    
    // the following function was from
    // https://stackoverflow.com/questions/30480672/how-to-convert-a-json-string-to-a-dictionary
    func convertToDictionary(text: String) -> [String: Any]! {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            } catch {
                print("in catch")
                print(error.localizedDescription)
                print("end catch")
            }
        }
        return nil
    }
    
    func getLoginData(userName user:String, password pword:String, pyBookURL url: String ) -> [String: Any]!  {
        let testAdmin = "asouer"
        let testGuest = "guest"
        let testPword = "KillArcherDie"
        var admin = "false"
        
        var json = "{ \"error\": true, \"message\": \"Invalid username or password\" }"
        
        if pword == testPword {
            if user == testAdmin || user == testGuest {
                if user == testAdmin {
                    admin = "true"
                }
            json = "{ \"error\": false, \"UserID\": \"1\", \"username\": \"\(user)\", \"admin\": \(admin) } "
            } else {
                return convertToDictionary(text: json)!
            }
        } else {
            return convertToDictionary(text: json)!
        }
        return convertToDictionary(text: json)!
    }
    
}

