//
//  PeopleManager.swift
//  NudgeChat
//
//  Created by James Rao on 4/03/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation


class PeopleManager : NSObject, CLLocationManagerDelegate  {
    
    var _vc: PeopleViewController!
    var _peopleAround: [PeopleAround] = []
    var _userSelf: User!
    var _errorStr: String? = nil
    
    var locationManager: CLLocationManager!
    
    
    init(vc: PeopleViewController, userSelf: User) {
        
        super.init()

        _vc = vc
        _userSelf = userSelf
        
        // init location
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // firebase stuff
        setFirebase()
    }
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:\(error.localizedDescription)")
        
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //print("LOCATION: \((locations.first?.coordinate.latitude)!), \((locations.first?.coordinate.longitude)!)")
        let latitude = String(stringInterpolationSegment: (locations.first?.coordinate.latitude)!)
        let longitude = String(stringInterpolationSegment: (locations.first?.coordinate.longitude)!)
        
        // 
        let peopleRef = Global.FirebaseRef.childByAppendingPath(Global.PeopleAroundPath)
        let peopleSelfLocationRef = peopleRef.childByAppendingPath(_userSelf._userID).childByAppendingPath(Global.PeopleAroundLocation)
        let newLocation = [
            Global.PeopleAroundLocationAltitude : String(latitude),
            Global.PeopleAroundLocationLongitude : String(longitude)
        ]
        peopleSelfLocationRef.setValue(newLocation)
    }
    
    
    private func setFirebase() {
        
        let userRef = Global.FirebaseRef.childByAppendingPath(Global.UserPath)
        let userSelfRef = userRef.childByAppendingPath(_userSelf._userID)
        userSelfRef.observeSingleEventOfType(.Value, withBlock: {
            snapShot in
            if snapShot.value is NSNull {
                self.initUserAndNudgeAndChat() // also include observe but in its callback
            } else {
                self.observePeopleAround()
                self.observeNudge()
                self.observeChat()
                self.setFirebaseCompleted()
            }
        })
    }
    
    
    private func observeChat() {
        
        let chatRef = Global.FirebaseRef.childByAppendingPath(Global.ChatPath)
        let chatSelfRef = chatRef.childByAppendingPath(_userSelf._userID)
        
        chatSelfRef.observeEventType(.ChildChanged, withBlock: {
            snapShot in
            self.chatChangedEventHandler(snapShot)
        })
        
        chatSelfRef.observeEventType(.ChildAdded, withBlock: {
            snapShot in
            self.chatAddedEventHandler(snapShot)
        })
    }
    
    
    private func chatChangedEventHandler(snapShot: FDataSnapshot) {
        
        
    }
    
    
    private func chatAddedEventHandler(snapShot: FDataSnapshot) {
        
        
    }
    
    
    private func observeNudge() {
        
        let nudgeRef = Global.FirebaseRef.childByAppendingPath(Global.NudgePath)
        let nudgeSelfRef = nudgeRef.childByAppendingPath(_userSelf._userID)

        nudgeSelfRef.observeEventType(.ChildChanged, withBlock: {
            snapShot in
            self.nudgeChangedEventHandler(snapShot)
        })
        
        nudgeSelfRef.observeEventType(.ChildAdded, withBlock: {
            snapShot in
            self.nudgeAddedEventHandler(snapShot)
        })

    }
    
    
    private func nudgeChangedEventHandler(snapShot: FDataSnapshot) {
        
        
    }
    
    
    private func nudgeAddedEventHandler(snapShot: FDataSnapshot) {
        
        
    }
    
    
    // make sure user, chat, nudge are already done.
    private func setPeopleAround() {
        
        let newPeople = [
            Global.PeopleAroundLocation : [
                Global.PeopleAroundLocationAltitude : "0",
                Global.PeopleAroundLocationLongitude : "0"
            ],
            Global.PeopleAroundIsOnline : "1", // 1 means yes
            
            // for convenience
            Global.PeopleAroundName : _userSelf._name
        ]
        
        let peopleAroundRef = Global.FirebaseRef.childByAppendingPath(Global.PeopleAroundPath)
        let peopleSelfRef = peopleAroundRef.childByAppendingPath(_userSelf._userID)
        peopleSelfRef.setValue(newPeople, withCompletionBlock:{
            error, ref in
            if error != nil {
                self._errorStr = Global.getErrorDetail(error)
                self.failtoSetFirebase()
                return
            } else {
                self.observePeopleAround()
                self.observeChat()
                self.observeNudge()
                self.setFirebaseCompleted()
            }
        })
    }
    
    
    
    private func observePeopleAround() {
        
        let peopleAroundRef = Global.FirebaseRef.childByAppendingPath(Global.PeopleAroundPath)
        peopleAroundRef.observeEventType(.ChildChanged, withBlock: {
            snapShot in
            self.peopleChangedEventHandler(snapShot)
        })
        
        peopleAroundRef.observeEventType(.ChildAdded, withBlock: {
            snapShot in
            self.peopleAddedEventHandler(snapShot)
        })
    }
    
    
    private func peopleChangedEventHandler(snapShot: FDataSnapshot) {
        
        print("people change \(snapShot)")
    }
    
    
    private func peopleAddedEventHandler(snapShot: FDataSnapshot) {
        
        print("people add \(snapShot)")
        
        let newPeople = PeopleAround()
        let userID = snapShot.key
        if userID == _userSelf._userID {
            return
        }
        newPeople._userID = userID
        snapShot.children.forEach({
            childSnapShot in
            let childData = childSnapShot as! FDataSnapshot
            if childData.key == Global.PeopleAroundIsOnline {
                newPeople._isOnline = (childData.value as! String) == "1" ? true : false
            } else if childData.key == Global.PeopleAroundName {
                newPeople._name = childData.value as! String
            } else if childData.key == Global.PeopleAroundLocation {
                var latitude : Double!
                var longitude : Double!
                childData.children.forEach({
                    grandChildSnapShot in
                    let grandChildData = grandChildSnapShot as! FDataSnapshot
                    if grandChildData.key == Global.PeopleAroundLocationAltitude {
                        latitude = (grandChildData.value as! NSString).doubleValue
                    } else if grandChildData.key == Global.PeopleAroundLocationLongitude {
                        longitude = (grandChildData.value as! NSString).doubleValue
                    }
                })
                newPeople._location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            }
        })
        
        //
        _peopleAround.append(newPeople)
        _vc.peopleAddedCompleted()
    }
    
    
    // only set user
    private func initUserAndNudgeAndChat() {
        
        
        let userAndNudgeAndChat : [NSObject : AnyObject] = [
        
            Global.UserPath + "/" + _userSelf._userID : [
                Global.UserName : _userSelf._name
            ],
            Global.NudgePath + "/" + _userSelf._userID : [
                Global.NudgeBeginFriend : Global.AnyStr,
                Global.NudgeBeFriended : Global.AnyStr,
                Global.NudgeBeginBlock : Global.AnyStr,
                Global.NudgeBeBlocked : Global.AnyStr
            ],
            Global.ChatPath + "/" + _userSelf._userID : Global.AnyStr
        ]

        Global.FirebaseRef.updateChildValues(userAndNudgeAndChat, withCompletionBlock: {
            error, ref in
            if error != nil {
                self._errorStr = Global.getErrorDetail(error!)
                self.failtoSetFirebase()
                return
            } else {
                self.setPeopleAround()
            }
        })
    }
    
    
    private func failtoSetFirebase() {
        
        _vc.initializeManagerCompleted()
    }
    
    
    private func setFirebaseCompleted() {
        
        _vc.initializeManagerCompleted()
    }
}



