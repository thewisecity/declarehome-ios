//
//  Message.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 10/14/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

class Message : PFObject, PFSubclassing {
    
    static var _BODY: String = "body"
    static var _GROUPS: String = "groups"
    static var _IS_ALERT: String = "isAlert"
    static var _AUTHOR: String = "author"
    static var _AUTHOR_ADMIN_ARRAY = "author.adminofArray"
    static var _AUTHOR_MEMBER_ARRAY = "author.memberOfArray"
    static var _CATEGORY: String = "category"
    
    static var NOTIFICATION_POST_MESSAGE_SUCCEEDED: String = "MessagePostSucceeded"
    static var NOTIFICATION_POST_MESSAGE_FAILED: String = "MessagePostFailed"
    
    @NSManaged var body: String?
    @NSManaged var isAlert: Bool
    @NSManaged var author: User?
    @NSManaged var groups: [Group]?
    @NSManaged var category: AlertCategory?
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            Group.registerSubclass()
            AlertCategory.registerSubclass()
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Message"
    }
    
    static func postNewMessage(user: User, group: Group, body: String) -> Void {
        let msg = Message(className: "Message")
        msg.body = body
        msg.author = user
        msg.groups = [group]
        msg.isAlert = false
        msg.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError?) -> Void in
            if let _ = error {
                // Error exists
                print("Error while saving message")
                NSNotificationCenter.defaultCenter().postNotificationName(NOTIFICATION_POST_MESSAGE_FAILED, object: nil)
                //TODO: Make analytics call here
                //    Analytics.with(App.getContext()).track("Message Creation Failed");
            } else {
                print("Message created")
                NSNotificationCenter.defaultCenter().postNotificationName(NOTIFICATION_POST_MESSAGE_SUCCEEDED, object: nil)
                //TODO: Make analytics call here
                //    Analytics.with(App.getContext()).track("Message Created");
            }
        }
    }
    
    static func postNewAlert(user: User, groups: [Group], body: String, category: AlertCategory) {
        let msg = Message(className: "Message")
        msg.body = body
        msg.author = user
        msg.groups = groups
        msg.isAlert = true
        msg.category = category
        msg.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError?) -> Void in
            if let _ = error {
                // Error exists
                print("Error while saving message")
                NSNotificationCenter.defaultCenter().postNotificationName(NOTIFICATION_POST_MESSAGE_FAILED, object: nil)
                Stats.TrackAlertCreationFailed()
            } else {
                print("Message created")
                NSNotificationCenter.defaultCenter().postNotificationName(NOTIFICATION_POST_MESSAGE_SUCCEEDED, object: nil)
                Stats.TrackAlertCreated()
            }
        }
    }
}