//
//  Stats.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 11/30/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//


class Stats {

    static let ALERTS_SCREEN = "AlertsScreen"
    static let MESSAGE_WALL_CATEGORY = "MessageWallCategory"
    static let MESSAGE_WALL_SCREEN = "MessageWallScreen"
    static let CREATE_GROUP_SCREEN = "CreateGroupScreen"
    static let GROUP_DETAILS_CATEGORY = "GroupDetailsCategory"
    static let GROUP_DETAILS_SCREEN = "GroupDetailsScreen"
    static let LOGIN_SCREEN = "LoginScreen"
    static let REGISTRATION_SCREEN = "RegistrationScreen"
    static let MY_GROUPS_SCREEN = "My_Groups_Screen"
    static let ALL_GROUPS_SCREEN = "All_Groups_Screen"
    static let EVENTS_SCREEN = "EventsScreen"
    
    static func TrackBeganMessageCreation() -> Void
    {
        SEGAnalytics.sharedAnalytics().track("Began Message Creation")
    }
    
    static func TrackCancelledMessageCreation() -> Void
    {
        SEGAnalytics.sharedAnalytics().track("Cancelled Message Creation")
    }
    
    static func TrackOpenedNewMessageMenu() -> Void
    {
        SEGAnalytics.sharedAnalytics().track("Opened New Message Menu")
    }
    
    static func TrackClosedNewMessageMenu() -> Void
    {
        SEGAnalytics.sharedAnalytics().track("Closed New Message Menu")
    }

    static func TrackBeganAlertCreation() -> Void
    {
        SEGAnalytics.sharedAnalytics().track("Began Alert Creation")
    }

    static func TrackAttemptingGroupCreation() -> Void
    {
        SEGAnalytics.sharedAnalytics().track("Attempting Group Creation")
    }

    static func TrackGroupCreationCancelled() -> Void
    {
        SEGAnalytics.sharedAnalytics().track("Group Creation Cancelled")
    }

    static func TrackApplicationStarted() -> Void
    {
        SEGAnalytics.sharedAnalytics().track("Application Started")
    }

    static func ScreenCreateGroup() -> Void
    {
        SEGAnalytics.sharedAnalytics().screen(CREATE_GROUP_SCREEN)
    }
    
    static func ScreenGroupDetails(props: [NSObject : AnyObject]!) -> Void
    {
        SEGAnalytics.sharedAnalytics().screen(GROUP_DETAILS_SCREEN, properties: props)
    }
    
    static func ScreenAllGroups() -> Void
    {
        SEGAnalytics.sharedAnalytics().screen(ALL_GROUPS_SCREEN)
    }

    static func ScreenMessageWall(props: [NSObject : AnyObject]!) -> Void
    {
        SEGAnalytics.sharedAnalytics().screen(MESSAGE_WALL_SCREEN, properties: props)
    }
    
    static func ScreenMyGroups() -> Void
    {
        SEGAnalytics.sharedAnalytics().screen(MY_GROUPS_SCREEN)
    }
    
    static func ScreenEvents() -> Void
    {
        SEGAnalytics.sharedAnalytics().screen(EVENTS_SCREEN)
    }
    
    static func TrackRegistrationSuccess()
    {
        SEGAnalytics.sharedAnalytics().track("Registration Success");
    }
    
    static func TrackRegistrationFailed()
    {
        SEGAnalytics.sharedAnalytics().track("Registration Failed");
    }
    
    static func TrackRegistrationPicUploadFailed()
    {
        SEGAnalytics.sharedAnalytics().track("Registration Pic Upload Failed");
    }
    
    static func TrackRegistrationAttempt(){
        SEGAnalytics.sharedAnalytics().track("Registration Attempt");
    }
    
    static func TrackInvalidRegistrationInfo(){
        SEGAnalytics.sharedAnalytics().track("Invalid Registration Info");
    }

    static func TrackLoginSuccess() -> Void
    {
        SEGAnalytics.sharedAnalytics().track("Login Success")
    }
    
    static func TrackLoginFailed() -> Void
    {
        SEGAnalytics.sharedAnalytics().track("Login Failed")
    }
    
    static func ScreenLogin() -> Void
    {
        SEGAnalytics.sharedAnalytics().screen(LOGIN_SCREEN)
    }
    
    static func ScreenRegistration() -> Void
    {
        SEGAnalytics.sharedAnalytics().screen(REGISTRATION_SCREEN)
    }
    
    static func AliasAndIdentifyUser()
    {
        SEGAnalytics.sharedAnalytics().alias(PFUser.currentUser()?.objectId)
        SEGAnalytics.sharedAnalytics().identify(PFUser.currentUser()?.objectId,
            traits: ["name" : (PFUser.currentUser()?.valueForKey("displayName") as! String),
                    "email" : (PFUser.currentUser()?.email as String!)])
    }
    
    static func ScreenAlerts() -> Void
    {
        SEGAnalytics.sharedAnalytics().screen(ALERTS_SCREEN)
    }

    
    static func TrackLoginAttempt() -> Void
    {
        SEGAnalytics.sharedAnalytics().track("Login Attempt")
    }

    
    static func TrackGroupCreationFailed() -> Void
    {
        SEGAnalytics.sharedAnalytics().track("Group Creation Failed")
    }
    
    static func TrackGroupCreated(props : [NSObject : AnyObject]!) -> Void
    {
        SEGAnalytics.sharedAnalytics().track("Group Created", properties: props)
    }
    
    static func TrackAlertCreationFailed() -> Void
    {
        SEGAnalytics.sharedAnalytics().track("Alert Creation Failed")
    }
    
    
    static func TrackMessageCreationFailed() -> Void
    {
        SEGAnalytics.sharedAnalytics().track("Message Creation Failed")
    }
    
    static func TrackMessageCreated() -> Void
    {
        SEGAnalytics.sharedAnalytics().track("Message Created")
    }
    
    static func TrackAlertCreated() -> Void
    {
        SEGAnalytics.sharedAnalytics().track("Alert Created")
    }
    
}