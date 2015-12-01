//
//  AppDelegate.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 10/12/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

import UIKit
import Social
import Mixpanel

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UIWebViewDelegate{
    
    var drawerController: DrawerController?
    
    var myGroupsVC : MyGroupsTableViewController?
    
    var alertsVC : AlertsTableViewController?

    var window: UIWindow?
    
    var presentedViewController: UIViewController?
    
    func segueToTabViewController() -> Void {
        
        let tabController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("MainTabController") as! UITabBarController
        
        
        let navCont = tabController.viewControllers![0] as? UINavigationController
        
        myGroupsVC = navCont?.topViewController as? MyGroupsTableViewController
        
        alertsVC = tabController.viewControllers![1] as? AlertsTableViewController
        
        let sideNav = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("SideNavController") as! SideNavTableViewController
        
        drawerController = DrawerController(centerViewController: tabController, leftDrawerViewController: sideNav)
        
        drawerController!.maximumRightDrawerWidth = 200.0
        drawerController!.openDrawerGestureModeMask = .All
        drawerController!.closeDrawerGestureModeMask = .All
        
        self.window?.rootViewController? = drawerController!
        
    }
    
    func presentEditUserDetails() -> Void
    {
        
        let userDetailsVC = EditUserDetailsViewController()
        let user = PFUser.currentUser() as! User
        
        let nav = UINavigationController(rootViewController: userDetailsVC)
        
        let button = UIBarButtonItem(title: "Back", style: .Done, target: self, action: "dismissPresentedViewController")
        
        self.window?.rootViewController?.presentViewController(nav, animated: true, completion: closeDrawer)
        
        userDetailsVC.navigationItem.setLeftBarButtonItem(button, animated: true)
        
    }
    
    func presentViewAllGroups() -> Void
    {
        print("View All Groups")
        print("Create new group")
        let viewAllGroupsVC = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("AllGroupsTable") as! AllGroupsTableViewController
        
        let nav = UINavigationController(rootViewController: viewAllGroupsVC)
        
        let button = UIBarButtonItem(title: "Back", style: .Done, target: self, action: "dismissPresentedViewController")
        
        self.window?.rootViewController?.presentViewController(nav, animated: true, completion: closeDrawer)
        
        viewAllGroupsVC.navigationItem.setLeftBarButtonItem(button, animated: true)
    }

    func presentCreateNewGroup() -> Void
    {
        print("Create new group")
        let createGroupVC = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("CreateNewGroupViewController") as! CreateNewGroupViewController
        
        let nav = UINavigationController(rootViewController: createGroupVC)
        
        let button = UIBarButtonItem(title: "Back", style: .Done, target: self, action: "dismissPresentedViewController")
        
        self.window?.rootViewController?.presentViewController(nav, animated: true, completion: closeDrawer)
        
        createGroupVC.navigationItem.setLeftBarButtonItem(button, animated: true)
    }

    func presentViewFAQ() -> Void
    {
        let vc = UIViewController()
        
        let button = UIBarButtonItem(title: "Back", style: .Done, target: self, action: "dismissPresentedViewController")
        vc.navigationItem.setLeftBarButtonItem(button, animated: true)
        
        let webV:UIWebView = UIWebView(frame: vc.view.frame)
        vc.view.addSubview(webV)
        
        let nav = UINavigationController(rootViewController: vc)
        self.window?.rootViewController?.presentViewController(nav, animated: true, completion: closeDrawer)
        
        webV.backgroundColor = UIColor.redColor()
        
        let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        webV.addSubview(loadingIndicator)
        loadingIndicator.center = CGPointMake(webV.frame.size.width  / 2,
            webV.frame.size.height / 2);
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
        
        let q = PFQuery(className: "WebAddress")
        q.whereKey("title", equalTo: "faq")
        
        q.getFirstObjectInBackgroundWithBlock { (obj:PFObject?, err:NSError?) -> Void in
            loadingIndicator.stopAnimating()
            if let _ = err
            {
                //There was an error
            }
            else
            {
                webV.loadRequest(NSURLRequest(URL: NSURL(string: obj?.valueForKey("url") as! String)!))
                
            }
            
        }
        webV.delegate = self
        
    }

    func presentAboutDeclareHome() -> Void
    {
        let vc = UIViewController()
        
        let button = UIBarButtonItem(title: "Back", style: .Done, target: self, action: "dismissPresentedViewController")
        vc.navigationItem.setLeftBarButtonItem(button, animated: true)
        
        let webV:UIWebView = UIWebView(frame: vc.view.frame)
        vc.view.addSubview(webV)
        
        let nav = UINavigationController(rootViewController: vc)
        self.window?.rootViewController?.presentViewController(nav, animated: true, completion: closeDrawer)
        
        webV.backgroundColor = UIColor.redColor()
        
        let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        webV.addSubview(loadingIndicator)
        loadingIndicator.center = CGPointMake(webV.frame.size.width  / 2,
            webV.frame.size.height / 2);
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
        
        let q = PFQuery(className: "WebAddress")
        q.whereKey("title", equalTo: "about")
        
        q.getFirstObjectInBackgroundWithBlock { (obj:PFObject?, err:NSError?) -> Void in
            loadingIndicator.stopAnimating()
            if let _ = err
            {
                //There was an error
            }
            else
            {
                webV.loadRequest(NSURLRequest(URL: NSURL(string: obj?.valueForKey("url") as! String)!))
                
            }
            
        }
        webV.delegate = self
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?)
    {
        print(error?.description)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }

    
    
    func closeDrawer() -> Void
    {
        drawerController?.closeDrawerAnimated(false, completion: nil)
    }
    
    func dismissPresentedViewController() -> Void
    {
        self.window?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dismissPresentedViewControllerAndReloadGroups() -> Void
    {
        self.window?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
        myGroupsVC?.loadObjects()
    }
    
    func dismissPresentedViewControllerAndReloadAlerts() -> Void
    {
        self.window?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    
    func registerSubclasses() -> Void {
        Group.registerSubclass()
        User.registerSubclass()
        AlertCategory.registerSubclass()
        Message.registerSubclass()
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Need to call this before set application ID clientKey
        registerSubclasses()
        Parse.setApplicationId("BrndBVrRczElKefgG3TvjCk3JYxtd5GB2GMzKoEP", clientKey: "Xb7Pcc0lT2I3uJYNNoT6buaCuZ9dcvBMtCx9U5gw")
        
        // Register device for notifications
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        
        //Mixpanel
        Mixpanel.sharedInstanceWithToken(MixpanelAccountInfo.token)
        
        
        // If we're already logged in, skip the login screen
        if let _ = PFUser.currentUser() {
            
            // DEBUG / STANDIN : Subscribe to all notifs here
            Notifications.setSubscriptionForAllNotifs(true)
            
            segueToTabViewController()
        }
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        // Store the deviceToken in the current Installation and save it to Parse
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}


