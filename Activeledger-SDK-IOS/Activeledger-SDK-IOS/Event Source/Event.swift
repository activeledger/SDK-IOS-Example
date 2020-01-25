//
//  Event.swift
//  Activeledger-SDK-IOS
//
//  Created by Hamid Qureshi on 23/01/2020.
//  Copyright © 2020 Hamid Qureshi. All rights reserved.
//

import Foundation

public class Event {
    
    public let type: String
    public let id: String
    public let event: String
    public let data: String
    
    public var statusCode: Int? = nil
    public var reconnect: Bool? = nil
    public var error: NSError? = nil
    
    init(type: String, id: String, event: String, data: String, statusCode: Int?, reconnect: Bool?, error: NSError?){
        self.type = type
        self.id = id
        self.event = event
        self.data = data
        
        self.statusCode = statusCode
        self.reconnect = reconnect
        self.error = error
    }
    
}
