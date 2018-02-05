//
//  MessageController.swift
//  BulletinBoard
//
//  Created by Christopher Thiebaut on 2/5/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation

class MessageController {
    
    static let shared = MessageController()
    var messages: [Message] = [] {
        didSet {
            //Send notification to anyone listening for this change.
            NotificationCenter.default.post(name: NotificationKeys.messagesUpdated, object: self)
        }
    }
    
    private init() {
        loadMessages()
    }
    
    //save a new message
    func saveNewMessage(withText text: String){
        let message = Message(text: text)
        CloudKitManager.save(message: message) {[weak self] (success) in
            if success {
                self?.messages.insert(message, at: 0)
            }else{
                print("Did not add new message locally because it could not be inserted to cloudkit.")
            }
        }
    }
    
    func loadMessages(){
        CloudKitManager.loadAllMessages {[weak self] (records, error) in
            if let error = error {
                print("Error loading messages from CloudKit: \(error.localizedDescription)")
                return
            }
            guard let records = records else {
                return
            }
            self?.messages = records.flatMap({Message(fromCKRecord: $0)})
        }
    }
}
