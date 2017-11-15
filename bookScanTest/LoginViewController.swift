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
        doLogin(username: username, password: password)
    }
    
    func doLogin(username user: String, password pword: String) {
        let testUser = "asouer"
        let testPword = "KillArcher"
        
        if ((user == testUser) && (pword == testPword)) {
            print("They match")
            
            //saving user values to defaults
            self.defaultValues.set(user, forKey: "username")
            self.defaultValues.set(pyBookURL.text, forKey: "url")

            //switching the screen
            let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! TabBarController
            self.navigationController?.pushViewController(profileViewController, animated: true)
            self.dismiss(animated: false, completion: nil)

        } else {
            print("bad bassword or username")
        }
    }
}

