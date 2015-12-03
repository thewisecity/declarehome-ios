//
//  Notifications.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 11/30/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

class Notifications
{
    
    static let NEW_MESSAGES = "NewMessage";
    static let NEW_EVENTS = "NewEvent";
    static let ALERTS = "Alert";
    static let INVITATION_ACCEPTED = "InvitationAccepted";
    static let MEMBERSHIP_REQUEST = "MembershipRequest";
    static let INVITED_TO_GROUP = "InvitedToGroup";
    
    
    static func setSubscriptionForAllNotifs(subscribed: Bool) -> Void
    {
        if(subscribed == true)
        {
            if(PFUser.currentUser() != nil){
                let i = PFInstallation.currentInstallation()
                i.setObject(PFUser.currentUser()!, forKey: "user")
                i.saveInBackground()
            }
            setSubscriptionForNewEvents(subscribed)
            setSubscriptionForNewMessages(subscribed)
            setSubscriptionForAlerts(subscribed)
            setSubscriptionForInvitationAcceptedChannel(subscribed)
            setSubscriptionForMembershipRequested(subscribed)
            setSubscriptionForInvitedToGroup(subscribed)
        }
        else
        {
            let i = PFInstallation.currentInstallation()
            i.channels = []
            i.saveInBackground()
            
        }
        
    }
    
    static func setSubscriptionForMembershipRequested(subscribed: Bool) -> Void
    {
        let allGroupsQuery = getAllGroupsQuery()
        
        allGroupsQuery.findObjectsInBackgroundWithBlock { (groups:[PFObject]?, error: NSError?) -> Void in
            if (error != nil)
            {
                print(error?.localizedDescription)
            }
            else
            {
                for g:Group in groups as! [Group]
                {
                    setSubscriptionForMemberShipRequestedForGroup(subscribed, group: g)
                }
            }
        }
    }
    
    static func setSubscriptionForInvitationAcceptedChannel(subscribed: Bool) -> Void
    {
        let channel = INVITED_TO_GROUP + "_" + (PFUser.currentUser()?.objectId!)!
        if (subscribed)
        {
            subscribeInBackground(channel)
        }
        else
        {
            unsubscribeInbackground(channel)
        }
    }
    
    static func setSubscriptionForInvitedToGroup(subscribed: Bool) -> Void
    {
        let channel = INVITATION_ACCEPTED + "_" + (PFUser.currentUser()?.objectId!)!
        if (subscribed)
        {
            subscribeInBackground(channel)
        }
        else
        {
            unsubscribeInbackground(channel)
        }
    }
    
    static func setSubscriptionForAlerts(subscribed: Bool) -> Void
    {
        let allGroupsQuery = getAllGroupsQuery()
        
        allGroupsQuery.findObjectsInBackgroundWithBlock { (groups:[PFObject]?, error: NSError?) -> Void in
            if (error != nil)
            {
                print(error?.localizedDescription)
            }
            else
            {
                for g:Group in groups as! [Group]
                {
                    setSubscriptionForAlertsChannelForGroup(subscribed, group: g)
                }
            }
        }
    }
    
    static func setSubscriptionForNewEvents(subscribed: Bool) -> Void
    {
        let allGroupsQuery = getAllGroupsQuery()
        
        allGroupsQuery.findObjectsInBackgroundWithBlock { (groups:[PFObject]?, error: NSError?) -> Void in
            if (error != nil)
            {
                print(error?.localizedDescription)
            }
            else
            {
                for g:Group in groups as! [Group]
                {
                    
                    setSubscriptionForNewEventsChannelForGroup(subscribed, group: g)
                }
            }
        }
    }
    
    static func setSubscriptionForNewMessages(subscribed: Bool) -> Void
    {
        let allGroupsQuery = getAllGroupsQuery()
        
        allGroupsQuery.findObjectsInBackgroundWithBlock { (groups:[PFObject]?, error: NSError?) -> Void in
            if (error != nil)
            {
                print(error?.localizedDescription)
            }
            else
            {
                for g:Group in groups as! [Group]
                {
                    
                    setSubscriptionForNewMessagesChannelForGroup(subscribed, group: g)
                }
            }
        }
    }
    
    
    
    static func setSubscriptionForNewEventsChannelForGroup(subscribed: Bool, group: Group)
    {
        let channel = NEW_EVENTS + "_" + group.objectId!
        if (subscribed)
        {
            subscribeInBackground(channel)
        }
        else{
            unsubscribeInbackground(channel)
        }
    }
    
    static func setSubscriptionForNewMessagesChannelForGroup(subscribed: Bool, group: Group)
    {
        let channel = NEW_MESSAGES + "_" + group.objectId!
        if (subscribed)
        {
            subscribeInBackground(channel)
        }
        else{
            unsubscribeInbackground(channel)
        }
    }
    
    static func setSubscriptionForAlertsChannelForGroup(subscribed: Bool, group: Group)
    {
        let channel = ALERTS + "_" + group.objectId!
        if (subscribed)
        {
            subscribeInBackground(channel)
        }
        else{
            unsubscribeInbackground(channel)
        }
    }
    
    static func setSubscriptionForMemberShipRequestedForGroup(subscribed: Bool, group: Group)
    {
        let channel = MEMBERSHIP_REQUEST + "_" + group.objectId!
        if (subscribed)
        {
            subscribeInBackground(channel)
        }
        else{
            unsubscribeInbackground(channel)
        }
    }
    
    static func subscribeInBackground(channel: String)
    {
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.addUniqueObject(channel, forKey: "channels")
        currentInstallation.saveInBackground()
    }
    
    static func unsubscribeInbackground(channel: String)
    {
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.removeObject(channel, forKey: "channels")
        currentInstallation.saveInBackground()
    }
    
    static func getAllGroupsQuery() -> PFQuery
    {
        let user = PFUser.currentUser()
        
        do
        {
            try user?.fetchIfNeeded()
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
        }
        
        
        let adminOfQuery = PFUser.currentUser()?.relationForKey("adminOf").query()
        let memberOfQuery = PFUser.currentUser()?.relationForKey("memberOf").query()
        
        var queries : [PFQuery] = []
        if adminOfQuery != nil
        {
            queries.append(adminOfQuery!)
        }
        if memberOfQuery != nil
        {
            queries.append(memberOfQuery!)
        }
        let allGroupsQuery = PFQuery.orQueryWithSubqueries(queries)
        
        return allGroupsQuery
    }
    
    static func subscribeToNotifsForNewGroup(g: Group)
    {
        setSubscriptionForAlertsChannelForGroup(true, group: g)
        setSubscriptionForMemberShipRequestedForGroup(true, group: g)
        setSubscriptionForNewEventsChannelForGroup(true, group: g)
        setSubscriptionForNewMessagesChannelForGroup(true, group: g)
    }
}
