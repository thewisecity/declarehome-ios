//
//  GroupMemberCell.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 11/18/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

import UIKit

class GroupMemberCell: PFTableViewCell {
    
    @IBOutlet weak var username : UILabel!
    @IBOutlet weak var profilePic : PFImageView!
    @IBOutlet weak var approveButton : UIButton!
    @IBOutlet weak var loadingIndicator : UIActivityIndicatorView!
    
    var group : Group!
        {
        didSet
        {
            configureForInvitationStatus()
        }
    }
    
    var user : User!
        {
        didSet
        {
            if let _ = user
            {
                username.text = user?.displayName
                if let _ = user?.profilePic
                {
                    profilePic.file = user?.profilePic
                    profilePic.loadInBackground()
                }
                else
                {
                    profilePic.file = nil
                }
                
                approveButton.hidden = true
                loadingIndicator.hidden = true
                
                configureForInvitationStatus()
            }
            else
            {
                loadingIndicator.hidden = false
                approveButton.hidden = true
                profilePic.hidden = true
                username.text = "Loading..."
            }
        }
    }
    
    func configureForInvitationStatus()
    {
        if(group != nil && user != nil){
            let currentUserIsAdmin = group?.isCurrentUserAdmin()
            let userIsInvitee = (group?.isUserMember(user, forceServerContact: false) == false && group?.isUserAdmin(user, forceServerContact: false) == false)
            
            //If the current user is an admin of this group and the user for this view is an invitee, show the 'Approve' button, else hide it
            if (!(userIsInvitee == true && currentUserIsAdmin == true))
            {
                approveButton.hidden = true
                approveButton.removeTarget(self, action: "approveNewMember", forControlEvents: UIControlEvents.TouchUpInside)
            }
            else
            {
                approveButton.hidden = false
                approveButton.addTarget(self, action: "approveNewMember", forControlEvents: UIControlEvents.TouchUpInside)
            }
            
            if userIsInvitee // user is invitee
            {
                username.text?.appendContentsOf(" (pending)")
            }

        }
    }
    
    func approveNewMember()
    {
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
        approveButton.hidden = true
        PFCloud.callFunctionInBackground("approveMembershipForGroup", withParameters: ["groupId" : (group.objectId)!, "inviteeId" : user.objectId!]) { (response: AnyObject?, error : NSError?) -> Void in
            
            self.loadingIndicator.stopAnimating()

            if (error != nil) //Error
            {
                //TODO: Alert error here?
                self.approveButton.hidden = false
            }
            else //Success!
            {
                self.group.addMember(self.user)
            }
        }
        loadingIndicator.startAnimating()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
