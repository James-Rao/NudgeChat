//
//  NudgeViewController.swift
//  NudgeChat
//
//  Created by James Rao on 10/03/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import UIKit

class NudgeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    //controls
    
    @IBOutlet weak var _friendTableView: UITableView!
    @IBOutlet weak var _nudgeCollectionView: UICollectionView!
    
    // property
    var _manager : NudgeManager!
    var _selectedFriend: Friend!
    var _selectedNudger: Nudger!
    let _fromNudgetoSettingsSegueIdentifier : String = "fromNudgetoSettings"
    let _fromNudgetoChatSegueIdentifier: String = "fromNudgetoChat"
    let _nudgeCellIdentifier : String = "nudgeCell"
    let _friendCellIdentifier : String = "friendCell"
    
    
    // func 
    func initialize(userSelf: User) {
        
        view.userInteractionEnabled = false // false at the beginning
        _manager = NudgeManager(vc: self, userSelf: userSelf)
    }
    
    
    func initManagerCompleted() {
        
        _friendTableView.reloadData()
        _nudgeCollectionView.reloadData()
        view.userInteractionEnabled = true
        
        print("****\(_manager?._friends.count)!")
        print("****\(_manager?._nudges.count)!")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let button = UIButton(type: .Custom)
        button.setImage(UIImage(named: "profile.jpeg"), forState: UIControlState.Normal)
        button.addTarget(self, action: "showSettings", forControlEvents: UIControlEvents.TouchUpInside)
        button.frame = CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        
        // 
        _friendTableView.delegate = self
        _friendTableView.dataSource = self
        _nudgeCollectionView.delegate = self
        _nudgeCollectionView.dataSource = self
        
        //
        _nudgeCollectionView.backgroundColor = UIColor.clearColor()
    }
    
    
    func showSettings() {
        
        performSegueWithIdentifier(_fromNudgetoSettingsSegueIdentifier, sender: self)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // for the collection view
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("nudges count is ")
        print(_manager?._nudges.count)
        return _manager._nudges.count
    }
    
    //3
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let nudges = (_manager?._nudges)!
        let nudgeItem = nudges[indexPath.row]
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(_nudgeCellIdentifier, forIndexPath: indexPath) as! NudgeCollectionViewCell
//        cell.backgroundColor = UIColor.blackColor()
        cell._nameLabel.text = nudgeItem._name
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        print("select item: \(indexPath.row)")
        let nudges = _manager._nudges
        let nudgeItem = nudges[indexPath.row]
        _selectedNudger = nudgeItem
        
        performSegueWithIdentifier(_fromNudgetoChatSegueIdentifier, sender: _selectedNudger)
    }
    
    

    // for the table view
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("friends count is ")
        print((_manager?._friends.count)!)
        return (_manager?._friends.count)!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("select row: \(indexPath.row)")
        let friends = (_manager?._friends)!
        let friendItem = friends[indexPath.row]
        _selectedFriend = friendItem
        
        performSegueWithIdentifier(_fromNudgetoChatSegueIdentifier, sender: _selectedNudger)
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        
        if segue!.identifier == _fromNudgetoSettingsSegueIdentifier {
            if let vc = segue!.destinationViewController as? SettingsViewController {
                vc.initialize(_manager._userSelf)
            } else {
                print("not a navigator")
            }
        } else if segue!.identifier == _fromNudgetoChatSegueIdentifier {
            if let vc = segue!.destinationViewController as? ChatViewController {
                vc.initialize(sender as! User, userSelf: _manager._userSelf)
            } else {
                print("not a navigator")
            }
        }
    }
    
    
    //
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let friends = (_manager?._friends)!
        let friendItem = friends[indexPath.row]
        
        if let cell: FriendTableViewCell = tableView.dequeueReusableCellWithIdentifier(_friendCellIdentifier, forIndexPath: indexPath) as? FriendTableViewCell {
            cell._nameLabel.text = friendItem._name
            return cell
        }
    
        return UITableViewCell()
    }

}
