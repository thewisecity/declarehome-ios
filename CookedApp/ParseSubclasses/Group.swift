//
//  Group.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 10/14/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

class Group : PFObject, PFSubclassing {
    
    @NSManaged var name: String?
    @NSManaged var twitter: String?
    @NSManaged var facebook: String?
    @NSManaged var website: String?
    @NSManaged var state: String?
    @NSManaged var city: String?
    @NSManaged var address: String?
    @NSManaged var neighberhoods: String?
    @NSManaged var purpose: String?
    @NSManaged var membersRole: PFRole?
    @NSManaged var adminsRole: PFRole?
    @NSManaged var membersArray: [User]?
    @NSManaged var adminsArray: [User]?
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Group"
    }
}