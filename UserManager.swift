//
//  UserManager.swift
//  NudgeChat
//
//  Created by James Rao on 7/03/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import Foundation
import Firebase

class UserManager {
    
    let _vc: UserViewController
    let _selectedUser: User
    let _userSelf: User
    let _nudgeUserSelfRef: Firebase
    var _isBeginFriend = false
    var _isBeFriended = false
    var _relationship: NudgeStatus = .NoRelation // default 0. from 0 - 6. some value is locally defined but not all saved on firebase
    var _errorStr : String?
    
    
    init (vc: UserViewController, user: User, userSelf: User) {
        
        print("init now")
        
        _selectedUser = user
        _userSelf = userSelf
        _vc = vc
        
        _nudgeUserSelfRef = Global.FirebaseRef.childByAppendingPath(Global.NudgePath).childByAppendingPath(_userSelf._userID)
        
        // 
        setFirebase()
    }
    
    
    private func analyseRelationChild(snapShot : FDataSnapshot) {
        
        //
        if snapShot.key == Global.NudgeBeginFriend {
            if snapShot.hasChildren() {
                snapShot.children.forEach({
                    grandChildSnapShot in
                    let grandChildData = grandChildSnapShot as! FDataSnapshot
                    if grandChildData.key == self._selectedUser._userID {
                        _isBeginFriend = true
                    }
                })
            }
        } else if snapShot.key == Global.NudgeBeFriended {
            if snapShot.hasChildren() {
                snapShot.children.forEach({
                    grandChildSnapShot in
                    let grandChildData = grandChildSnapShot as! FDataSnapshot
                    if grandChildData.key == self._selectedUser._userID {
                        _isBeFriended = true
                    }
                })
            }
        }
    }
    
    
    private func analyseRelation (snapShot: FDataSnapshot ) {
        
        //
        snapShot.children.forEach({
            childSnapShot in
            let childSnapShotAs = childSnapShot as! FDataSnapshot
            analyseRelationChild(childSnapShotAs)
        })

    }

    
    private func updateRelation() {
        
        if _isBeginFriend {
            self._relationship = .BeginFriend
        }
        if _isBeFriended {
            self._relationship = .BeFriended
        }
        if _isBeginFriend && _isBeFriended {
            self._relationship = .Friend
        }
    }
    

    private func setFirebase() {
        
        // retrieve it first
        let relationRef = _nudgeUserSelfRef
        relationRef.observeSingleEventOfType(.Value, withBlock: {
            snapShot in
            print("retrieve ..... \(snapShot.key) .... \(snapShot.value)")
            self.analyseRelation(snapShot)
            self.updateRelation()
            self.observeNudge()
            self.setFirebaseCompleted()
        })
    }
    
    
    private func setFirebaseCompleted() {
        
        _vc.setFirebaseCompleted()
    }
    
    
    func nudge() {
        
        let nudge = [
            _userSelf._userID + "/" + Global.NudgeBeginFriend + "/" + _selectedUser._userID : [
                Global.UserName : _selectedUser._name,
            ],
            _selectedUser._userID + "/" + Global.NudgeBeFriended + "/" + _userSelf._userID : [
                Global.UserName : _userSelf._name
            ]
        ]
        
        let nudgeRef = Global.FirebaseRef.childByAppendingPath(Global.NudgePath)
        nudgeRef.updateChildValues(nudge, withCompletionBlock: {
            error, ref in
            if error != nil {
                print("cannot nudge")
                self._errorStr = Global.getErrorDetail(error)
            }
            self.nudgeCompleted()
        })
    }
    
    
    private func nudgeCompleted() {
        
        self._vc.nudgeCompleted()
    }
    
    
    private func observeNudge() {
        
        print("going to observer")
        
        _nudgeUserSelfRef.observeEventType(.ChildChanged, withBlock: {
            snapShot in
            print("childchanged ..... \(snapShot.key) .... \(snapShot.value)")
            self.analyseRelationChild(snapShot)
            self.updateRelation()
            self.observeNudgeEventHandler()
        })
    }
    
    
    private func observeNudgeEventHandler() {
        
        _vc.observeNudgeCompleted()
    }
    
    
    func dispose() {
        
        print("going to dispose")
        _nudgeUserSelfRef.removeAllObservers()
    }
}

