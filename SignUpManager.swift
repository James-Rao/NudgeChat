//
//  SignUpBrain.swift
//  NudgeChat
//
//  Created by James Rao on 3/03/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import Foundation
import UIKit

class DataFromSignUpToVerification {
    
    var _verificationCode: String?
    var _email: String?
    var _password: String?
}


class SignUpManager {
    
    // property
    let _vc: SignUpViewController
    var _errorStr : String = ""
    
    // data to share
    var _dataToVerification = DataFromSignUpToVerification()
    
    
    //
    init(vc: SignUpViewController) {
        _vc = vc
    }
    
    
    func signUp(email: String, password: String) {
        
        let isEmail = Global.isValidEmail(email)
        if !isEmail {
            _errorStr = "Email is not valid"
            _vc.signUpCompletion()
            return
        }
        
        // 
        _dataToVerification._email = email
        _dataToVerification._password = password
        
        // send verification and return true
        if sendVerification(email) {
            _vc.signUpCompletion()
        }
    }
    
    
    private func sendVerification(email: String) -> Bool {
        
        _dataToVerification._verificationCode = "123"
        return true
    }
    
    

}
