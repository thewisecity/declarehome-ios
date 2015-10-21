//
//  AlertCategoriesTableViewController.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 10/20/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

import UIKit

class AlertCategoriesTableViewController: PFQueryTableViewController {
   
    var delegate: AlertCategoriesTableViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.paginationEnabled = true
        self.objectsPerPage = 25
    }
    
    init() {
        super.init(style: .Plain, className: AlertCategory.className)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: self.parseClassName!)
//        query.orderByDescending("createdAt")
        
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cellIdentifier = "CategoryCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? AlertCategoryCell
        if cell == nil {
            cell = AlertCategoryCell(style: .Default, reuseIdentifier: cellIdentifier)
        }
        // Configure the cell to show todo item with a priority at the bottom
//        if let category = object as? AlertCategory {
//            cell?.category = category
//        }
        return cell
    }
    
    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
//        let cellIdentifier = "GroupCell"
//        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? GroupCell
//        if cell == nil {
//            cell = GroupCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
//        }
//        // Configure the cell to show todo item with a priority at the bottom
//        if let group = object as? Group {
//            cell?.group = group
//        }
//        return cell
//    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let category = objectAtIndexPath(indexPath) as? AlertCategory {
            //            cell?.textLabel?.text = category.description
            if let theCell = cell as? AlertCategoryCell {
                theCell.category = category
            }
            
        }
    }
        
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        print(indexPath.row)
//        print(self.objects?.count)
//        if indexPath.row >= self.objects?.count {
//            loadNextPage()
//            return
//        }
//        
//        let selectedMessage = objectAtIndexPath(indexPath) as? Message
//        let author = selectedMessage?.author
//        navDelegate.performSegueWithId("ViewUserDetailsSegue", sender: author)
        //        performSegueWithIdentifier("ViewUserDetailsSegue", sender: self)
        
        let selectedCategory = objectAtIndexPath(indexPath) as? AlertCategory
        delegate?.chooseAlertCategory(selectedCategory)
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
