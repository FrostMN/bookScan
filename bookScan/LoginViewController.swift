//
//  ViewController.swift
//  bookScanTest
//
//  Created by Aaron Souer on 11/14/17.
//  Copyright © 2017 Aaron Souer. All rights reserved.
//

import UIKit
import AVFoundation

class LoginViewController: UIViewController {
    // used to test if device has camera
    var captureSession: AVCaptureSession!
    
    //the defaultvalues to store user data
    let defaultValues = UserDefaults.standard

    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var pyBookURL: UITextField!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if defaultValues.string(forKey: "username") != nil{
            usernameField.isHidden = true
            passwordField.isHidden = true
            pyBookURL.isHidden = true
            loginButtonOutlet.isHidden = true

            self.navigationController?.isNavigationBarHidden = true
            
            let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! TabBarController

            self.navigationController?.pushViewController(profileViewController, animated: true)
        } else {
            usernameField.isHidden = false
            passwordField.isHidden = false
            pyBookURL.isHidden = false
            loginButtonOutlet.isHidden = false
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButton(_ sender: UIButton) {        
        let username = usernameField.text!
        let password = passwordField.text!
        let url = pyBookURL.text!
        queryUser(userName: username, password: password, pyBookURL: url)
    }

    
    func doLogin(userDict user: [String:Any?]) {

        if !(user["error"] as! Bool) {
            
            //saving user values to defaults
            self.defaultValues.set(user["username"]!!, forKey: "username")
            self.defaultValues.set(user["UserID"]!!, forKey: "id")
            self.defaultValues.set(user["admin"]!!, forKey: "admin")
            self.defaultValues.set(user["ApiKey"]!!, forKey: "api")
            self.defaultValues.set(pyBookURL.text, forKey: "url")

            // testing if device has camera
            var hasCamera: Bool
            if AVCaptureDevice.default(for: .video) != nil {
                hasCamera = true
            } else {
                hasCamera = false
            }
            
            if (hasCamera) {
                // Has camera
                print("has camera")

                //switching the screen
                let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! TabBarController
                self.navigationController?.pushViewController(profileViewController, animated: true)
                self.dismiss(animated: false, completion: nil)
            } else {
                print("no camera")
                //switching the screen
                let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! TabBarController
                self.navigationController?.pushViewController(profileViewController, animated: true)
                self.dismiss(animated: false, completion: nil)
            }
        } else {
            print("bad bassword or username")
        }
    }
    
    // function to do an api call and authenticate user
    func queryUser (userName user:String, password pword: String, pyBookURL url: String) {
        
        // prepares the url from the login screen to be used in the api call
        // TODO better validation and formatting of the string
        let urlString = "https://\(url)/api/v1/login"

        // creates urlsession and request
        let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postString = "{ \"user\": \"\(user)\", \"password\": \"\(pword)\" }"
        request.httpBody = postString.data(using: .utf8)

        // does http request
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            // get data from request
            guard let data = data else {
                print("in queryUser() let data guard")
                print("connection failure is one option why wh get here")
                return
            }
            
            // parse data into dict
            guard let user = try? JSONSerialization.jsonObject(with: data, options: []) as! [String:Any?]
                else {
                print("in queryUser() let json guard")
                return
            }
            
            // call login function with queried user data
            self.doLogin(userDict: user )
        })
        task.resume()
    }
}

