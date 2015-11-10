//
//  ImageUtilities.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 11/10/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

import UIKit



func roundImageCorners(img : UIImageView) -> Void
{
    img.layer.cornerRadius = img.frame.width/2 // Half of image width
    img.clipsToBounds = true
}
