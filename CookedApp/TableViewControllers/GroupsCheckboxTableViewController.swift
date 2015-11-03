//
//  GroupsCheckboxTableViewController.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 11/2/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//


import UIKit
import Parse
import ParseUI

class GroupsCheckboxTableViewController: PFQueryTableViewController, GroupCheckboxDelegate  {
    
    var delegate: GroupCheckboxTableViewDelegate?
    var selectedGroups: NSMutableArray
    
    required init?(coder aDecoder: NSCoder) {
        selectedGroups = NSMutableArray()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 54.0
        self.title = "Select Groups for Alert"

    }
    
    func addNavBarDoneButton() -> Void
    {
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "finishGroupSelection"), animated: true)
    }
    
    func finishGroupSelection() -> Void
    {
        delegate?.finishedChoosingGroups(selectedGroups as AnyObject as! [Group])
        print("Finished")
    }
    
    func removeNavBarDoneButton() -> Void
    {
        self.navigationItem.setRightBarButtonItem(nil, animated: true)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func queryForTable() -> PFQuery
    {
        let query = PFQuery(className: self.parseClassName!)
        query.orderByAscending("city")
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell?
    {
        let cellIdentifier = "GroupCheckboxCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? GroupCheckboxCell
        if cell == nil {
            cell = GroupCheckboxCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        }
        // We don't want these cells to light up when we touch them
        cell?.selectionStyle = .None
        // Configure the cell to show todo item with a priority at the bottom
        if let group = object as? Group {
            cell?.group = group
        }
        cell?.delegate = self

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let cell:GroupCheckboxCell = self.tableView(tableView, cellForRowAtIndexPath: indexPath) as! GroupCheckboxCell
//        cell.checkSwitch.removeFromSuperview()
//        cell.checkSwitch.setOn(true, animated: true)
//        cell.checkSwitch.setNeedsDisplay()
//        
//        let selectedGroup = objectAtIndexPath(indexPath) as? Group
        
//        performSegueWithIdentifier("ViewMessageWallSegue", sender: selectedGroup)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let selectedGroup = sender as? Group{
            if let destinationController = segue.destinationViewController as? MessageWallViewController {
                destinationController.group = selectedGroup
            }
        }
    }
    
    // Delegate methods
    
    func groupCheckChanged(cell: GroupCheckboxCell, isChecked: Bool) -> Void
    {
        if(isChecked == true)
        {
            selectedGroups.addObject(cell.group)
        }
        else
        {
            selectedGroups.removeObject(cell.group)
        }
        
        if(selectedGroups.count > 0)
        {
            addNavBarDoneButton()
        }
        else
        {
            removeNavBarDoneButton()
        }
    }

}
