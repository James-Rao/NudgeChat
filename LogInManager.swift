//
//  LogInManager.swift
//  NudgeChat
//
//  Created by James Rao on 10/03/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import Foundation
import Firebase


class LogInManager {
    
    let _vc : LogInViewController
    let _user = User()
    var _errorStr = ""
    
    init(vc: LogInViewController) {
        
        _vc = vc
    }
    
    
    func logIn(email: String, password: String) {
        
        authUser(email, password: password)
    }
    
    
    private func authUser(email: String, password: String) {
        
        Global.FirebaseRef.authUser(email, password: password) {
            error, authData in
            print("auth completed")
            
            if error != nil {
                self._errorStr = Global.getErrorDetail(error)
                self.failtoAuthUser()
            } else {
                print("auth user successful")
                print(authData.uid)
                Global.FirebaseRef.childByAppendingPath(Global.UserPath).childByAppendingPath(authData.uid).observeSingleEventOfType(.Value, withBlock: {
                    snapShot in
                    
                    snapShot.children.forEach({
                        childSnapShot in
                        let childSnapShotAs = childSnapShot as! FDataSnapshot
                        
                        if childSnapShotAs.key == Global.UserName {
                            
                            self._user._name = childSnapShotAs.value as! String
                            self._user._userID = authData.uid
                            return
                        }
                    })
                    
                    self.succeedtoAuthUser()
                })
            }
        }
    }
    
    
    private func failtoAuthUser() {
        
        _vc.logInCompleted()
    }
    
    
    private func succeedtoAuthUser() {
        
        _vc.logInCompleted()
    }
}