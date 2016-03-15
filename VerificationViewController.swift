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
    
    // controls
    @IBOutlet weak var verificationTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("\(_manager!._dataFromSignUp!._verificationCode)")
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
