//
//  AlertCategory.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 10/14/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

class AlertCategory : PFObject, PFSubclassing {
    
    static let className = "AlertCategory"
    
    @NSManaged var title: String
    @NSManaged var textR: Double
    @NSManaged var textG: Double
    @NSManaged var textB: Double
    @NSManaged var backgroundR: Double
    @NSManaged var backgroundG: Double
    @NSManaged var backgroundB: Double
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "AlertCategory"
    }
    
    func getAttributedTitleString() -> NSMutableAttributedString
    {
        let attrStr = NSMutableAttributedString(string: self.title)
        
        let fgColor = UIColor(
            red: CGFloat(textR / 255.0),
            green: CGFloat(textG / 255.0),
            blue: CGFloat(textB / 255.0), alpha: 1.0)

        let bgColor = UIColor(
            red: CGFloat(backgroundR / 255.0),
            green: CGFloat(backgroundG / 255.0),
            blue: CGFloat(backgroundB / 255.0),
            alpha: 1.0)
        
        attrStr.addAttribute(
            NSForegroundColorAttributeName,
            value: fgColor,
            range: NSRange(location: 0, length: self.title.characters.count))
        
        attrStr.addAttribute(
            NSBackgroundColorAttributeName,
            value: bgColor,
            range: NSRange(location: 0, length: self.title.characters.count))
        
        return attrStr
    }
    
}