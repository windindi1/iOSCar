//
//  ViewController.swift
//  TestEComm
//
//  Created by Tushar Indi on 05/09/19.
//  Copyright © 2019 Tushar Indi. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblError: UILabel!
    
    let databaseManager = DatabaseManager();
    
    var username = ""
    var password = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func btnLoginPressed(_ sender: Any) {
        username = txtUsername.text!
        password = txtPassword.text!

        let status = databaseManager.verifyLogin(username, password)
        switch status {
        case "success":
            databaseManager.saveLoginDetails(username)
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let homeView = mainStoryBoard.instantiateViewController(withIdentifier: "HomeView") as! UIViewController
            self.navigationController?.setViewControllers([homeView], animated: true)
            break;
        default:
            lblError.text = status
        }
    }
    
    @IBAction func txtFieldEdited(_ sender: Any) {
        let text1 = txtUsername.text!
        let text2 = txtPassword.text!
        
        if (text1.count > 0 && text2.count > 0) {
            btnLogin.isEnabled = true;
            btnLogin.backgroundColor = UIColor.init(red: 1, green: 0.5, blue: 0.3, alpha: 1)
        } else {
            btnLogin.isEnabled = false;
            btnLogin.backgroundColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        }
    }
    
}

