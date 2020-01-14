//
//  OnboardTransaction.swift
//  Activeledger-SDK-IOS
//
//  Created by Hamid Qureshi on 10/01/2020.
//  Copyright © 2020 Hamid Qureshi. All rights reserved.
//

import Foundation
import SwiftyJSON

public class OnboardTransaction {
    
    private var encryptionInstance: Encryption

    public init(instance: Encryption){
        encryptionInstance = instance
    }
    
    func oboardTransacction(keyType: String, keyName: String) -> String{
        
        do{
            
            let key = JSON([
                "type": keyType,
                "publicKey": encryptionInstance.getPublicKeyPEM()
            ])
            
            let input = JSON([
                keyName : key,
            ])
                    
            let tx = JSON([
                "$i": input,
                "$namespace": "default",
                "$contract": "onboard"
            ])
            
            let txData = try tx.rawData()

            var txString = String(data: txData, encoding: .utf8)!
                            
            txString = txString.replacingOccurrences(of: "\\/", with: "/")
            
            print("------tx Obj ---")
            print(txString)
            
            let base64String = encryptionInstance.signTransaction(txString: txString)
                            
            let sigs = JSON([
                keyName: base64String
            ])
            
            let onboardTransaction = JSON([
                "$tx": tx,
                "$selfsign": true,
                "$sigs": sigs
            ])
            
            let onboardData = try onboardTransaction.rawData()

            var onboardString = String(data: onboardData, encoding: .utf8)!
                      
            onboardString = onboardString.replacingOccurrences(of: "\\/", with: "/")
            
            print("------onboard tx ---")
            print(onboardString)

            return onboardString

        } catch {
            print(error)
        }
        
        return ""
        
    }
    
}
