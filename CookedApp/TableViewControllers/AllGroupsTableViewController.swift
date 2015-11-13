//
//  AllGroupsTableViewController.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 11/13/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

import UIKit

class AllGroupsTableViewController: GroupsTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cellIdentifier = "GroupCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? GroupCell
        if cell == nil {
            cell = GroupCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        }
        // Configure the cell to show todo item with a priority at the bottom
        if let group = object as? Group {
            cell?.group = group
            
            // Test if we are an admin or member
            let user = PFUser.currentUser() as! User
            if group.isUserMember(user, forceServerContact: false) == true ||
                group.isUserAdmin(user, forceServerContact: false) == true
            {
                cell?.detailsButton.hidden = false
            }
        }
        
        
        return cell
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
