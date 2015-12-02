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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
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
        
        let keyboardCoversField = (((selectedTextField?.frame.origin.y )! + (selectedTextField?.frame.height)!) > keyboardFrame!.height)
        
        let raisingKeyboardWouldForceSelectedTextfieldOffScreen = ((selectedTextField?.frame.origin.y )! <  keyboardFrame!.height)
        
        let doneButtonFrame = doneButton.convertRect(doneButton.bounds, toView: view)
        
        
        let keyboardCoversDoneButton = ((doneButtonFrame.origin.y  + doneButtonFrame.height) > keyboardFrame!.height)
        
        // First check if we should raise the keyboard now if it's not raised
        if (frameIsRaisedForKeyboard == false && keyboardCoversField) ||
            (frameIsRaisedForKeyboard == false && raisingKeyboardWouldForceSelectedTextfieldOffScreen == false && keyboardCoversDoneButton == true)
        {
            print("Keyboard will show")
            
            let keyboardFrame = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
            
            var frame = self.view.frame
            
            
            
            var     amountToRaiseKeyboard = (doneButtonFrame.origin.y - (view.frame.height - (keyboardFrame?.height)! ))
            
            if amountToRaiseKeyboard > 1
            {
                amountToRaiseKeyboard += 45
            }
            
            frame = CGRect(x: frame.origin.x, y: frame.origin.y - amountToRaiseKeyboard, width: frame.size.width, height: frame.size.height)
            
            UIView.beginAnimations(nil, context: nil)
            
            UIView.setAnimationDuration(0.32)
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseOut)
            self.view.frame = frame
//            self.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height - keyboardFrame!.height)
            
            UIView.commitAnimations()
            
            frameIsRaisedForKeyboard = true
        }
        else if frameIsRaisedForKeyboard == true && keyboardCoversField == false
        {
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
