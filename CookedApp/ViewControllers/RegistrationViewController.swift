//
//  RegisterViewController.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 10/13/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var displayNameField : UITextField!
    @IBOutlet weak var emailField : UITextField!
    @IBOutlet weak var passwordField : UITextField!
    
    @IBOutlet weak var registerButton : UIButton!
    @IBOutlet weak var profilePicButton : UIButton!
    
    @IBOutlet weak var loadingView : UIView!
    
    let imagePicker = UIImagePickerController()
    
    var hasPickedImage:Bool = false
    
    var profilePicUploadFile:PFFile?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePicButton.layer.cornerRadius = 47 // Half of width set in storyboard xib
        profilePicButton.clipsToBounds = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loadImageButtonTapped(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .SavedPhotosAlbum
        imagePicker.delegate = self
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        profilePicButton.setBackgroundImage(image, forState: UIControlState.Normal)
        hasPickedImage = true
        let data = UIImageJPEGRepresentation(image, 0.5)
        profilePicUploadFile = PFFile(name: "profilePic", data: data!)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func attemptRegistration() -> Void {
        
        let userDisplayName = displayNameField.text as String!
        let userEmail = emailField.text as String!
        let userPassword = passwordField.text as String!

        
        if (validateEmail(userEmail) && validatePassword(userPassword) && validateDisplayName(userDisplayName) && hasPickedImage){
            loadingView.hidden = false
            profilePicUploadFile?.saveInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    self.loadingView.hidden = true
                    print("Error while uploading file")
                    print(error.localizedDescription)
                } else {
                    let user : PFUser = PFUser()
                    user.username = userEmail
                    user.password = userPassword
                    user.email = userEmail
                    user["displayName"] = userDisplayName
                    user["profilePic"] = self.profilePicUploadFile
                    
                    user.signUpInBackgroundWithBlock {
                        (succeeded: Bool, error: NSError?) -> Void in
                        if let error = error {
                            let errorString = error.localizedDescription // Show the errorString somewhere and let the user try again.
                            print(errorString)
                        } else {
                            self.segueToTabBarController()
                            print("Success!")
                        }
                        self.loadingView.hidden = true
                    }
                }
            }
        }
        
    }
    
    func segueToTabBarController() -> Void {
        self.navigationController?.popToRootViewControllerAnimated(false)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.segueToTabViewController()
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
