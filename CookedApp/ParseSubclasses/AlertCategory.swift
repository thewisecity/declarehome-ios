//
//  AlertCategory.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 10/14/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

class AlertCategory : PFObject, PFSubclassing {
    
    @NSManaged var title: String
    @NSManaged var textR: Int
    @NSManaged var textG: Int
    @NSManaged var textB: Int
    @NSManaged var backgroundR: Int
    @NSManaged var backgroundG: Int
    @NSManaged var backgroundB: Int
    
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
}