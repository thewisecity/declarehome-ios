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
            Notifications.setSubscriptionForAllNotifs(true)
            segueToTabBarController()
        } else if(error != nil){
            print(error!.localizedDescription)
        }
        // Either way
        loadingView.hidden = true
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        
        let topBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height + self.navigationController!.navigationBar.frame.size.height
        let maxAmountToRaise = emailField.frame.origin.y - 20 - topBarHeight
        
        print("Keyboard will show")
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        var frame = self.view?.frame
        
        if keyboardFrame!.height < maxAmountToRaise
        {
            frame = CGRect(x: frame!.origin.x, y: view.frame.height - frame!.height - keyboardFrame!.height, width: frame!.size.width, height: frame!.size.height)
        }
        else
        {
            frame = CGRect(x: frame!.origin.x, y: view.frame.height - frame!.height - maxAmountToRaise, width: frame!.size.width, height: frame!.size.height)
        }
        
        UIView.beginAnimations(nil, context: nil)
        
        UIView.setAnimationDuration(0.32)
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseOut)
        self.view?.frame = frame!
        
        UIView.commitAnimations()
        
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        print("Keyboard will hide")
        var frame = self.view?.frame
        frame = CGRect(x: frame!.origin.x, y: 0, width: frame!.size.width, height: frame!.size.height)
        
        UIView.beginAnimations(nil, context: nil)
        
        UIView.setAnimationDuration(0.32)
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseOut)
        
        self.view?.frame = frame!
        
        UIView.commitAnimations()
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

