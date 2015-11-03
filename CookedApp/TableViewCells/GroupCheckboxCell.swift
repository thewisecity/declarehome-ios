//
//  GroupCheckboxCell.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 11/2/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

import UIKit

class GroupCheckboxCell: PFTableViewCell{
    
    @IBOutlet weak var purposeLabel : UILabel!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var checkSwitch : UISwitch!
    
    var delegate : GroupCheckboxDelegate?
    
    var group : Group!
        {
        didSet
        {
            group.fetchIfNeededInBackgroundWithBlock { (object:PFObject?, error:NSError?) -> Void in
                if let _ = object
                {
                    self.nameLabel.text = self.group?.name
                    self.purposeLabel.text = self.group?.purpose
                }
            }
        }
    }
    
    @IBAction func checkboxSwitched(sender: UISwitch)
    {
        if (sender.on) {
            print("Sender is on")
        }
        else
        {
            print("Sender is off")
        }
        
        delegate?.groupCheckChanged(self, isChecked: sender.on)
        
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
