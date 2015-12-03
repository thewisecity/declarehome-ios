//
//  CreateNewGroupViewController.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 11/12/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

import UIKit

class CreateNewGroupViewController: UIViewController, UITextFieldDelegate {
    
    static let _NAME = "name";
    static private let _PURPOSE = "purpose";
    static private let _NEIGHBERHOODS = "neighberhoods";
    static private let _ADDRESS = "address";
    static private let _STATE = "state";
    static private let _CITY = "city";
    static private let _WEBSITE = "website";
    static private let _FACEBOOK = "facebook";
    static private let _TWITTER = "twitter";
    static private let _MEMBERS_ARRAY = "membersArray";
    static private let _ADMINS_ARRAY = "adminsArray";
    static private let _MEMBERS_ROLE = "membersRole";
    static private let _ADMINS_ROLE = "adminsRole";
    
    @IBOutlet weak var nameTextField : UITextField!
    @IBOutlet weak var purposeTextField : UITextField!
    @IBOutlet weak var neighberhoodsTextField : UITextField!
    @IBOutlet weak var addressTextField : UITextField!
    @IBOutlet weak var cityTextField : UITextField!
    @IBOutlet weak var stateOrProvinceTextField : UITextField!
    @IBOutlet weak var websiteTextField : UITextField!
    @IBOutlet weak var facebookTextField : UITextField!
    @IBOutlet weak var twitterTextField : UITextField!
    
    @IBOutlet weak var loadingView : UIView!
    
    var frameIsRaisedForKeyboard : Bool = false
    var selectedTextField : UITextField?
    
    var positionForActiveTextView : CGPoint = CGPointMake(0, 0)
    
    var barButton = UIBarButtonItem(title: "Create", style: UIBarButtonItemStyle.Plain, target: nil, action: "clickedDone:")
    
    var screenTooSmall = false
    
    
    @IBOutlet weak var doneButton : UIButton!
    
    @IBAction func clickedDone(sender: UIButton)
    {
        if (validateGroupName(nameTextField.text) && validateGroupPurpose(purposeTextField.text))
        {
            loadingView.hidden = false
            Group.createGroup(nameTextField.text, purpose: purposeTextField.text, neighberhoods: neighberhoodsTextField.text, address: addressTextField.text, city: cityTextField.text, state: stateOrProvinceTextField.text, website: websiteTextField.text, facebook: facebookTextField.text, twitter: twitterTextField.text, callback: onGroupCreationFinished)
        }
        else
        {
            // Something was invalid
            //TODO: Error message or popup here?
        }
        
    }
    
    func configureDoneButton() {
        if (validateGroupName(nameTextField.text) && validateGroupPurpose(purposeTextField.text))
        {
            barButton.enabled = true
        }
        else
        {
            barButton.enabled = false
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "configureDoneButton", name: UITextFieldTextDidChangeNotification, object: nameTextField)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "configureDoneButton", name: UITextFieldTextDidChangeNotification, object: purposeTextField)
        
        
        
        
        Stats.ScreenCreateGroup()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func onGroupCreationFinished (group: Group?, success:Bool, error:NSError?) -> Void
    {
        loadingView.hidden = true
        if let _ = error
        {
            print("Error while saving group")
            //Error while saving
            //TODO: Alert user to this error
            Stats.TrackGroupCreationFailed()
        }
        else
        {
            print("Group saved")
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.dismissPresentedViewControllerAndReloadGroups()
            
            Notifications.subscribeToNotifsForNewGroup(group!)
            
            let props = [
                CreateNewGroupViewController._NAME : (group?.name)!,
                CreateNewGroupViewController._PURPOSE : (group?.purpose)!,
                CreateNewGroupViewController._NEIGHBERHOODS : (group?.neighberhoods)!,
                CreateNewGroupViewController._ADDRESS : (group?.address)!,
                CreateNewGroupViewController._STATE : (group?.state)!,
                CreateNewGroupViewController._CITY : (group?.city)!,
                CreateNewGroupViewController._WEBSITE : (group?.website)!,
                CreateNewGroupViewController._TWITTER : (group?.twitter)!,
                CreateNewGroupViewController._FACEBOOK : (group?.facebook)!
            ]
            
            Stats.TrackGroupCreated(props)
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        selectedTextField = textField    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        selectedTextField = nil
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        print ("Keyboard will show check")
        
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()

        if(twitterTextField.frame.origin.y + (keyboardFrame?.height)! > (view.frame.size.height ))
        {
            screenTooSmall = true
        }
        
        if(screenTooSmall)
        {
            
            // If were moving 'down' the list, only change view position if bottom view isn't visible
            // If we're moving 'up' the list, only change view position if top view isn't visible
            
            let topFrame =  nameTextField.frame
            let botFrame = twitterTextField.frame
            
            var frame = self.view.frame
            
            var first = findFirstResponder()
            
            if(first != nil && first!.isKindOfClass(UITextField))
            {
                
                let topBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height + self.navigationController!.navigationBar.frame.size.height
                
                
                var diff = first!.frame.origin.y - positionForActiveTextView.y - topBarHeight
                
                if diff < 0
                {
                    diff = 0
                }
                
                //Check if we're moving down
                if (diff > abs(frame.origin.y))
                {
                    //We're moving down the page
                    //Now check if the last edit text field shouldn't already be visible
                    let positionInFrameFromBottom = (view.frame.height - twitterTextField.frame.origin.y)
                    //Need to see if the keyboardHeight is greater than the original position of the field plus any work already done to make it visible
                    if (positionInFrameFromBottom + twitterTextField.frame.height + abs(view.frame.origin.y) > keyboardFrame?.height )
                    {
                        // Should already be visible, so zero out our difference
                        diff = abs(view.frame.origin.y)
                    }
                }
                
                frame = CGRect(x: frame.origin.x, y: -diff, width: frame.size.width, height: frame.size.height)
                
                UIView.beginAnimations(nil, context: nil)
                
                UIView.setAnimationDuration(0.32)
                UIView.setAnimationCurve(UIViewAnimationCurve.EaseOut)
                self.view.frame = frame
                
                UIView.commitAnimations()
                
                frameIsRaisedForKeyboard = true
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        if frameIsRaisedForKeyboard == true
        {
            
            print("Keyboard will hide")
            var frame = self.view.frame
            frame = CGRect(x: 0, y: 0, width: frame.size.width, height: UIScreen.mainScreen().bounds.size.height)
            
            UIView.beginAnimations(nil, context: nil)
            
            UIView.setAnimationDuration(0.32)
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseOut)
            
            self.view.frame = frame
//            self.scrollView.frame = frame
            
            UIView.commitAnimations()
            
            frameIsRaisedForKeyboard = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        positionForActiveTextView = nameTextField.frame.origin
        
        barButton.target = self
        barButton.enabled = false
        
        self.navigationItem.setRightBarButtonItem(barButton, animated: true)
        
        let f = view.frame
        
        view.frame = CGRectMake(f.origin.x, f.origin.y, f.size.width, f.size.height + 150)
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        view.sizeToFit()
        
        if(twitterTextField.frame.origin.y > view.frame.size.height)
        {
            screenTooSmall = true
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func findFirstResponder() -> UIView?
    {
        if (self.view.isFirstResponder()) {
            return self.view;
        }
        for subView : UIView in self.view.subviews {
            if (subView.isFirstResponder()) {
                return subView;
            }
        }
        return nil;
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
