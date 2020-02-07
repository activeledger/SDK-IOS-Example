//
//  ActiveledgerSDK.swift
//  Activeledger-SDK-IOS
//
//  Created by Hamid Qureshi on 04/01/2020.
//  Copyright © 2020 Hamid Qureshi. All rights reserved.
//

import Foundation
import LocalAuthentication
import SwiftyJSON
import RxSwift

public class ActiveledgerSDK {
    
    public var url: String = ""
    public var keyType: String = "RSA"
    public var keyName: String = "AwesomeKey"
    
    private var httpInstance: Http
    private var onboardTransactionInstance: OnboardTransaction
    private var encryptionInstance: Encryption
    private var eventInstance: SSEUtil
        
    public var onboardID = ""
    public var onboardName = ""

    public init(http: String, baseURL: String, port: String) {
        encryptionInstance = Encryption()
        onboardTransactionInstance = OnboardTransaction(instance: encryptionInstance)
        httpInstance = Http()
        eventInstance = SSEUtil()
        
        setConnection(http: http, baseURL: baseURL, port: port)
    }
    
    private func setConnection(http: String, baseURL: String, port: String) {
        
        url = "\(http)://\(baseURL):\(port)"

        print(" url is \(url)")
    }
    
    public func generateKeys(type: String, name: String) {
        
        keyType = type
        keyName = name
                
        encryptionInstance.generateKeys(type: type, name: name)
    }
    
    public func onBoardKeys() -> Single<JSON> {
                    
        let transaction  = generateOnboardTransaction()
        
        return executeTransaction(transaction: transaction)
            .map{ self.extractOnboardID(onboardResponse: $0) }
        
    }
    
    private func extractOnboardID(onboardResponse: JSON) -> JSON {
        
        onboardID = onboardResponse["$streams"]["new"][0]["id"].rawString() ?? ""
        onboardName = onboardResponse["$streams"]["new"][0]["name"].rawString() ?? ""
        
        print(onboardID)
        print(onboardName)
        
        return onboardResponse
    }
    
    public func generateOnboardTransaction() -> String{
        
        var kType = "RSA"
        
        if(keyType != "RSA"){
            kType = "secp256k1"
        } else {
            kType = "rsa"
        }
        
        return onboardTransactionInstance.oboardTransacction(keyType: kType, keyName: keyName)
    }
    
    
    public func executeTransaction(transaction: String) -> Single<JSON> {
        return httpInstance.executeTransaction(url: url, transaction: transaction)
    }
    
    public func getPublicKeyPEM() -> String {
        return encryptionInstance.getPublicKeyPEM()
    }
    
    public func getPrivateKeyPEM() -> String {
        return encryptionInstance.getPrivateKeyPEM()
    }
    
    public func subscribeToEvent(url: URL) -> Observable<Event> {
        return eventInstance.subscribeToEvent(url: url)
    }
    
    public func reConnectEvent(){
        eventInstance.connect()
    }
    
    public func disconnectEvent(){
        eventInstance.disconnect()
    }
    
}
