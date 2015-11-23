//
//  User.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 10/14/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

class User : PFUser {
    
    @NSManaged var displayName: String?
    @NSManaged var linkOne: String?
    @NSManaged var linkTwo: String?
    @NSManaged var linkThree: String?
    @NSManaged var profilePic: PFFile?
    @NSManaged var surname: String?
    @NSManaged var phoneNumber: String?
    @NSManaged var userDescription: String?
    @NSManaged var memberOfArray: [Group]?
    @NSManaged var adminOfArray: [Group]?
    
//    func getAdminGroups () -> [Group]? {
//        return nil;
//    }
//    
//    func getMemberGroups () -> [Group]? {
//        return nil;
//    }
    
    static var className = "User"
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
}