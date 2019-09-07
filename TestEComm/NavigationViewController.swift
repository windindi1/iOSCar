//
//  NavigationViewController.swift
//  TestEComm
//
//  Created by Tushar Indi on 06/09/19.
//  Copyright © 2019 Tushar Indi. All rights reserved.
//

import Foundation
import UIKit

class NavigationViewController: UINavigationController {
    
    
    let databaseManager = DatabaseManager();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
//        print("Nav loaded")
        let loginStatus = databaseManager.getLaunchStatus()
        
        if (loginStatus["loginStatus"] == "loggedIn") {
            performSegue(withIdentifier: "entryToHome", sender: self)
        } else {
            performSegue(withIdentifier: "entryToLogin", sender: self)
        }
    }
}
