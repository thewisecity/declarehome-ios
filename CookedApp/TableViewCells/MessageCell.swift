//
//  MessageCell.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 10/14/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

import UIKit

class MessageCell: PFTableViewCell {
    
    @IBOutlet weak var authorName : UILabel!
    @IBOutlet weak var messageText : UILabel!
    
    var message : Message! {
        didSet{
            if let user = message?.author {
                authorName.text = user.displayName
            }
            
            // Remove all attributes and text
            messageText.attributedText = NSAttributedString(string: "S")
            messageText.text = ""
            
            if let category: AlertCategory = message?.category
            {
                let str = category.getAttributedTitleString()
                str.appendAttributedString(NSAttributedString(string: " " + (message?.body)!))
                messageText.attributedText = str
            }
            else
            {
                messageText.text = message?.body
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
