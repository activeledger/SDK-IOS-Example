//
//  SSEUtil.swift
//  Activeledger-SDK-IOS
//
//  Created by Hamid Qureshi on 23/01/2020.
//  Copyright © 2020 Hamid Qureshi. All rights reserved.
//

import Foundation
import IKEventSource
import RxSwift

public class SSEUtil {
    
    private var eventSource: EventSource?
        
    public func subscribeToEvent(url: URL) -> Observable<Event> {
        
        eventSource = EventSource(url: url)
            
        connect()
        
        return Observable<Event>.create { observer in
           
            self.eventSource?.onOpen {
                observer.onNext(Event(type: "onOpen", id: "", event: "", data: "", statusCode: nil, reconnect: nil, error: nil))
            }

            self.eventSource?.onComplete { statusCode, reconnect, error in
                observer.onNext(Event(type: "onComplete", id: "", event: "", data: "", statusCode: statusCode, reconnect: reconnect, error: error))
            }
            
            self.eventSource?.onMessage { (id, event, data) in
                observer.onNext(Event(type: "onMessage", id: id ?? "", event: event ?? "", data: data ?? "", statusCode: nil, reconnect: nil, error: nil))
            }

            return Disposables.create()
        }
        
    }
    
    public func connect(){
        eventSource?.connect()
    }
    
    public func disconnect(){
        eventSource?.disconnect()
    }
    
}
