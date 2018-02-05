//
//  CloudKitManager.swift
//  BulletinBoard
//
//  Created by Christopher Thiebaut on 2/5/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitManager {
    
    private static let publicDatabase = CKContainer.default().publicCloudDatabase
    
    //save a message
    static func save(message: Message, completion: @escaping (Bool) -> Void){
        let record = message.asCKRecord
        publicDatabase.save(record) { (record, error) in
            if let error = error {
                print("Error saving record to CloudKit: \(error.localizedDescription)")
                completion(false)
            }else{
                print("Saved record to CloudKit")
                completion(true)
            }
        }
    }
    
    //load all messages
    static func loadAllMessages(completion: @escaping ([CKRecord]?,Error?) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: CloudKitKeys.type, predicate: predicate)
        let dateSort = NSSortDescriptor(key: CloudKitKeys.date, ascending: false)
        query.sortDescriptors = [dateSort]
        publicDatabase.perform(query, inZoneWith: nil, completionHandler: completion)
    }
}
