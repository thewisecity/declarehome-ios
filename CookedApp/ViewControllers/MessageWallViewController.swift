//
//  MessageWallViewController.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 10/15/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

import UIKit

class MessageWallViewController: UIViewController, NavigationDelegate, MessageUIViewDelegate {
    
    var group: Group!
    
    @IBOutlet weak var messageUI : MessageUIView!
    
    // This actually comes from out MessageUIViewDelegate!
    var messageTextField: UITextField?
    
    var navDelegate: NavigationDelegate!
    
    var messagesTableViewController: MessageTableViewController!
    
    func segueToAuthorDetails() -> Void
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.segueToTabViewController()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        messageUI.delegate = self
        messagesTableViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("MessageTableViewController") as! MessageTableViewController
        messagesTableViewController.group = group
        messagesTableViewController.navDelegate = self
        
        self.title = group.name
        
        let application = UIApplication.sharedApplication()
        let topBarHeight = application.statusBarFrame.size.height + self.navigationController!.navigationBar.frame.size.height
        let tabBarHeight = self.tabBarController?.tabBar.frame.size.height
        let viewHeight = UIScreen.mainScreen().bounds.size.height - topBarHeight - tabBarHeight!
        
        messagesTableViewController.view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y + topBarHeight, width: view.frame.width, height: viewHeight)
        
        self.view.addSubview(messagesTableViewController.view)
        self.view.sendSubviewToBack(messagesTableViewController.view)
        
        messageTextField = UITextField(frame: CGRect(x: 0, y: UIApplication.sharedApplication().delegate!.window!!.frame.height, width: UIApplication.sharedApplication().delegate!.window!!.frame.width, height: 30))
        messageTextField?.placeholder = "Message Text"
        self.view.addSubview(messageTextField!)
        messageTextField?.delegate = self
        self.view.bringSubviewToFront(messageTextField!)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(messagesTableViewController, selector: "loadObjects", name: Message.NOTIFICATION_POST_MESSAGE_SUCCEEDED, object: nil)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().removeObserver(messagesTableViewController)
    }
    
    //TODO: Move this to the MessageUI class
    func keyboardWillShow(notification: NSNotification)
    {
        print("Keyboard will show")
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        var frame = self.messageTextField?.frame
        frame = CGRect(x: frame!.origin.x, y: view.frame.height - frame!.height - keyboardFrame!.height, width: frame!.size.width, height: frame!.size.height)

        UIView.beginAnimations(nil, context: nil)
        
        UIView.setAnimationDuration(0.32)
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseOut)
        self.messageTextField?.frame = frame!
        
        UIView.commitAnimations()

    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        print("Keyboard will hide")
        var frame = self.messageTextField?.frame
        frame = CGRect(x: frame!.origin.x, y: view.frame.size.height, width: frame!.size.width, height: frame!.size.height)
        
        UIView.beginAnimations(nil, context: nil)
        
        UIView.setAnimationDuration(0.32)
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseOut)
        
        self.messageTextField?.frame = frame!
        
        UIView.commitAnimations()
        messageUI.endMessageCreation()

    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func performSegueWithId(identifer: String, sender: AnyObject?) {
        performSegueWithIdentifier(identifer, sender: sender)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if let authorOfSelectedMessage = sender as? User
        {
            if let destinationController = segue.destinationViewController as? UserDetailsViewController
            {
                destinationController.user = authorOfSelectedMessage
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        
        //Place holder
        let chosenAlertCategoryIsNull = true
        
        if(chosenAlertCategoryIsNull)
        {
            let messageIsLegal = (textField.text != nil && textField.text?.isEmpty == false)
            if(messageIsLegal)
            {
                postNewMessage(textField.text)
            }
            textField.endEditing(true)
        }
        else
        {
            print("Here is where we will post a new alert")
        }
        
        return false
    }
    
    func textFieldDidChange() -> Void
    {
        if(messageTextField?.text == nil || (messageTextField?.text?.isEmpty == true))
        {
            messageTextField?.returnKeyType = UIReturnKeyType.Done
        }
        else
        {
            messageTextField?.returnKeyType = UIReturnKeyType.Send
        }
    }
    
    
    // MARK –– MessageUI Delegate methods
    
    func postNewMessage(messageBody: String?)
    {
        print("Posting message:" + messageBody!)
        Message.postNewMessage(PFUser.currentUser() as! User, group: group, body: messageBody!)
    }
    
    func postNewAlert(category:AlertCategory, messageBody: String?)
    {
        
    }
    
    func plusButtonTouched()
    {
        print("Plus button touched")
    }
    
    func alertButtonTouched()
    {
        print("Alert button touched")
    }
    
    func messageButtonTouched()
    {
        print("Message button touched")
    }
}
