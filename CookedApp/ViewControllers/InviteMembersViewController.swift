//
//  InviteMembersViewController.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 12/4/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

import UIKit

class InviteMembersViewController: UIViewController {
    
    @IBOutlet weak var groupName : UILabel?
    @IBOutlet weak var inviteeEmailAddress : UITextField?
    @IBOutlet weak var sendButton : UIButton?
    @IBOutlet weak var loadingView : UIView!
    
    var group : Group? {
        didSet {
            refreshInfo()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView.hidden = true
        self.navigationController?.navigationBar.translucent = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshInfo()
    {
        groupName?.text = group?.name
    }
    
    @IBAction func sendInvite(sender: UIButton)
    {
        loadingView.hidden = false
        PFCloud.callFunctionInBackground("inviteToGroup", withParameters: ["groupId" : (group?.objectId)!, "inviteeEmail" : (inviteeEmailAddress?.text)!]) { (result: AnyObject?, e : NSError?) -> Void in
            
            self.loadingView.hidden = true
            if (e != nil)
            {
                // Error
                print("Error while sending invite")
                //TODO: Alert popup?
            }
            else
            {
                self.inviteeEmailAddress?.text = nil
                //SUCCESS!
                //TODO: Alert popup?
                
            }
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

}
