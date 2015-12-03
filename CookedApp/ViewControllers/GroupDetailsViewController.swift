//
//  GroupDetailsViewController.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 10/14/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

import UIKit

class GroupDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    static let GROUP_ID_EXTRA = "GroupId";
    static let GROUP_NAME_EXTRA = "GroupName";
    
    let USER_IS_ADMIN = 1;
    let USER_IS_MEMBER = 2;
    let USER_HAS_BEEN_INVITED = 3;
    let USER_HAS_ALREADY_REQUESTED_TO_JOIN = 4;
    let USER_HAS_NO_ASSOCIATION = 5;
    
    @IBOutlet weak var groupName : UILabel?
    @IBOutlet weak var groupPurpose : UILabel?
    @IBOutlet weak var areaOfFocus : UILabel?
    @IBOutlet weak var city : UILabel?
    @IBOutlet weak var membersList : UITableView?
    
    var members : [User] = []
    
    
    var group : Group? {
        didSet {
            refreshInfo()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cellIdentifier = "MemberCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? GroupMemberCell
            if cell == nil {
//                cell = GroupMemberCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
                cell = GroupMemberCell()
            }
            // Configure the cell to show todo item with a priority at the bottom
            if let user = members[indexPath.row] as? User {
                cell?.user = user
                
                let currentUserIsAdmin = group?.isCurrentUserAdmin()
                let userIsInvitee = (group?.isUserMember(user, forceServerContact: false) == false && group?.isUserAdmin(user, forceServerContact: false) == false)
                
                //If the current user is an admin of this group and the user for this view is an invitee, show the 'Approve' button, else hide it
                cell?.approveButton.hidden = !(userIsInvitee == true && currentUserIsAdmin == true)
                
                if userIsInvitee
                {
                    cell?.username.text?.appendContentsOf(" (pending")
                }
            }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedMember = members[indexPath.row]
        
        performSegueWithIdentifier("ViewUserDetails", sender: selectedMember)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshInfo()
        let current = PFUser.currentUser() as! User
        
        setupUIForCurrentUserStatusWithinGroup()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let props = [
            GroupDetailsViewController.GROUP_ID_EXTRA : (group?.objectId)!,
            GroupDetailsViewController.GROUP_NAME_EXTRA : (group?.name)!
        ]
        Stats.ScreenGroupDetails(props)
        
    }
    
    func refreshInfo()
    {
        groupName?.text = group?.name
        groupPurpose?.text = group?.purpose
        city?.text = group?.city
        areaOfFocus?.text = group?.neighberhoods
        loadMembersList()
    }
    
    func loadMembersList()
    {
        
        var queryList : [PFQuery] = []
        
        queryList.append(GroupDetailsViewController.getQueryForAdminsOfGroup(group!))
        queryList.append(GroupDetailsViewController.getQueryForMembersOfGroup(group!))
        queryList.append(GroupDetailsViewController.getQueryForOutstandingInviteesOfGroup(group!))
        queryList.append(GroupDetailsViewController.getQueryForOutstandingRequestersOfGroup(group!))
        
        
        let assembledQuery = PFQuery.orQueryWithSubqueries(queryList)
        
        assembledQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if let _ = error
            {
                print("Error while retrieving stuff")
            }
            else
            {
                self.members = objects as! [User]
                self.membersList?.reloadData()
            }
        }
    }
    
    static func getQueryForMembersOfGroup(g : Group) -> PFQuery
    {
        let q = User.query()
        q?.whereKey("memberOfArray", equalTo: g)
        return q!
    }

    static func getQueryForAdminsOfGroup(g : Group) -> PFQuery
    {
        let q = User.query()
        q?.whereKey("adminOfArray", equalTo: g)
        return q!
    }

    static func getQueryForOutstandingInviteesOfGroup(g : Group) -> PFQuery
    {
        
        let contractsQuery = GroupContract.query()
        contractsQuery?.whereKey(GroupContract._GROUP, equalTo: g)
        contractsQuery?.whereKey(GroupContract._STATUS, equalTo: GroupContract.STATUS_USER_INVITED)
        
        
        let q = User.query()
        q?.whereKey("objectId", matchesKey: "inviteeEmail", inQuery: contractsQuery!)
        return q!
    }
    
    static func getQueryForOutstandingRequestersOfGroup(g : Group) -> PFQuery
    {
        
        let contractsQuery = GroupContract.query()
        contractsQuery?.whereKey(GroupContract._GROUP, equalTo: g)
        contractsQuery?.whereKey(GroupContract._STATUS, equalTo: GroupContract.STATUS_USER_REQUESTED)
        
        let q = User.query()
        q?.whereKey("email", matchesKey: "inviteeEmail", inQuery: contractsQuery!)
        return q!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func updateUIForUserStatusResponse(response: Int)
    {
        // Remove loading indicator from right bar button
        self.navigationItem.setRightBarButtonItem(nil, animated: true)
        
        if response == USER_IS_MEMBER
        {
            //Do nothing
        }
        else if response == USER_IS_ADMIN
        {
            let item = UIBarButtonItem(title: "Invite Members", style: UIBarButtonItemStyle.Plain, target: self, action: "segueToInviteMembersVC")
            self.navigationItem.setRightBarButtonItem(item, animated: true)
        }
        else if response == USER_HAS_BEEN_INVITED
        {
            let item = UIBarButtonItem(title: "Accept Invitation", style: UIBarButtonItemStyle.Plain, target: self, action: "acceptInvitation")
            self.navigationItem.setRightBarButtonItem(item, animated: true)
        }
        else if response == USER_HAS_NO_ASSOCIATION
        {
            let item = UIBarButtonItem(title: "Request Membership", style: UIBarButtonItemStyle.Plain, target: self, action: "requestMembership")
            self.navigationItem.setRightBarButtonItem(item, animated: true)
        }
        else if response == USER_HAS_ALREADY_REQUESTED_TO_JOIN
        {
            let item = UIBarButtonItem(title: "Membership Requested", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
            item.enabled = false
            self.navigationItem.setRightBarButtonItem(item, animated: true)
        }
        else
        {
            let item = UIBarButtonItem(title: "Error", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
            item.enabled = false
            self.navigationItem.setRightBarButtonItem(item, animated: true)
        }
    }
    
    private func setupUIForCurrentUserStatusWithinGroup()
    {
        setIsLoadingMemberStatus()
        
        PFCloud.callFunctionInBackground("getUserStatusForGroup", withParameters: ["group" : (group?.objectId)!]) { (result, error: NSError?) -> Void in
            
            if error != nil
            {
                print("Error: " + (error?.localizedDescription)!)
            }
            else
            {
                var response = 9999
                if result != nil
                {
                    response = result as! Int
                    
                    self.updateUIForUserStatusResponse(response)
                }
            }
        }
    }
    
    private func setIsLoadingMemberStatus()
    {
        let ai = UIActivityIndicatorView(frame: CGRectMake(0, 0, 25, 25))
        ai.activityIndicatorViewStyle = .Gray
        ai.startAnimating()
        ai.sizeToFit()
        ai.autoresizingMask = [UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleRightMargin, UIViewAutoresizing.FlexibleTopMargin, UIViewAutoresizing.FlexibleBottomMargin]
        let item = UIBarButtonItem(customView: ai)
        self.navigationItem.setRightBarButtonItem(item, animated: true)
        
    }
    
    func requestMembership()
    {
        setIsLoadingMemberStatus();
        PFCloud.callFunctionInBackground("requestMembershipToGroup", withParameters: ["group" : (group?.objectId)!]) { (result, error: NSError?) -> Void in
            
            if error != nil
            {
                print("Error: " + (error?.localizedDescription)!)
            }
            else
            {
                var response = 9999
                if result != nil
                {
                    response = result as! Int
                    
                    self.updateUIForUserStatusResponse(response)
                }
            }
        }
    }
    
    func acceptInvitation()
    {
        setIsLoadingMemberStatus();
        PFCloud.callFunctionInBackground("acceptMembershipToGroup", withParameters: ["group" : (group?.objectId)!]) { (result, error: NSError?) -> Void in
            
            if error != nil
            {
                print("Error: " + (error?.localizedDescription)!)
            }
            else
            {
                var response = 9999
                if result != nil
                {
                    response = result as! Int
                    
                    //Update our user
                    PFUser.currentUser()?.fetchInBackground()
                    
                    self.updateUIForUserStatusResponse(response)
                }
            }
        }
        //TODO: Tell app delegate that it should refresh our list of groups of which our user is a member
    }
    
    
    func segueToInviteMembersVC()
    {
        
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let authorOfSelectedMessage = sender as? User
        {
            if let destinationController = segue.destinationViewController as? UserDetailsViewController
            {
                destinationController.user = authorOfSelectedMessage
            }
        }

    }
    
    
    

}

