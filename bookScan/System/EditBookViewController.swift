//
//  EditBookViewController.swift
//  bookScanTest
//
//  Created by Aaron Souer on 11/20/17.
//  Copyright © 2017 Aaron Souer. All rights reserved.
//

import UIKit

class EditBookViewController: UIViewController {
    
    //the defaultvalues to access user data
    let defaultValues = UserDefaults.standard

    var book: Book!
    
    var user_api_key = ""
    var pyBookURL = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //load valeues from defaults
        pyBookURL = defaultValues.string(forKey: "url")!
        user_api_key = defaultValues.string(forKey: "api")!

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // unhides nav bar for this view
        self.navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
