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
    
    static func createGroup(name:String?, purpose:String?, neighberhoods:String?, address:String?, city:String?, state:String?, website:String?, facebook:String?, twitter:String?, callback: (Bool, NSError?) -> Void) -> Void
    {
        let group = Group()
        group.name = name
        group.purpose = purpose
        group.neighberhoods = neighberhoods
        group.address = address
        group.city = city
        group.state = state
        group.website = website
        group.facebook = facebook
        group.twitter = twitter
        
        group.saveInBackgroundWithBlock(callback)
    }
}

//
//{ (success:Bool, error:NSError?) -> Void in
//    if let _ = error
//    {
//        print("Error while saving group")
//        //Error while saving
//        //TODO: Alert user to this error
//        //TODO: Analytics callback for error
//    }
//    else
//    {
//        print("Group saved")
//        //TODO: Update notifications
//        //Notifications.subscribeToNotifsForNewGroup(group);
//        
//        // TODO: Analytics callback
//        //    Analytics.with(App.getContext()).track("Group Created",
//        //    new Properties().
//        //    putValue(_NAME, name).
//        //    putValue(_PURPOSE, purpose).
//        //    putValue(_NEIGHBERHOODS, neighberhoods).
//        //    putValue(_ADDRESS, address).
//        //    putValue(_STATE, state).
//        //    putValue(_CITY, city).
//        //    putValue(_WEBSITE, website).
//        //    putValue(_TWITTER, twitter).
//        //    putValue(_FACEBOOK, facebook));
//        //    }
//    }
//}
