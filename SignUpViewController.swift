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
    let _segueIdentifier = "fromSignUptoVerification"
    
    //
    var _manager: SignUpManager!

    
    func initialize() {
        
        _manager = SignUpManager(vc: self)
    }
    
    //
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _manager = SignUpManager(vc: self)
        
//        _FirebaseRef.authUser(myEmail, password: myPassword, withCompletionBlock: {
//            error, authData in
//            if error != nil {
//                // an error occured while attempting login
//            } else {
//                // user is logged in, check authData for data
//
//                print("okay")
//                
//                self._FirebaseRef.resetPasswordForUser( self.myEmail, withCompletionBlock: {
//                    error in
//                    
//                    if error != nil {
//                        print(error?.localizedDescription)
//                    } else {
//                        print("okay")
//                    }
//                })
//            }
//       }); 
        
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
