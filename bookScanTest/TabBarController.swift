//
//  TabBarController.swift
//  bookScanTest
//
//  Created by Aaron Souer on 11/14/17.
//  Copyright © 2017 Aaron Souer. All rights reserved.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {

    // prolly ok to delete
//    var pyBookUrl = ""
//    var apiKey = ""
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //hiding back button
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        

        // prolly ok to delete
//        print("In TabBarController")
//        print(pyBookUrl)
//        print(apiKey)
       
        
//        let ScannerViewController = self.storyboard?.instantiateViewController(withIdentifier: "ScannerViewController") as! ScannerViewController
//        ScannerViewController.key = apiKey
//        ScannerViewController.url = pyBookUrl
//        
//        let UserViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserViewController") as! UserViewController
//        UserViewController.key = apiKey
//        UserViewController.url = pyBookUrl

    }
}
