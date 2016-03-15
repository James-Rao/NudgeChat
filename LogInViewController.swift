//
//  ViewController.swift
//  NudgeChat
//
//  Created by James Rao on 3/03/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    
    // controls
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var _logInButton: UIButton!
    
    // property
    var _manager: LogInManager!
    let _fromLogIntoPeopleIdentifier = "fromLogIntoPeople"
    var _isKeyboardShow  = false
    var _offset: CGFloat = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _manager = LogInManager(vc: self)
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        //
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    // later in your class:
    func keyboardWillShow(notification: NSNotification) {
        
        let frame = notification.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        // do stuff with the frame...
        print(frame)
        if !_isKeyboardShow {
            adjustFrametoShowNecessaryElements(frame.origin.y)
            _isKeyboardShow = true
        }
    }
    
    
    func keyboardWillHide(notification : NSNotification ) {
        
        _isKeyboardShow = false
        self.view.frame.origin.y = 0
    }
    
    
    private func adjustFrametoShowNecessaryElements(keyboardY: CGFloat) {
        
        //let referenceY = passwordTextField.frame.origin.y
        let referenceY = _logInButton.frame.origin.y
        let referenceHeight = _logInButton.bounds.size.height
        
        let distance = keyboardY - referenceY
        
        if distance > 0 && distance < Global.DefaultDistance + referenceHeight {
            _offset = Global.DefaultDistance - distance + referenceHeight
            self.view.frame.origin.y -= _offset
        } else if distance < 0 {
            _offset = abs(distance) + Global.DefaultDistance + referenceHeight
            self.view.frame.origin.y -= _offset
        }
    }
    
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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

