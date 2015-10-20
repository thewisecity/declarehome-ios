//
//  ViewController.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 10/12/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField : UITextField!
    @IBOutlet weak var passwordField : UITextField!
    
    @IBOutlet weak var loadingView : UIView!
    
    @IBOutlet weak var signInButton : UIButton!
    @IBOutlet weak var registerButton : UIButton!
    
    func segueToTabBarController() -> Void {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.segueToTabViewController()
    }
    
    @IBAction func attemptLogin() -> Void {
        
        let userEmail = emailField.text as String!
        let userPassword = passwordField.text as String!

        if(!userEmail.isEmpty && !userPassword.isEmpty){
            loadingView.hidden = false
            PFUser.logInWithUsernameInBackground(userEmail, password: userPassword) { (user, error) -> Void in
                self.loginCallback(user, error: error)
            }
        }
        
    }

    func loginCallback(user:PFUser?, error:NSError?) -> Void {
        if (user != nil){
            segueToTabBarController()
        } else if(error != nil){
            print(error!.localizedDescription)
        }
        // Either way
        loadingView.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

