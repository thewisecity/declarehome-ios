//
//  MessageWallViewController.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 10/15/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

import UIKit

class MessageWallViewController: UIViewController, NavigationDelegate, MessageUIViewDelegate, AlertCategoriesTableViewDelegate {
    
    var group: Group!
    var selectedGroups: [Group]? {
        didSet {
            if let selectedGroups = selectedGroups
            {
                messageUI.showAlertComposition()
            }
        }
    }
    
    var chosenCategory: AlertCategory?
    
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
        messageTextField?.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(messageTextField!)
        messageTextField?.delegate = self
        messageTextField?.returnKeyType = UIReturnKeyType.Done
        // UNCOMMENT this to re-enable partial (read: broken) implementaiton of changing return key while editing
//        messageTextField?.addTarget(self, action: "textFieldDidChange", forControlEvents: UIControlEvents.EditingChanged)
        self.view.bringSubviewToFront(messageTextField!)
        
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(messagesTableViewController, selector: "loadObjects", name: Message.NOTIFICATION_POST_MESSAGE_SUCCEEDED, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
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
        
        if let destinationController = segue.destinationViewController as? AlertCategoriesTableViewController
        {
            destinationController.delegate = self
        }
        
        if let destinationController = segue.destinationViewController as? GroupsCheckboxTableViewController
        {
            destinationController.delegate = self
        }
    }
    
    /*
     * This is where we actually send our message depending on the context!
     * Either that, or we just erase our present category and return
     */
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        
        // First we want to find out if the textfield is blank
        let messageText = getTrimmedMessageTextWithoutCategoryTitle()
        let messageIsLegal = (messageText != nil && messageText!.isEmpty == false)
        
        if(messageIsLegal)
        {
            // We're going to post a message. Just need to find out if it's a regular message or an alert
            if(chosenCategory == nil)
            {
                postNewMessage(messageText)
            }
            else
            {
                postNewAlert(chosenCategory!, messageBody: messageText)
            }
        }
        
        
        textField.endEditing(true)
        return false
    }
    
    func getTrimmedMessageTextWithoutCategoryTitle() -> String?{
        var str: String? = messageTextField?.text
        if chosenCategory != nil
        {
            str = str?.stringByReplacingOccurrencesOfString(chosenCategory!.title, withString: "")
        }
        str = str?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        return str
    }
    
    
    //TODO: Get this working. Not quite there yet
    
//    func textFieldDidChange() -> Void
//    {
//        var textSansCategory:String? = messageTextField?.text;
//        
//        if(chosenCategory != nil){
//            textSansCategory = textSansCategory?.stringByReplacingOccurrencesOfString((chosenCategory?.title)!, withString: "");
//        }
//        
//        
//        if(textSansCategory == nil || (textSansCategory!.isEmpty == true))
//        {
//            messageTextField?.returnKeyType = UIReturnKeyType.Done
//            messageTextField?.resignFirstResponder()
//            messageTextField?.becomeFirstResponder()
//            self.reloadInputViews()
//            messageTextField?.reloadInputViews()
//        }
//        else
//        {
//            messageTextField?.returnKeyType = UIReturnKeyType.Send
//            messageTextField?.resignFirstResponder()
//            messageTextField?.becomeFirstResponder()
//            self.reloadInputViews()
//            messageTextField?.reloadInputViews()
//        }
//    }
    
    
    // MARK –– MessageUI Delegate methods
    
    func postNewMessage(messageBody: String?)
    {
        print("Posting message:" + messageBody!)
        Message.postNewMessage(PFUser.currentUser() as! User, group: group, body: messageBody!)
    }
    
    func postNewAlert(category:AlertCategory, messageBody: String?)
    {
        Message.postNewAlert(PFUser.currentUser() as! User, groups: selectedGroups!, body: messageBody!, category: chosenCategory!)
    }
    
    func plusButtonTouched()
    {
        print("Plus button touched")
    }
    
    func alertButtonTouched()
    {
        print("Alert button touched")
        chosenCategory = nil
        selectedGroups = nil
        performSegueWithIdentifier("ViewAlertCategoriesList", sender: self)
        
    }
    
    func messageButtonTouched()
    {
        chosenCategory = nil
        print("Message button touched")
    }
    
    // MARK –– AlertCategoriesTableView Delegate methods
    
    func chooseAlertCategory(category: AlertCategory?) -> Void
    {
        self.navigationController?.popViewControllerAnimated(true)
        print("Chose an alert category in delegate")
        print(category?.title)
        chosenCategory = category
        
        performSegueWithIdentifier("ChooseGroupsForAlert", sender: self)
    }
    
    
    /**
     * This is how we prevent the user from deleting category title text from the uitextview
     */
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var tryingToEditCategoryTitle = false
        
        if chosenCategory != nil
        {
            let categoryLength = chosenCategory?.title.characters.count
            if range.location <= categoryLength
            {
                tryingToEditCategoryTitle = true
            }
        }
        
        return !tryingToEditCategoryTitle
    }
    
    func finishedChoosingGroups(groups: [Group]) {
        print("Finished choosing groups")
        self.navigationController?.popViewControllerAnimated(true)
        selectedGroups = groups
    }
    
//    - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//    {
//    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    NSLog(@"resulting string would be: %@", resultString);
//    NSString *prefixString = @"blabla";
//    NSRange prefixStringRange = [resultString rangeOfString:prefixString];
//    if (prefixStringRange.location == 0) {
//    // prefix found at the beginning of result string
//    return YES;
//    }
//    return NO;
//    }
    
}
