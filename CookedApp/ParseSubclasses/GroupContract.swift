//
//  GroupContract.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 11/18/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

class GroupContract : PFObject, PFSubclassing {
    
    static let className = "GroupContract"
    
    static let _INVITEE_EMAIL = "inviteeEmail"
    static let _INVITEE = "invitee"
    static let _INVITED_BY = "invitedBy"
    static let _GROUP = "group"
    static let _STATUS = "status"
    
    static let STATUS_USER_REQUESTED = "UserRequested";
    static let STATUS_USER_INVITED = "UserInvited";
    static let STATUS_SIGNED = "Signed";
    
    @NSManaged var inviteeEmail: String
    @NSManaged var invitee: String
    @NSManaged var invitedBy: String
    @NSManaged var group: String
    @NSManaged var status: String
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "GroupContract"
    }
    
}
