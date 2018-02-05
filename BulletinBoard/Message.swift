//
//  Message.swift
//  BulletinBoard
//
//  Created by Christopher Thiebaut on 2/5/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import CloudKit

struct Message {
    let text: String
    let date: Date
    let cloudKitID: CKRecordID?
    
    //Convert to CKRecord to enable saving to CloudKit
    var asCKRecord: CKRecord {
        let record: CKRecord = cloudKitID == nil ? CKRecord(recordType: CloudKitKeys.type) : CKRecord(recordType: CloudKitKeys.type, recordID: cloudKitID!)
        record.setObject(text as CKRecordValue, forKey: CloudKitKeys.text)
        record.setObject(date as CKRecordValue, forKey: CloudKitKeys.date)
        return record
    }
    
    //Member-wise initializer
    init(text: String, date: Date = Date(), cloudKitID: CKRecordID? = nil){
        self.text = text
        self.date = date
        self.cloudKitID = cloudKitID
    }
    
    //Create from CKRecord (failable init)
    init?(fromCKRecord record: CKRecord){
        guard let text = record.object(forKey: CloudKitKeys.text) as? String else {
            print("Bad value for key: \(CloudKitKeys.text)")
            return nil
        }
        guard let date = record.object(forKey: CloudKitKeys.date) as? Date else {
            print("Bad value for key: \(CloudKitKeys.date)")
            return nil
        }
        
        cloudKitID = record.recordID
        self.text = text
        self.date = date
    }
}
