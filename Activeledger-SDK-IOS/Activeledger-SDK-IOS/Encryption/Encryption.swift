//
//  Encryption.swift
//  Activeledger-SDK-IOS
//
//  Created by Hamid Qureshi on 10/01/2020.
//  Copyright © 2020 Hamid Qureshi. All rights reserved.
//

import Foundation

public class Encryption{
    
    private var rsaInstance: RSA
    private var ecInstance: EllipticCurve
    
    public var keyType: String = "RSA"

    public init() {
        rsaInstance = RSA()
        ecInstance = EllipticCurve()
    }
    
    public func generateKeys(type: String, name: String) {
        
        keyType = type
           
        if(type == "RSA"){
            rsaInstance.generateKeys()
        } else {
            ecInstance.generateKeys()
        }
           
    }
    
    public func getPublicKeyPEM() -> String {
        
        if(keyType == "RSA"){
            return rsaInstance.publicKeyPEM
        } else {
            return ecInstance.publicKeyPEM
        }
        
    }
    
    public func getPrivateKeyPEM() -> String {
        if(keyType == "RSA"){
            return rsaInstance.privateKeyPEM
        } else {
            return ecInstance.privateKeyPEM
        }
        
    }
    
    public func signTransaction(txString: String) -> String {
           
        var base64String = ""
           
        if(keyType == "RSA"){
            base64String = rsaInstance.signTransaction(txString: txString)
        } else {
            base64String = ecInstance.signTransaction(txString: txString)
        }
               
        print("------signature base 64---")
        print(base64String)
           
        return base64String
    }
    
    
}
