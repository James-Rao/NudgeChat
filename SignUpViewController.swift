//
//  SignUpViewController.swift
//  NudgeChat
//
//  Created by James Rao on 3/03/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import UIKit
import Firebase


class SignUpViewController: UIViewController {
    
    //
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var _signUpButton: UIButton!
    
    //
    var _manager: SignUpManager!
    var _isKeyboardShow = false
    let _segueIdentifier = "fromSignUptoVerification"

    
    func initialize() {
        
        _manager = SignUpManager(vc: self)
    }
    
    //
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _manager = SignUpManager(vc: self)
        
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
        let referenceY = _signUpButton.frame.origin.y
        let referenceHeight = _signUpButton.bounds.size.height
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func signUp(sender: AnyObject) {

        guard let email = emailTextField.text where !email.isEmpty else {
            return
        }
        
        guard let password = passwordTextField.text where !password.isEmpty else {
            return
        }
        
        guard let confirmPassword = confirmPasswordTextField.text where !confirmPassword.isEmpty else {
            return
        }
        
        guard passwordTextField.text == confirmPasswordTextField.text else {
            return
        }
        
        _manager!.signUp(emailTextField.text!, password: passwordTextField.text!)
    }
    
    
    func signUpCompletion() {
        
        if _manager._errorStr.isEmpty {
            performSegueWithIdentifier(_segueIdentifier, sender: self)
        } else {
            print(_manager._errorStr)
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        
        if segue!.identifier == _segueIdentifier {
            if let vc = segue!.destinationViewController as? VerificationViewController {
                vc._manager = VerificationManager(vc: vc)
                vc._manager!._dataFromSignUp = self._manager!._dataToVerification
            }
        }
        
    }
}
