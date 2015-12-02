//
//  AlertsTableViewController.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 10/21/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

import UIKit

class AlertsTableViewController: PFQueryTableViewController {
    
    var navDelegate: NavigationDelegate!
    
    var statusLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.paginationEnabled = true
        self.objectsPerPage = 10
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80
        
        statusLabel = UILabel()
        statusLabel.text = "Loading..."
        view.addSubview(statusLabel)
        statusLabel.sizeToFit()
        statusLabel.center = CGPointMake(view.frame.size.width  / 2,
            view.frame.size.height / 2);
        statusLabel.hidden = true

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        Stats.ScreenAlerts()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func objectsDidLoad(error: NSError?) {
        super.objectsDidLoad(error)
        
        if error != nil
        {
            statusLabel.text = "Error while loading. Please try again."
            statusLabel.sizeToFit()
            statusLabel.center = CGPointMake(view.frame.size.width  / 2,
                view.frame.size.height / 2);

            statusLabel.hidden = false
        }
        else if objects?.count == 0
        {
            statusLabel.text = "No alerts have been posted from your groups"
            statusLabel.sizeToFit()
            statusLabel.center = CGPointMake(view.frame.size.width  / 2,
                view.frame.size.height / 2);

            statusLabel.hidden = false
        }
        else
        {
            statusLabel.hidden = true
        }
    }
    
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: self.parseClassName!)
        query.orderByDescending("createdAt")
        query.whereKey(Message._IS_ALERT, equalTo: true)
        
        let adminOfQuery = PFUser.currentUser()?.relationForKey("adminOf").query()
        let memberOfQuery = PFUser.currentUser()?.relationForKey("memberOf").query()
        
        let groupsQuery = PFQuery.orQueryWithSubqueries([adminOfQuery!, memberOfQuery!])
        
        query.whereKey(Message._GROUPS, matchesQuery: groupsQuery)
        
        query.includeKey(Message._CATEGORY)
        query.includeKey(Message._AUTHOR)
        query.includeKey(Message._AUTHOR_ADMIN_ARRAY)
        query.includeKey(Message._AUTHOR_MEMBER_ARRAY)
                
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cellIdentifier = "MessageCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? MessageCell
        if cell == nil {
            cell = MessageCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        }
        // Configure the cell to show todo item with a priority at the bottom
        if let message = object as? Message {
            cell?.message = message
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        print(self.objects?.count)
        if indexPath.row >= self.objects?.count {
            loadNextPage()
            return
        }
        
        let selectedMessage = objectAtIndexPath(indexPath) as? Message
        let author = selectedMessage?.author
        navDelegate.performSegueWithId("ViewUserDetailsSegue", sender: author)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //        if let selectedGroup = sender as? Group{
        //            if let destinationController = segue.destinationViewController as? GroupDetailsViewController {
        //                destinationController.group = selectedGroup
        //            }
        //        }
    }
    
}
