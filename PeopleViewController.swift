//
//  PeopleViewController.swift
//  NudgeChat
//
//  Created by James Rao on 3/03/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import UIKit
import Firebase

class PeopleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // property
    var _manager: PeopleManager!
    let _peopleCellIdentifier = "peopleCellIdentifier"
    let _fromPeopletoUserDetailSegueIdentifier = "fromPeopletoUserDetail"
    let _fromPeopletoNudgeSegueIdentifier = "fromPeopletoNudge"
    var _selectedUser : PeopleAround?
    
    
    // controls
    @IBOutlet weak var _peopleTableView: UITableView!
    
    
    // initialize
    func initialize(userSelf: User) {
        
        view.userInteractionEnabled = false // false at the beginning
        _manager = PeopleManager(vc: self, userSelf: userSelf)
    }
    
    
    
    func initializeManagerCompleted() {
        
        if _manager._errorStr == nil {
            view.userInteractionEnabled = true
        } else {
            print(_manager._errorStr)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Organize, target: self, action: "addTapped")
        
        _peopleTableView.delegate = self
        _peopleTableView.dataSource = self
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func addTapped() {
        
       performSegueWithIdentifier(_fromPeopletoNudgeSegueIdentifier, sender: self)
    }

    
    func appendUserSelfCompleted(successful: Bool, result: String) {
        
        if !successful {
            view.userInteractionEnabled = false
            Global.addCover(self.view)
            return
        } else {
            
        }
    }
    

    // for the table view
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    //
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (_manager?._peopleAround.count)!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("select row: \(indexPath.row)")
        let people = (_manager?._peopleAround)!
        let peopleItem = people[indexPath.row]
        _selectedUser = peopleItem
        print("select \(peopleItem._name), \(peopleItem._userID)")
        
        performSegueWithIdentifier(_fromPeopletoUserDetailSegueIdentifier, sender: self)
    }
    
   
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        
        if segue!.identifier == _fromPeopletoUserDetailSegueIdentifier {
            if let vc = segue!.destinationViewController as? UserViewController {
                vc.initialize(_selectedUser!, userSelf: _manager!._userSelf)
            } else {
                print("not a navigator")
            }
        } else if segue!.identifier == _fromPeopletoNudgeSegueIdentifier {
            if let vc = segue!.destinationViewController as? NudgeViewController{
                vc.initialize(_manager!._userSelf)
            } else {
                print("something wrong")
            }
            
        }
    }


    //
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let people = (_manager?._peopleAround)!
        
        let peopleItem = people[indexPath.row]
        if let cell: PeopleTableViewCell = tableView.dequeueReusableCellWithIdentifier(_peopleCellIdentifier, forIndexPath: indexPath) as? PeopleTableViewCell {
            cell.nameLabel.text = peopleItem._name
            return cell
        }
        
//        if chatItem.isIn! {
//            let cellIdentifier = "chatOutCell"
//            if let cell: ChatOutTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? ChatOutTableViewCell {
//                cell.profileImageView.contentMode = .ScaleAspectFill
//                cell.profileImageView.layer.cornerRadius = CGRectGetWidth(cell.profileImageView.frame) / 2.0
//                cell.profileImageView.layer.masksToBounds = true;
//                cell.profileImageView.image = chatItem.profileImage
//                cell.chatMessageLabel.text = chatItem.chatMessage
//                return cell
//            }
//        } else {
//            let cellIdentifier = "chatInCell"
//            if let cell: ChatInTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? ChatInTableViewCell {
//                cell.profileImageView.contentMode = .ScaleAspectFill
//                cell.profileImageView.layer.cornerRadius = CGRectGetWidth(cell.profileImageView.frame) / 2.0
//                cell.profileImageView.layer.masksToBounds = true;
//                cell.profileImageView.image = chatItem.profileImage
//                cell.chatMessageLabel.text = chatItem.chatMessage
//                return cell
//            }
//        }
        
        return UITableViewCell()
    }

    
    func retrieveOneUser1() {
        
        //_peopleTableView.reloadData()
        let row = (_manager?._peopleAround.count)! - 1
        print("row is \(row)")
        let newIndexPath = NSIndexPath(forRow: row, inSection: 0)
        _peopleTableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
    }
    
    
    func peopleAddedCompleted() {
        
        _peopleTableView.reloadData()
    }
}


