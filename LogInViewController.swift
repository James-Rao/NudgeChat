//
//  ViewController.swift
//  NudgeChat
//
//  Created by James Rao on 3/03/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController{
    
    // controls
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // property
    var _manager: LogInManager!
    let _fromLogIntoPeopleIdentifier = "fromLogIntoPeople"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _manager = LogInManager(vc: self)
        
//        var upvotesRef = Global.FirebaseRef.childByAppendingPath("abc")
//        print(upvotesRef)
//        upvotesRef.observeEventType(.ChildChanged, withBlock: {
//            snapShot in
//            print("get changed")
//        })
//        
//        upvotesRef.observeEventType(.ChildAdded, withBlock: {
//                snapShot in
//                print("get added")
//        })
        
//        var upvotesRef = Global.FirebaseRef.childByAppendingPath("agfgsfd")
//        upvotesRef.runTransactionBlock({
//            (var currentData:FMutableData!) in
//            print("agfsdf")
//            print("\(currentData)")
//            print("\(currentData.value)")
//            var value = currentData.value as? Int
//            if value == nil {
//                value = 0
//            }
//            currentData.value = value! + 1
//            return FTransactionResult.successWithValue(currentData)
//        })
//
//        var hopperRef = Global.FirebaseRef.childByAppendingPath("gracehop")
//        var nickname = ["nickname": "Amazing Grace"]
////        var nickname2 = ["nickname2": "Amazing Grace2"]
//        hopperRef.updateChildValues(nickname)
        
//        var nickRef = hopperRef.childByAppendingPath("nickname")
//        var nickname2 = ["nickname2": "Amazing Grace2"]
//        
//        nickRef.updateChildValues(nickname2)
        
        // when grand child changed, the node can capture it too.
//        var chatSelfRef = Global.FirebaseRef.childByAppendingPath("mychat")
//        chatSelfRef.updateChildValues(["a":["a1":1, "a2":1]])
//        
//        chatSelfRef.observeEventType(.ChildChanged, withBlock: {
//            snapShot in
//            print(snapShot)
//        })

        
        // Do any additional setup after loading the view, typically from a ni
//        
//        authHandler = Global.FirebaseRef.observeAuthEventWithBlock { authData in
//            
//            if authData != nil {
//                print("it is too late")
//                //Global.FirebaseRef.removeAuthEventObserverWithHandle(self.authHandler!)
//            } else {
//                print("exit ???")
//            }
//        }
//        
// 
//        
//        
//        Firebase(url: "https://nudgechat.firebaseio.com/friends/257").observeEventType(.Value, withBlock: {
//            snapShot in
//            if snapShot == nil {
//                print("nothing")
//            } else {
//                if snapShot.value == nil {
//                    print("777")
//                } else {
//                    
//                    print("888")
//                    
//                    if snapShot.value is NSNull
//                    {
//                        print("9999")
//                    } else {
//                        print("101010")
//                    }
//                }
//                print(snapShot.value)
//            }
//        })
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func logIn(sender: AnyObject) {
        
        // log in . auth and then register observer from firebase
        guard let email = emailTextField.text where !email.isEmpty else {
            print("need email")
            return
        }
        
        guard let password = passwordTextField.text where !password.isEmpty else {
            print("need password")
            return
        }
        
        _manager.logIn(email, password: password)
    }
    
    
    func logInCompleted() {
        
        if _manager._errorStr.isEmpty {

            performSegueWithIdentifier(_fromLogIntoPeopleIdentifier, sender: self)
        } else {
            print(_manager._errorStr)
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        
        if segue!.identifier == _fromLogIntoPeopleIdentifier {
            if let navigatorVC = segue!.destinationViewController as? UINavigationController {
                if let vc = navigatorVC.visibleViewController as? PeopleViewController {
                    vc.initialize(_manager._user)
                }
            } else {
                print("not a navigator")
            }
        }
        
    }}

