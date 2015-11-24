//
//  MessageTableViewController.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 10/14/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

import UIKit

class MessageTableViewController: PFQueryTableViewController {
    
    var group: Group!
    
    var navDelegate: NavigationDelegate!
    
    var messagesDelegate: MessageTableDelegate?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.paginationEnabled = true
        self.objectsPerPage = 10        
        
    }
    
    init(group: Group) {
        super.init(style: .Plain, className: "Message")
        self.group = group
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: self.parseClassName!)
        query.orderByDescending("createdAt")
        let groupProxy = PFObject(className: "Group")
        groupProxy.objectId = group.objectId
        
        query.whereKey(Message._GROUPS, equalTo: groupProxy)
        
        query.includeKey(Message._CATEGORY)
        query.includeKey(Message._AUTHOR)
        query.includeKey(Message._AUTHOR_ADMIN_ARRAY)
        query.includeKey(Message._AUTHOR_MEMBER_ARRAY)
        
        return query
    }
    
    override func objectsDidLoad(error: NSError?) {
        super.objectsDidLoad(error)
        messagesDelegate?.loadedObjects(objects, error: error)
        
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
