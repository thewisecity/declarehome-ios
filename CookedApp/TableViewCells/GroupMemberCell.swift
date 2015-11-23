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
                
                //TODO: IF user is awaiting approval and current user is admin
                //  approveButton.hidden = false
                //else
                //  approveButton.hidden = true
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
