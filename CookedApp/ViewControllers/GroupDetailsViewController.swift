//
//  GroupDetailsViewController.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 10/14/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

import UIKit

class GroupDetailsViewController: UIViewController {
    
    @IBOutlet weak var groupName : UILabel?
    @IBOutlet weak var groupPurpose : UILabel?
    
    var group : Group? {
        didSet {
            groupName?.text = group?.name
            groupPurpose?.text = group?.purpose
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupName?.text = group?.name
        groupPurpose?.text = group?.purpose
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
