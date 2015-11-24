//
//  MessageTableDelegate.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 11/24/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

protocol MessageTableDelegate {
    func loadedObjects(objects:[AnyObject]?, error: NSError?) -> Void
}
