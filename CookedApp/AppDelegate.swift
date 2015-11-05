//
//  AppDelegate.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 10/12/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

import UIKit
import Social

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var drawerController: DrawerController?

    var window: UIWindow?
    
    var presentedViewController: UIViewController?
    
    func segueToTabViewController() -> Void {
        
        let tabController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("MainTabController") as! UITabBarController
        
        let sideNav = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("SideNavController") as! SideNavTableViewController
        
        drawerController = DrawerController(centerViewController: tabController, leftDrawerViewController: sideNav)
        
        drawerController!.maximumRightDrawerWidth = 200.0
        drawerController!.openDrawerGestureModeMask = .All
        drawerController!.closeDrawerGestureModeMask = .All
        
        self.window?.rootViewController? = drawerController!
        
    }
    
    func presentUserDetails() -> Void
    {
        let userDetailsVC = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("UserDetailsVC") as! UserDetailsViewController

        let user = PFUser.currentUser() as! User
        
        userDetailsVC.user = user
        
        let nav = UINavigationController(rootViewController: userDetailsVC)
        
        let button = UIBarButtonItem(title: "Back", style: .Done, target: self, action: "dismissPresentedViewController")
        
        self.window?.rootViewController?.presentViewController(nav, animated: true, completion: nil)
        
        userDetailsVC.navigationItem.setLeftBarButtonItem(button, animated: true)
    }
    
    func dismissPresentedViewController() -> Void
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
        
        
        if let _ = PFUser.currentUser() {
            
            segueToTabViewController()
        }
        return true
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


