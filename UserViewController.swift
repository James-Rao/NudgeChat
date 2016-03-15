//
//  UserViewController.swift
//  NudgeChat
//
//  Created by James Rao on 7/03/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    
    // controls
    @IBOutlet weak var _nameLabel: UILabel!
    @IBOutlet weak var _nudgeButton: UIButton!
    
    // property
    var _manager: UserManager!
    let _fromUsertoChatSegueIdentifier: String = "fromUsertoConversation"
    

    func initialize(selectedUser: User, userSelf: User) {
        
        view.userInteractionEnabled = false
        _manager = UserManager(vc: self, user: selectedUser, userSelf: userSelf)
    }
    
    
    func setFirebaseCompleted() {
        
        view.userInteractionEnabled = true
        analyseRelationCompleted(_manager._relationship)
    }
    
    
    func observeNudgeCompleted() {
        
        analyseRelationCompleted(_manager._relationship)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _nameLabel.text = _manager?._selectedUser._name
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

    
    @IBAction func nudge(sender: AnyObject) {
        
        print("begin to nudge")
        _nudgeButton.enabled = false
        _manager!.nudge()
    }
    
    
    
    func nudgeCompleted() {
        
        if _manager._errorStr == nil {
            view.userInteractionEnabled = true
        } else {
            print(_manager._errorStr)
        }
    }
    
    
    override func viewWillDisappear(animated: Bool) {

        _manager!.dispose()
    }
    
    
    func appendRelationCompleted(result  : Bool ) {
        let enabled = result
        view.userInteractionEnabled = enabled
    }
    
    
    private func analyseRelationCompleted(relation: NudgeStatus) {
        
        print(relation)
        switch relation {
        case .NoRelation :
            _nudgeButton.backgroundColor = UIColor.blueColor()
        case .BeginFriend :
            _nudgeButton.backgroundColor = UIColor.redColor()
            _nudgeButton.enabled = false
        case .BeFriended :
            _nudgeButton.backgroundColor = UIColor.yellowColor()
        case .Friend :
            _nudgeButton.backgroundColor = UIColor.greenColor()
            _nudgeButton.enabled = false
        }
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        
        if segue!.identifier == _fromUsertoChatSegueIdentifier {
            if let vc = segue!.destinationViewController as? ChatViewController {
                vc.initialize(_manager._selectedUser, userSelf: _manager._userSelf)
            } else {
                print("not a navigator")
            }
        }
    }

}
