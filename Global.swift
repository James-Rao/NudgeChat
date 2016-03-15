//
//  Global.swift
//  NudgeChat
//
//  Created by James Rao on 4/03/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import Foundation
import Firebase



class Global {
    
    static let DefaultDistance = CGFloat(0)
    static let DefaultDistance1 = CGFloat(8)
    static let AnyStr = "anything"
    static let FirebaseRef = Firebase(url: "https://nudgechat.firebaseio.com")
    
    static let UserPath = "user"
    static let PeopleAroundPath = "peoplearound"
    static let NudgePath = "nudge"
    static let ChatPath = "chat"
    
    // nudge node
    // nudge - id1 - id2
    // must face the simultaneous problem when create nodes
    static let NudgeProfileImageUrl = "profileimageurl"
    static let NudgeLastChatTime = "lastchattime"
    static let NudgeLastChatMessage = "lastchatmessage"
    static let NudgeBeginFriend = "beginfriend"
    static let NudgeBeFriended = "befriended"
    static let NudgeBeginBlock = "beginblock"
    static let NudgeBeBlocked = "beblocked"
    
    
    // user node
    // user - id
    static let UserName = "name"
    
    
    // peoplearound node
    static let PeopleAroundLocation = "location"
    static let PeopleAroundLocationAltitude = "altitude"
    static let PeopleAroundLocationLongitude = "longitude"
    static let PeopleAroundIsOnline = "isonline"
    static let PeopleAroundName = "name"
    
    
    // chat
    static let ChatUserID = "userid"
    //static let ChatType = "type"
    static let ChatMessage = "message"
    
    
    static func addCover(view: UIView) {
        
        //view.backgroundColor = UIColor.grayColor()
        let cover = UIView()
        cover.frame = CGRect(origin: view.frame.origin, size: view.frame.size)
        cover.backgroundColor = UIColor.grayColor()
        cover.opaque = false
        cover.alpha = 0.5
        view.addSubview(cover)
    }
    
    
    
    static func getErrorDetail(error: NSError) -> String {
        
        var errorStr = ""
        if let errorCode = FAuthenticationError(rawValue: error.code) {
            print(error.description)
            switch (errorCode) {
            case .InvalidEmail:
                errorStr = "The specified email address is invalid"
            case .EmailTaken:
                errorStr = "The specified email address is already in use"
            case .UserDoesNotExist:
                errorStr = "The specified user does not exist"
            default:
                errorStr = "something wrong"
            }
        }
        
        return errorStr
    }
    
    
    static func isValidEmail(email: String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(email)
    }
}