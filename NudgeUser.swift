//
//  User.swift
//  NudgeChat
//
//  Created by James Rao on 7/03/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import Foundation
import CoreLocation

enum ChatType {
    
    case Message
}

class Chat {
    
    var _time : String!
    var _userID : String!
    //var _type : ChatType!
    var _message: String!
}

enum NudgeStatus {
    
    case NoRelation
    case BeginFriend
    case BeFriended
    case Friend
}


class PeopleAround : User {
    
    var _isOnline : Bool!
    var _location : CLLocationCoordinate2D!
}


class Nudger : User{
    
    var _relation : NudgeStatus!
}


class Friend : User{
    
}


class User {
    
    var _userID: String!
    var _name: String!
}


