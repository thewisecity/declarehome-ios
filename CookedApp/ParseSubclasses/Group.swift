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
    
    static func createGroup(name:String?, purpose:String?, neighberhoods:String?, address:String?, city:String?, state:String?, website:String?, facebook:String?, twitter:String?, callback: (Group, Bool, NSError?) -> Void) -> Void
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
        
        group.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            callback(group, success, error)
        }
    }
    
    func isCurrentUserAdmin() -> Bool
    {
        return isUserAdmin(PFUser.currentUser() as! User, forceServerContact: false)
    }
    
    func isCurrentUserMember() -> Bool
    {
        return isUserMember(PFUser.currentUser() as! User, forceServerContact: false)
    }
    
    func isUserAdmin(user: User, forceServerContact : Bool) -> Bool
    {
        var userIsAdmin : Bool = false
        
        do {
            
            if forceServerContact == true
            {
                try self.fetch()
            }
            else
            {
                try self.fetchIfNeeded()
            }
            
            let currentUser = PFUser.currentUser() as! User
            
            if let _ = adminsArray
            {
                for theUser in adminsArray!
                {
                    if theUser.objectId == currentUser.objectId
                    {
                        userIsAdmin = true
                        break
                    }
                }
            }
            
        } catch let error as NSError {
            print("Error")
            print(error.localizedDescription)
        }
        
        return userIsAdmin
    }

    func isUserMember(user: User, forceServerContact : Bool) -> Bool
    {
        var userIsMember : Bool = false
        
        do {
            
            if forceServerContact == true
            {
                try self.fetch()
            }
            else
            {
                try self.fetchIfNeeded()
            }
            
            let currentUser = PFUser.currentUser() as! User
            
            if let _ = membersArray
            {
                for theUser in membersArray!
                {
                    if theUser.objectId == currentUser.objectId
                    {
                        userIsMember = true
                        break
                    }
                }
            }
            
            
        } catch let error as NSError {
            print("Error")
            print(error.localizedDescription)
        }
        
        return userIsMember
    }
    
}
