//
//  SetttingManager.swift
//  NudgeChat
//
//  Created by James Rao on 4/03/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import Foundation
import Firebase


class ProfileSettingManager {
    
    // property
    let _vc: ProfileSettingViewController
    let _email: String
    let _password: String
    var _authData: FAuthData?
    var _errorStr = ""
    
    //
    init(vc: ProfileSettingViewController, email: String, password: String) {
        
        _vc = vc
        _email = email
        _password = password
        
        setFirebase()
    }
    
    
    // 
    func setFirebase() {

        Global.FirebaseRef.createUser(_email, password: _password, withCompletionBlock: {
            error in
            if error != nil {
                self._errorStr = Global.getErrorDetail(error)
                self.failtoCreateUser()
            } else {
                print("create user successful")
                self.authUser()
            }
        })
    }
    
    
    private func authUser() {
        
        Global.FirebaseRef.authUser(_email, password: _password) {
            error, authData in
            print("auth completed")
            
            if error != nil {
                self._errorStr = Global.getErrorDetail(error)
                self.failtoAuthUser()
            } else {
                print("auth user successful")
                print(authData.uid)
                self._authData = authData
                self.succeedtoAuthUser()
            }
        }
    }
    
    
    private func failtoCreateUser() {
        _vc.initManagerCompleted()
    }
    
    
    private func failtoAuthUser() {
        
        _vc.initManagerCompleted()
    }
    
    
    private func succeedtoAuthUser() {
        _vc.initManagerCompleted()
    }
}
