//
//  NavigationDelegate.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 10/15/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//


protocol NavigationDelegate {
    func performSegueWithId(identifer: String, sender: AnyObject?) -> Void
}
