//
//  SettingsManager.swift
//  NudgeChat
//
//  Created by James Rao on 11/03/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import Foundation



class SettingsManager {
    
    let _vc : SettingsViewController
    let _userSelf : User
    
    
    init (vc: SettingsViewController, userSelf: User) {
        
        _vc = vc
        _userSelf = userSelf
    }
    
    
    func logOut() {
        
        Global.FirebaseRef.unauth()
        _vc.logOutCompleted()
    }
}