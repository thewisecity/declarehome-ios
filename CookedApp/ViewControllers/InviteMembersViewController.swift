//
//  InviteMembersViewController.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 12/4/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

import UIKit

class InviteMembersViewController: UIViewController {
    
    @IBOutlet weak var groupName : UILabel?
    @IBOutlet weak var inviteeEmailAddress : UITextField?
    @IBOutlet weak var sendButton : UIButton?
    
    var group : Group? {
        didSet {
            refreshInfo()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshInfo()
    {
        groupName?.text = group?.name
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
