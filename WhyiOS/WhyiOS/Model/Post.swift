//
//  Reason.swift
//  WhyiOS
//
//  Created by Markus Varner on 9/6/18.
//  Copyright © 2018 Markus Varner. All rights reserved.
//

import Foundation

//Swift 3: Without Codable
struct Post {
    
     //MARK: - Keys
    
    //these are the keys that are in firebase, we do it like this when not using Codable
    private let nameKey = "name"
    private let cohortKey = "cohort"
    private let reasonKey = "reason"

    
    //MARK: - Properties
    
    let name: String
    let cohort: String
    let reason: String
    var uuid: UUID = UUID()
    
     //MARK: - Memberwise Init
    
    init(name: String, cohort: String, reason: String, uuid: UUID = UUID()) {
        self.name = name
        self.cohort = cohort
        self.reason = reason
        self.uuid = uuid
        
    }
    
     //MARK: - Failable Init
    
    //this is only for fetching data NOT posting
    //this essentially is an optional initialization that only inits if it has the dictionary and identifier
    init?(dictionary: [String : Any], identifier: String) {
        
        //unwrap all properties because it is a failable
        guard let name = dictionary[nameKey] as? String,
            let cohort = dictionary[cohortKey] as? String,
            let reason = dictionary[reasonKey] as? String else {return nil}
        
        self.name = name
        self.cohort = cohort
        self.reason = reason
       
        
        
    }
    
    //Firebase stores Dictionaries
    //this is a computed property that turns our swift object into a dictionary
    //we are going to turn this into data, and send it to firebase
    var dictionaryRepresentation: [String: Any] {
        let dictionary: [String : Any] = [
            nameKey: name,
            cohortKey: cohort,
            reasonKey: reason,
            
        ]
        return dictionary
    }
    //we have to send data across the network to place the dictionaryRep into Firebase
    var jsonData: Data? {
        do {
            //JSONSerialization is a swift 3 class that breaks the data down to binary data (data bits)
            //prettyPrinted just makes the output data more readable
            let data = try JSONSerialization.data(withJSONObject: dictionaryRepresentation, options: .prettyPrinted)
            return data
        } catch {
            print("Error with data in model variable jsonData")
            return nil
        }
        
    }
}



//Swift 4: Using Codable

//struct Post2: Codable {
//
//    let name: String
//    let reason: String
//    let cohort: String
//    let uuid: String = UUID().uuidString
//
//}
