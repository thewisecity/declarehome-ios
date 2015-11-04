//
//  MyGroupsTableViewController.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 11/2/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class MyGroupsTableViewController: GroupsTableViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Groups"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func queryForTable() -> PFQuery {
//        let query = PFQuery(className: self.parseClassName!)
//        query.orderByAscending("city")
        
        
        
//        ParseRelation adminRel = currentUser.getRelation("adminOf");
//        ParseRelation memberRel = currentUser.getRelation("memberOf");
        var adminRel:PFRelation?  = PFUser.currentUser()?.relationForKey("adminOf");
        var memberRel:PFRelation? = PFUser.currentUser()?.relationForKey("adminOf");
//        
//        ParseQuery adminOfQuery = adminRel.getQuery();
//        ParseQuery memberOfQuery = memberRel.getQuery();
        
        var adminOfQuery:PFQuery = (adminRel?.query())!
        var memberOfQuery:PFQuery = (memberRel?.query())!
//        
//        if(adminOfQuery.getClassName().equalsIgnoreCase("Group") == false) {
//            try {
//                currentUser.fetch();
//                adminRel = currentUser.getRelation("adminOf");
//                memberRel = currentUser.getRelation("memberOf");
//                
//                adminOfQuery = adminRel.getQuery();
//                memberOfQuery = memberRel.getQuery();
//                
//            } catch (ParseException e) {
//                e.printStackTrace();
//            }
//            
//        }
        
        let query = PFQuery.orQueryWithSubqueries([adminOfQuery, memberOfQuery])
        query.orderByAscending("city")
//        
//        List<ParseQuery<Group>> queries = new ArrayList<ParseQuery<Group>>();
//        queries.add(adminOfQuery);
//        queries.add(memberOfQuery);
//        
//        query = (ParseQuery<Group>) ParseQuery.or(queries);
        
        
        
        
        return query
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
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedGroup = objectAtIndexPath(indexPath) as? Group
        
        performSegueWithIdentifier("ViewMessageWallSegue", sender: selectedGroup)
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
    
}