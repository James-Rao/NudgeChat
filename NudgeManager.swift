//
//  NudgeManager.swift
//  NudgeChat
//
//  Created by James Rao on 10/03/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import Foundation
import Firebase


class NudgeManager {
    
    var _nudges : [Nudger] = []
    var _friends : [Friend] = []
    var _beginFriends: [User] = []
    var _beFriendeds: [User] = []
    
    let _vc : NudgeViewController
    let _userSelf: User
    
    let _nudgeUserSelfRef : Firebase
    
    init(vc : NudgeViewController, userSelf: User) {
        
        _vc = vc
        _userSelf = userSelf
        
        // firebase stuff
        _nudgeUserSelfRef = Global.FirebaseRef.childByAppendingPath(Global.NudgePath).childByAppendingPath(_userSelf._userID)
        setFirebase()
    }
    
    
    private func setFirebase() {
        
        let userRef = Global.FirebaseRef.childByAppendingPath(Global.NudgePath)
        let userSelfRef = userRef.childByAppendingPath(_userSelf._userID)
        userSelfRef.observeSingleEventOfType(.Value, withBlock: {
            snapShot in
            self.extractNudges(snapShot)
        })
        
//        self.observeNudge()
//        self.observeChat()
//        self.setFirebaseCompleted()
    }
    
    
    private func extractNudgesChild(snapShot : FDataSnapshot) {
        
        //
        if snapShot.key == Global.NudgeBeginFriend {
            if snapShot.hasChildren() {
                snapShot.children.forEach({
                    childSnapShot in
                    let childSnapShotAs = childSnapShot as! FDataSnapshot
                    let newUser = User()
                    newUser._userID = childSnapShotAs.key
                    
                    childSnapShotAs.children.forEach({
                        grandChildSnapShot in
                        let grandChildSnapShotAs = grandChildSnapShot as! FDataSnapshot
                        if grandChildSnapShotAs.key == Global.UserName {
                            newUser._name = grandChildSnapShotAs.value as! String
                        }
                    })
                    
                    _beginFriends.append(newUser)
                })
            }
        } else if snapShot.key == Global.NudgeBeFriended {
            if snapShot.hasChildren() {
                snapShot.children.forEach({
                    childSnapShot in
                    let childSnapShotAs = childSnapShot as! FDataSnapshot
                    let newUser = User()
                    newUser._userID = childSnapShotAs.key
                    
                    childSnapShotAs.children.forEach({
                        grandChildSnapShot in
                        let grandChildSnapShotAs = grandChildSnapShot as! FDataSnapshot
                        if grandChildSnapShotAs.key == Global.UserName {
                            newUser._name = grandChildSnapShotAs.value as! String
                        }
                    })
                    
                    _beFriendeds.append(newUser)
                })
            }
        }
    }
    
    
    private func extractNudges(snapShot : FDataSnapshot) {
        
        _beginFriends.removeAll()
        _beFriendeds.removeAll()
        
        snapShot.children.forEach({
            childSnapShot in
            let childSnapShotAs = childSnapShot as! FDataSnapshot
            extractNudgesChild(childSnapShotAs)
        })
        
        self.updateNudges()
        self.observeNudge()
        self.observeChat()
        self.setFirebaseCompleted()
    }
    
    
    
    private func updateNudges() {
        
        _nudges.removeAll()
        _friends.removeAll()
        
        for item in _beFriendeds {
            if isItemInItems(item, set: _beginFriends) {
                let newFriend = Friend()
                newFriend._userID = item._userID
                newFriend._name = item._name
                _friends.append(newFriend)
            } else {
                let newNudger = Nudger()
                newNudger._name = item._name
                newNudger._userID = item._userID
                newNudger._relation = .BeFriended
                _nudges.append(newNudger)
            }
        }
        
        for item in _beginFriends {
            if !isItemInItems(item, set: _beFriendeds) {
                let newNudger = Nudger()
                newNudger._name = item._name
                newNudger._userID = item._userID
                newNudger._relation = .BeginFriend
                _nudges.append(newNudger)
            }
        }
    }
    
    
    private func isItemInItems(item: User, set: [User]) -> Bool {
        
        for item2 in set {
            if item2._userID == item._userID {
                return true
            }
        }
        
        return false
    }
    
    
    private func observeNudge() {
        
        _nudgeUserSelfRef.observeEventType(.ChildChanged, withBlock: {
            snapShot in
            print("childchanged ..... \(snapShot.key) .... \(snapShot.value)")
            self.nudgeChangedEventHandler(snapShot)
        })
        
        _nudgeUserSelfRef.observeEventType(.ChildAdded, withBlock: {
            snapShot in
            print("childchanged ..... \(snapShot.key) .... \(snapShot.value)")
            self.nudgeAddedEventHandler(snapShot)
        })
    }
    
    
    private func nudgeChangedEventHandler(snapShot: FDataSnapshot) {
        
        
    }
    
    
    private func nudgeAddedEventHandler(snapShot: FDataSnapshot) {
        
        
    }
    
    
    private func observeChat() {
        
    }
    
    
    private func setFirebaseCompleted(){
        
        _vc.initManagerCompleted()
    }
}

