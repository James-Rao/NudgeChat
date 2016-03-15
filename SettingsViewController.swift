//
//  UserSelfViewController.swift
//  NudgeChat
//
//  Created by James Rao on 11/03/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var _manager: SettingsManager!
    var _userSelf: User!
    let _fromSettingstoLogInSegueIdentifier = "fromSettingstoLogIn"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initialize(userSelf: User) {
        
        _userSelf = userSelf
        _manager = SettingsManager(vc: self, userSelf: _userSelf)
    }
    
    
    @IBAction func logOut(sender: AnyObject) {
        
        _manager.logOut()
    }

    
    
    func logOutCompleted() {
        
        print("before perform")
        performSegueWithIdentifier(_fromSettingstoLogInSegueIdentifier, sender: self)
        print("after perform")
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
       
        
        print("prepare")
    }
}
