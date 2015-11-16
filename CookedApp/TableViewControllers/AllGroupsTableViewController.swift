//
//  AllGroupsTableViewController.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 11/13/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

import UIKit

class AllGroupsTableViewController: GroupsTableViewController, GroupCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cellIdentifier = "GroupCellWithButton"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? GroupCellWithButton
        if cell == nil {
            cell = GroupCellWithButton(style: .Subtitle, reuseIdentifier: cellIdentifier)
        }
        // Configure the cell to show todo item with a priority at the bottom
        if let group = object as? Group {
            cell?.group = group
        }
        
        cell?.delegate = self
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedGroup = objectAtIndexPath(indexPath) as? Group

        let cell = tableView.cellForRowAtIndexPath(indexPath) as! GroupCellWithButton
        
        if (cell.userIsAdminOrMember)
        {
            performSegueWithIdentifier("ViewMessageWallSegue", sender: selectedGroup)
        }
        else
        {
            performSegueWithIdentifier("ViewGroupDetails", sender: selectedGroup)        }
        
        /*
        * If user is member or admin
            Go to message wall
        * else
            Go to details screen
        */
    }
    
    func detailsButtonPressed(cell:GroupCell) -> Void
    {
        performSegueWithIdentifier("ViewGroupDetails", sender: cell.group)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let selectedGroup = sender as? Group
        {
            if let destinationController = segue.destinationViewController as? MessageWallViewController
            {
                destinationController.group = selectedGroup
            }
            else if let destinationController = segue.destinationViewController as? GroupDetailsViewController
            {
                destinationController.group = selectedGroup
            }
        }
    }
}

