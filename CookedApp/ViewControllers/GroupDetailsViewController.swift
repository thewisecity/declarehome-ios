//
//  GroupDetailsViewController.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 10/14/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

import UIKit

class GroupDetailsViewController: UIViewController, UITableViewDataSource {
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshInfo()
        let current = PFUser.currentUser() as! User
        
        // Do any additional setup after loading the view.
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
//                members = objects
                self.members = objects as! [User]
                self.membersList?.reloadData()
            }
        }
//        ParseQuery<User> assembledQuery = null;
//        
//        ArrayList<ParseQuery<User>> queryList = new ArrayList<ParseQuery<User>>();
//        
//        if (includeMembers) {
//            sMembersQuery = getQueryForMembersOfGroup(membersOfGroup);
//            queryList.add(sMembersQuery);
//        }
//        
//        if(includeAdmins) {
//            sAdminsQuery = getQueryForAdminsOfGroup(membersOfGroup);
//            queryList.add(sAdminsQuery);
//        }
//        
//        if(includePendingNeedsApproval) {
//            sRequestersQuery = getQueryForOutstandingRequestersOfGroup(membersOfGroup);
//            queryList.add(sRequestersQuery);
//        }
//        
//        if(includePendingNeedsToAccept) {
//            sInviteesQuery = getQueryForOutstandingInviteesOfGroup(membersOfGroup);
//            queryList.add(sInviteesQuery);
//        }
//        
//        if(queryList.size() > 0)
//        assembledQuery = ParseQuery.or(queryList);
//        
//        return assembledQuery;
        
        
        
    }
    
    static func getQueryForMembersOfGroup(g : Group) -> PFQuery
    {
        let q = User.query()
        q?.whereKey("memberOfArray", equalTo: g)
        return q!
    }
    
    
//    private static ParseQuery<User> getQueryForMembersOfGroup(Group group) {
//    
//    ParseQuery<User> membersQuery = new ParseQuery<>(User.class);
//    membersQuery.whereEqualTo("memberOfArray", group);
//    
//    
//    return membersQuery;
//    }
    
    static func getQueryForAdminsOfGroup(g : Group) -> PFQuery
    {
        let q = User.query()
        q?.whereKey("adminOfArray", equalTo: g)
        return q!
    }
//    
//    private static ParseQuery<User> getQueryForAdminsOfGroup(Group group) {
//    
//    ParseQuery<User> adminsQuery = new ParseQuery<>(User.class);
//    adminsQuery.whereEqualTo("adminOfArray", group);
//    
//    return adminsQuery;
//    }
    
    static func getQueryForOutstandingInviteesOfGroup(g : Group) -> PFQuery
    {
        
        let contractsQuery = GroupContract.query()
        contractsQuery?.whereKey(GroupContract._GROUP, equalTo: g)
        contractsQuery?.whereKey(GroupContract._STATUS, equalTo: GroupContract.STATUS_USER_INVITED)
        
        
        let q = User.query()
        q?.whereKey("objectId", matchesKey: "inviteeEmail", inQuery: contractsQuery!)
        return q!
    }
    
//    
//    private static ParseQuery<User> getQueryForOutstandingInviteesOfGroup(Group group) {
//    
//    ParseQuery<GroupContract> contractsQuery = new ParseQuery<>(GroupContract.class);
//    contractsQuery.whereEqualTo(GroupContract._GROUP, group);
//    contractsQuery.whereEqualTo(GroupContract._STATUS, GroupContract.STATUS_USER_INVITED);
//    
//    ParseQuery<User> users = new ParseQuery<>(User.class);
//    users.whereMatchesKeyInQuery("email", "inviteeEmail", contractsQuery);
//    
//    return users;
//    
//    }
    
    static func getQueryForOutstandingRequestersOfGroup(g : Group) -> PFQuery
    {
        
        let contractsQuery = GroupContract.query()
        contractsQuery?.whereKey(GroupContract._GROUP, equalTo: g)
        contractsQuery?.whereKey(GroupContract._STATUS, equalTo: GroupContract.STATUS_USER_REQUESTED)
        
        let q = User.query()
        q?.whereKey("email", matchesKey: "inviteeEmail", inQuery: contractsQuery!)
        return q!
    }
    
//    
//    private static ParseQuery<User> getQueryForOutstandingRequestersOfGroup(Group group) {
//    
//    ParseQuery<GroupContract> contractsQuery = new ParseQuery<>(GroupContract.class);
//    contractsQuery.whereEqualTo(GroupContract._GROUP, group);
//    contractsQuery.whereEqualTo(GroupContract._STATUS, GroupContract.STATUS_USER_REQUESTED);
//    
//    ParseQuery<User> users = new ParseQuery<>(User.class);
//    users.whereMatchesKeyInQuery("email", "inviteeEmail", contractsQuery);
//    
//    return users;
//    
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

