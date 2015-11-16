//
//  GroupCellWithButton.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 11/16/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

import UIKit


class GroupCellWithButton: GroupCell {
    
    var delegate : GroupCellDelegate?
    
    @IBOutlet weak var detailsButton : UIButton!
    @IBOutlet weak var loadingView : UIActivityIndicatorView!
    
    var userIsAdminOrMember : Bool = false {
        didSet{
            loadingView.hidden = true
            detailsButton.hidden = !userIsAdminOrMember
        }
    }
    
    override var group : Group! {
        didSet{
            group.fetchIfNeededInBackgroundWithBlock { (object:PFObject?, error:NSError?) -> Void in
                if let object = object {
                    self.nameLabel.text = self.group?.name
                    self.purposeLabel.text = self.group?.purpose
                    let user : User = PFUser.currentUser() as! User
                    self.userIsAdminOrMember = (self.group.isUserAdmin(user, forceServerContact: false) || self.group.isUserMember(user, forceServerContact: false))
                }
            }
        }
    }
    
    @IBAction func detailsButtonTapped(_: AnyObject) {
        delegate?.detailsButtonPressed(self)
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

