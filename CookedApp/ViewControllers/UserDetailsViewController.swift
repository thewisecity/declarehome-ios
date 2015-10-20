//
//  UserDetailsViewController.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 10/15/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController, UITableViewDataSource {
    
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
        
//        allGroups = user.objectForKey("adminOfArray") as! [Group]!
//        allGroups = allGroups + (user.objectForKey("memberOfArray") as! [Group]!)
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
//        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! GroupCell
//        if cell == nil {
//            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
//        }
        
        var cell: GroupCell!
        if let dequedCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier){
            cell = dequedCell as! GroupCell
        } else {
            cell = GroupCell()
        }
        
        // Configure the cell to show todo item with a priority at the bottom
        if(allGroups.count > 0){
            if let group = allGroups[indexPath.row] as? Group? {
                cell?.group = group
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allGroups.count
    }
    
}
