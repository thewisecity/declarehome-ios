//
//  AlertCategoryCell.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 10/20/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

import UIKit

class AlertCategoryCell: PFTableViewCell {
    
    @IBOutlet weak var alertTitle : UILabel!
    
    var category : AlertCategory! {
        didSet{
            if let category = category {
//                self.alertTitle.text = self.category?.title
                self.alertTitle.attributedText = self.category?.getAttributedTitleString()
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

