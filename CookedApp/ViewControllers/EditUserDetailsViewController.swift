//
//  EditUserDetailsViewController.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 11/9/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

import UIKit

class EditUserDetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var scrollView : UIScrollView!
    var contentContainer : UIView!
    
    var profilePicture : PFImageView!
    
    var loadingView : UIView!
    
    let imagePicker = UIImagePickerController()
    
    var hasPickedImage:Bool = false
    
    var profilePicUploadFile:PFFile?
    
    var uploadButton : UIButton!
    var doneButton : UIButton!
    
    var nameLabel : UILabel!
    var emailLabel : UILabel!
    var mobileLabel : UILabel!
    var link1Label : UILabel!
    var link2Label : UILabel!
    var link3Label : UILabel!
    var descriptionLabel : UILabel!
    
    var nameTextField : UITextField!
    var emailTextField : UITextField!
    var mobileTextField : UITextField!
    var link1TextField : UITextField!
    var link2TextField : UITextField!
    var link3TextField : UITextField!
    var descriptionTextView : UITextView!
    
    let leftMargin = 14 as CGFloat
    let rightMargin = 14 as CGFloat
    let topMargin = 20 as CGFloat
    
    var keyboardIsShowing = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
        
        view.addSubview(scrollView)
        
        view.backgroundColor = UIColor.whiteColor()
        
        scrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, 680)
        
        contentContainer = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 680))
        contentContainer.backgroundColor = UIColor.whiteColor()
        
        loadingView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 680))
        loadingView.backgroundColor = UIColor.whiteColor()
        let spinner = UIActivityIndicatorView(frame: CGRectMake(UIScreen.mainScreen().bounds.width / 2 - 25, UIScreen.mainScreen().bounds.height / 2 - 25, 50, 50))
        loadingView.addSubview(spinner)
        spinner.startAnimating()
        loadingView.backgroundColor = UIColor(white: 0.1, alpha: 0.1)
        loadingView.hidden = true

        scrollView.addSubview(contentContainer)
        
        profilePicture = PFImageView(frame: CGRectMake(leftMargin, topMargin, 120, 120))
        profilePicture.image = UIImage(named: "DefaultBioPic")
        roundImageCorners(profilePicture)
        
        let textfieldWidth = contentContainer.frame.width - leftMargin - rightMargin
        
        uploadButton = UIButton(frame:CGRectMake(142, 98, 65, 30))
        uploadButton.setTitle("Upload", forState: .Normal)
        uploadButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        uploadButton.addTarget(self, action: "uploadNewProfilePic", forControlEvents: .TouchDown)
        
        nameLabel = UILabel(frame:CGRectMake(14,146,100,21))
        nameLabel.text = "Name"


        emailLabel = UILabel(frame:CGRectMake(14,200,100,21))
        emailLabel.text = "Email"
        
        mobileLabel = UILabel(frame:CGRectMake(14,254,100,21))
        mobileLabel.text = "Mobile Phone"
        
        link1Label = UILabel(frame:CGRectMake(14,308,100,21))
        link1Label.text = "Link"
        
        link2Label = UILabel(frame:CGRectMake(14,362,100,21))
        link2Label.text = "Link"
        
        link3Label = UILabel(frame:CGRectMake(14,416,100,21))
        link3Label.text = "Link"
        
        descriptionLabel = UILabel(frame:CGRectMake(14,484,200,21))
        descriptionLabel.text = "Short Description (200 chars max)"
        
        nameTextField = UITextField(frame: CGRectMake(14, 168, textfieldWidth, 30))
        nameTextField.borderStyle = .RoundedRect
        
        emailTextField = UITextField(frame: CGRectMake(14, 222, textfieldWidth, 30))
        emailTextField.borderStyle = .RoundedRect
        
        mobileTextField = UITextField(frame: CGRectMake(14, 276, textfieldWidth, 30))
        mobileTextField.borderStyle = .RoundedRect
        
        link1TextField = UITextField(frame: CGRectMake(14, 330, textfieldWidth, 30))
        link1TextField.borderStyle = .RoundedRect
        
        link2TextField = UITextField(frame: CGRectMake(14, 384, textfieldWidth, 30))
        link2TextField.borderStyle = .RoundedRect
        
        link3TextField = UITextField(frame: CGRectMake(14, 438, textfieldWidth, 30))
        link3TextField.borderStyle = .RoundedRect
        
        descriptionTextView = UITextView(frame: CGRectMake(14, 506, textfieldWidth, 60))
        descriptionTextView.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.1)
        
        doneButton = UIButton(frame: CGRectMake(contentContainer.frame.width / 2 - 18, 586, 50, 27))
        doneButton.setTitle("Done", forState: .Normal)
        doneButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        doneButton.addTarget(self, action: "submitNewUserInfo", forControlEvents: .TouchDown)   
        
        
        styleLabel(nameLabel)
        styleLabel(emailLabel)
        styleLabel(mobileLabel)
        styleLabel(link1Label)
        styleLabel(link2Label)
        styleLabel(link3Label)
        styleLabel(descriptionLabel)
        
        contentContainer.addSubview(profilePicture)
        contentContainer.addSubview(uploadButton)
        
        contentContainer.addSubview(nameLabel)
        contentContainer.addSubview(emailLabel)
        contentContainer.addSubview(mobileLabel)
        contentContainer.addSubview(link1Label)
        contentContainer.addSubview(link2Label)
        contentContainer.addSubview(link3Label)
        contentContainer.addSubview(descriptionLabel)
        
        contentContainer.addSubview(nameTextField)
        contentContainer.addSubview(emailTextField)
        contentContainer.addSubview(mobileTextField)
        contentContainer.addSubview(link1TextField)
        contentContainer.addSubview(link2TextField)
        contentContainer.addSubview(link3TextField)
        contentContainer.addSubview(descriptionTextView)
        
        
        contentContainer.addSubview(doneButton)
        contentContainer.addSubview(loadingView)
        
        var user = PFUser.currentUser() as! User
        profilePicture.file = user.profilePic
        profilePicture.loadInBackground()
        nameTextField.text = user.displayName
        emailTextField.text = user.email
        mobileTextField.text = user.phoneNumber
        link1TextField.text = user.linkOne
        link2TextField.text = user.linkTwo
        link3TextField.text = user.linkThree
        descriptionTextView.text = user.userDescription
        
    }
    
    private func styleLabel(label: UILabel)
    {
        label.font = UIFont.systemFontOfSize(11)
        label.textColor = UIColor.grayColor()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func uploadNewProfilePic() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .SavedPhotosAlbum
        imagePicker.delegate = self
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        
        if keyboardIsShowing == false
        {
            print("Keyboard will show")
            
            let keyboardFrame = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
            
            var frame = self.view.frame
            
            frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: frame.size.height)
            
            UIView.beginAnimations(nil, context: nil)
            
            UIView.setAnimationDuration(0.32)
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseOut)
            self.view.frame = frame
            scrollView.frame = CGRectMake(0, 0, scrollView.frame.width, scrollView.frame.height - keyboardFrame!.height)
            
            UIView.commitAnimations()
            
            keyboardIsShowing = true
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        if keyboardIsShowing == true
        {
            
            print("Keyboard will hide")
            var frame = self.view.frame
            frame = CGRect(x: 0, y: 0, width: frame.size.width, height: UIScreen.mainScreen().bounds.size.height)
            
            UIView.beginAnimations(nil, context: nil)
            
            UIView.setAnimationDuration(0.32)
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseOut)
            
            self.view.frame = frame
            self.scrollView.frame = frame
            
            UIView.commitAnimations()
            
            keyboardIsShowing = false
        }
    }
    
    func submitNewUserInfo()
    {
        if (validateDisplayName(nameTextField.text) && validateEmail(emailTextField.text) && validatePhoneNumber(mobileTextField.text))
        {
            loadingView.hidden = false
            var user = PFUser.currentUser() as! User
            user.displayName = nameTextField.text
            user.email = emailTextField.text
            user.phoneNumber = mobileTextField.text
            user.linkOne = link1TextField.text
            user.linkTwo = link2TextField.text
            user.linkThree = link3TextField.text
            user.userDescription = descriptionTextView.text
            if (hasPickedImage)
            {
               user.profilePic = profilePicUploadFile
            }
            user.saveInBackgroundWithBlock({ ( success:Bool, error: NSError?) -> Void in
                if(success)
                {
                    print("Saved user")
                    //TODO: Launch alert with success
                    self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                }
                else
                {
                    //TODO: Launch alert with failure message
                    print("Error saving user")
                }
            })
        }
        else
        {
            // TODO: Launch thing saying info was invalid
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        profilePicture.image = image;
//        profilePicture.setBackgroundImage(image, forState: UIControlState.Normal)
        hasPickedImage = true
        let data = UIImageJPEGRepresentation(image, 0.5)
        profilePicUploadFile = PFFile(name: "profilePic", data: data!)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }


}
