//
//  VerificationViewController.swift
//  NudgeChat
//
//  Created by James Rao on 4/03/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import UIKit

class VerificationViewController: UIViewController {
    
    // property
    var _manager: VerificationManager?
    let _segueIdentifier = "fromVerificationtoProfileSetting"
    var _isKeyboardShow = false
    
    // controls
    @IBOutlet weak var verificationTextField: UITextField!
    @IBOutlet weak var _verifyButton: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        let referenceY = _verifyButton.frame.origin.y
        let referenceHeight = _verifyButton.bounds.size.height
        
        let distance = keyboardY - referenceY
        
        if distance > 0 && distance < Global.DefaultDistance + referenceHeight {
            let offset = Global.DefaultDistance - distance + referenceHeight
            self.view.frame.origin.y -= offset
        } else if distance < 0 {
            let offset = abs(distance) + Global.DefaultDistance + referenceHeight
            self.view.frame.origin.y -= offset
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
    

    @IBAction func verify(sender: AnyObject) {
        
        guard verificationTextField.text != nil else {
            return
        }
        
        if !_manager!.isVerificationRight(verificationTextField.text!) {
            return
        } else {
            // the vc will create after calling this function
            performSegueWithIdentifier(_segueIdentifier, sender: self)
        }
    }

    
    // note:
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        
        if segue!.identifier == _segueIdentifier {
            if let vc = segue!.destinationViewController as? ProfileSettingViewController {
                // use the animation time to process firebase request
                let email = (self._manager?._dataFromSignUp?._email)!
                let password = (self._manager?._dataFromSignUp?._password)!
                
                //vc._manager = ProfileSettingManager(vc: vc, email: email, password: password)
                vc.initialize(email, password : password)
            }
        }
        
    }
}
