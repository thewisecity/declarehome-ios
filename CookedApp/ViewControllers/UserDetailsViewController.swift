//
//  UserDetailsViewController.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 10/15/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var user: User!
    
    @IBOutlet weak var profilePicture : PFImageView!
    @IBOutlet weak var nameField : UILabel!
    @IBOutlet weak var emailAddressField : UITextView!
    @IBOutlet weak var phoneNumberField : UITextView!
    @IBOutlet weak var linkOneField : UITextView!
    @IBOutlet weak var linkTwoField : UITextView!
    @IBOutlet weak var linkThreeField : UITextView!
    @IBOutlet weak var descriptionField : UITextView!
    
    var allGroups: [Group] = [Group]()
    @IBOutlet weak var groupsTableView : UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = user.displayName
        nameField.text = user.displayName
        emailAddressField.text = user.email
        phoneNumberField.text = user.phoneNumber
        linkOneField.text = user.linkOne
        linkTwoField.text = user.linkTwo
        linkThreeField.text = user.linkThree
        descriptionField.text = user.userDescription
        
        
        if let adminsArray = user.adminOfArray {
            allGroups = allGroups + adminsArray
        }
        if let membersArray = user.memberOfArray {
            allGroups = allGroups + membersArray
        }
        
        
        profilePicture.file = user.profilePic
        profilePicture.layer.cornerRadius = 50 // Half of width set in storyboard xib
        profilePicture.clipsToBounds = true
        profilePicture.loadInBackground()
        
        groupsTableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "GroupCell"
        
        var cell: GroupCell!
        if let dequedCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier){
            cell = dequedCell as! GroupCell
        } else {
            cell = GroupCell()
        }
        
        // Configure the cell to show todo item with a priority at the bottom
        if(allGroups.count > 0){
            if let group = allGroups[indexPath.row] as Group? {
                cell?.group = group
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedGroup = allGroups[indexPath.row]
        print(selectedGroup.name)
        performSegueWithIdentifier("ViewGroupDetails", sender: selectedGroup)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allGroups.count
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
