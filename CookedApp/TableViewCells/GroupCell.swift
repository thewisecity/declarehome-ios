//
//  GroupCellTableViewCell.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 10/13/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

import UIKit

class GroupCell: PFTableViewCell {
    
    @IBOutlet weak var purposeLabel : UILabel!
    @IBOutlet weak var nameLabel : UILabel!
    
    
    var group : Group! {
        didSet{
            group.fetchIfNeededInBackgroundWithBlock { (object:PFObject?, error:NSError?) -> Void in
                if let object = object {
                    self.nameLabel.text = self.group?.name
                    self.purposeLabel.text = self.group?.purpose
                }
            }
        }
    }
    
//    override func layoutSubviews() {
//        nameLabel.text = group?.name
//        purposeLabel.text = group?.purpose
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

