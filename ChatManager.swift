//
//  ChatManager.swift
//  NudgeChat
//
//  Created by James Rao on 11/03/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import Foundation
import Firebase


class ChatManager {
    
    let _vc : ChatViewController
    let _userSelf: User
    let _selectedUser: User
    let _chatUserSelfRef : Firebase
    let _chatUserSelfandSelectedUserRef : Firebase
    let _chatSelectedUserandUserSelfRef : Firebase
    var _errorStr = ""
    var _chats : [Chat] = []
    
    init(vc: ChatViewController, selectedUser: User, userSelf: User) {
        
        _vc = vc
        _userSelf = userSelf
        _selectedUser = selectedUser
        
        _chatUserSelfRef = Global.FirebaseRef.childByAppendingPath(Global.ChatPath).childByAppendingPath(_userSelf._userID)
        _chatUserSelfandSelectedUserRef = _chatUserSelfRef.childByAppendingPath(_selectedUser._userID)
        _chatSelectedUserandUserSelfRef = Global.FirebaseRef.childByAppendingPath(Global.ChatPath).childByAppendingPath(_selectedUser._userID).childByAppendingPath(_userSelf._userID)
        
        setFirebase()
    }
    
    
    private func setFirebase() {
        
        // if the node doesn't exist, i would not get the notification. so i have to retrieve it first, and if no record, put anything there, and finally observe it.
        
        // retrieve
        _chatUserSelfandSelectedUserRef.observeSingleEventOfType(.Value, withBlock: {
            snapShot in
            if snapShot.value is NSNull {
                self.initUserSelfandSelectedUserChat() // also include observe but in its callback
                return
            } else {
                self.observeChat()
                self.setFirebaseCompleted()
            }
        })
    }
    
    
    private func observeChat() {
        
        _chatUserSelfandSelectedUserRef.observeEventType(.ChildAdded, withBlock: {
            snapShot in
            self.chatAddedHandler(snapShot)
        })
    }
    
    
    private func chatAddedHandler(snapShot : FDataSnapshot){
        
        print("chat added \(snapShot)")
        
        let newChat = Chat()
        newChat._time = snapShot.key
        snapShot.children.forEach({
            childSnapShot in
            
            let childSnapShotAs = childSnapShot as! FDataSnapshot
            if childSnapShotAs.key == Global.ChatUserID {
                newChat._userID = childSnapShotAs.value as! String
            } else if childSnapShotAs.key == Global.ChatMessage {
                newChat._message = childSnapShotAs.value as! String
            }
        })
        
        self._chats.append(newChat)
        
        //
        observeChatEventHandled()
    }
    
    
    private func observeChatEventHandled() {
        
        _vc.dataUpdated()
    }
    
    
    private func initUserSelfandSelectedUserChat() {
        
        
        let userSelftoSelectedUserChat  = [
            _selectedUser._userID : Global.AnyStr
        ]
        
        _chatUserSelfRef.updateChildValues(userSelftoSelectedUserChat, withCompletionBlock: {
            error, ref in
            if error != nil {
                self._errorStr = Global.getErrorDetail(error!)
                self.failtoSetFirebase()
                return
            } else {
                self.observeChat()
                self.setFirebaseCompleted()
            }
        })
    }
    
    
    private func failtoSetFirebase() {
        
        _vc.initManagerCompleted()
    }
    
    
    private func setFirebaseCompleted() {
        
        _vc.initManagerCompleted()
    }
    
    
    func dispose() {
        
        _chatUserSelfandSelectedUserRef.removeAllObservers()
    }
    
    
    func sendChat(message: String) {
        
        let time = String(NSDate())
        let newChat  = [
            time : [
                Global.ChatUserID : _userSelf._userID,
                Global.ChatMessage : message
            ]
        ]
        
        _errorStr = ""
        _chatUserSelfandSelectedUserRef.updateChildValues(newChat, withCompletionBlock: {
            error, ref in
            if error != nil {
                self._errorStr = Global.getErrorDetail(error!)
                self.failtoSendMessage()
                return
            } else {
                // set his 
                self._chatSelectedUserandUserSelfRef.updateChildValues(newChat, withCompletionBlock: {
                    error, ref in
                    if error != nil {
                        self._errorStr = Global.getErrorDetail(error!)
                        self.failtoSendMessage()
                        return
                    } else {
                        self.succeedtoSendMessage()
                    }
                })
            }
        })
    }
    
    
    private func failtoSendMessage() {
        
        //_vc.sendMessageCompleted()
    }
    
    
    private func succeedtoSendMessage() {
        
        //_vc.sendMessageCompleted()
    }
}