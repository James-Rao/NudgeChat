//
//  ConversationViewController.swift
//  NudgeChat
//
//  Created by James Rao on 11/03/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // property
    var _manager : ChatManager!
    let _chatSentCellIdentifier = "chatSentCell"
    let _chatReceivedCellIdentifier = "chatReceivedCell"
    
    // controls
    @IBOutlet weak var _chatTableView: UITableView!
    @IBOutlet weak var _messageTextField: UITextField!
    
    
    func initialize (selectedUser: User, userSelf: User) {
        
        view.userInteractionEnabled = false
        _manager = ChatManager(vc: self, selectedUser : selectedUser, userSelf : userSelf)
    }
    
    
    func initManagerCompleted() {
        
        if _manager._errorStr.isEmpty {
           view.userInteractionEnabled = true
        } else {
            print(_manager._errorStr)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _chatTableView.delegate = self
        _chatTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func sendChat(sender: AnyObject) {
    
        guard let str = _messageTextField.text where !str.isEmpty else {
            print("input something please")
            return
        }
        _manager.sendChat((_messageTextField.text)!)
    }

    
    func dataUpdated() {
        
        _chatTableView.reloadData()
        //let newIndexPath = NSIndexPath(forRow: _manager!._chats.count - 1, inSection: 0)
        //_chatTableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
    }
    
    
    
    
    // for the table view
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    //
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("chat count is \(_manager?._chats.count)")
        return (_manager?._chats.count)!
    }
    
    //
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let chats = (_manager?._chats)!
        let chatItem = chats[indexPath.row]
        if chatItem._userID == _manager._userSelf._userID { // userself . sent
            if let cell = tableView.dequeueReusableCellWithIdentifier(_chatSentCellIdentifier, forIndexPath: indexPath) as? ChatSentTableViewCell {
                cell._messageLabel.text = chatItem._message
                print("message: \(cell._messageLabel.text)")
                return cell
            }
        } else { // selected user. receive
            if let cell = tableView.dequeueReusableCellWithIdentifier(_chatReceivedCellIdentifier, forIndexPath: indexPath) as? ChatReceivedTableViewCell {
                cell._messageLabel.text = chatItem._message
                print("message: \(cell._messageLabel.text)")
                return cell
            }
        }
        
        return UITableViewCell()
    }

}
