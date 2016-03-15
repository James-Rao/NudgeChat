//
//  VerificationManager.swift
//  NudgeChat
//
//  Created by James Rao on 4/03/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import Foundation


class VerificationManager {

    // property
    let _vc: VerificationViewController
    
    // data to share
    var _dataFromSignUp: DataFromSignUpToVerification?
    
    
    //
    init(vc: VerificationViewController) {
        
        _vc = vc
   
    }
    
    
   
    
    func isVerificationRight(verification: String) -> Bool {
        
        if _dataFromSignUp?._verificationCode == verification {
            return true
        } else {
            return false
        }
    }
    
    
    //func
}