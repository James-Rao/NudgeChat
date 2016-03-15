//
//  SettingViewController.swift
//  NudgeChat
//
//  Created by James Rao on 3/03/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import UIKit

class ProfileSettingViewController: UIViewController {
    
    // property
    var _manager: ProfileSettingManager?
    let _segueIdentifier = "fromProfileSettingtoPeople"
    
    // controls
    @IBOutlet weak var _setButton: UIButton!
    @IBOutlet weak var _nameTextField: UITextField!
    
    
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
    
    
    func initialize(email: String, password: String) {
        
        _manager = ProfileSettingManager(vc: self, email: email, password : password)
    }
    
    func initManagerCompleted() {
        
        if _manager!._errorStr.isEmpty {
            view.userInteractionEnabled = true
        } else {
            print(_manager!._errorStr)
        }
    }
    
    
    @IBAction func setUser(sender: AnyObject) {
        
        guard let name = _nameTextField.text where !name.isEmpty else {
            return
        }
        
        print("enter set user")
        performSegueWithIdentifier(_segueIdentifier, sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        
        if segue!.identifier == _segueIdentifier {
            if let navigatorVC = segue!.destinationViewController as? UINavigationController {
                if let vc = navigatorVC.visibleViewController as? PeopleViewController {
                    let userSelf = User()
                    userSelf._name = _nameTextField.text!
                    userSelf._userID = _manager!._authData!.uid
                    vc.initialize(userSelf)
                }
            } else {
                print("not a navigator")
            }
        }
        
    }
}
