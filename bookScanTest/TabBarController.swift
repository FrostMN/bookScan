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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //hiding back button
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
    }
}
