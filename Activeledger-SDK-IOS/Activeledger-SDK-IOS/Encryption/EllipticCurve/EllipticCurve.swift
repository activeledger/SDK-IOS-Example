//
//  EllipticCurve.swift
//  Activeledger-SDK-IOS
//
//  Created by Hamid Qureshi on 10/01/2020.
//  Copyright © 2020 Hamid Qureshi. All rights reserved.
//

import Foundation
import LocalAuthentication

public class EllipticCurve {
    
    var ECKeyPair: EllipticCurveKeyPair.Manager? = nil
    public var publicKeyPEM: String = ""
    public var privateKeyPEM: String = ""
    var context: LAContext! = LAContext()
    
    func generateKeys() {
        
        print("Generating EC Keys")
            
        EllipticCurveKeyPair.logger = { print($0) }
        let publicAccessControl = EllipticCurveKeyPair.AccessControl(protection: kSecAttrAccessibleAlwaysThisDeviceOnly, flags: [])
        let privateAccessControl = EllipticCurveKeyPair.AccessControl(protection: kSecAttrAccessibleAlways, flags: [])

        let config = EllipticCurveKeyPair.Config(
            publicLabel: "ttt.sign.public",
            privateLabel: "ttt.sign.private",
            operationPrompt: "Sign transaction",
            publicKeyAccessControl: publicAccessControl,
            privateKeyAccessControl: privateAccessControl,
            token: .secureEnclaveIfAvailable)
        ECKeyPair = EllipticCurveKeyPair.Manager(config: config)
 
            
        do{
            let key = try ECKeyPair?.publicKey().data()
            publicKeyPEM = key?.PEM ?? "no key generated"
        }catch{
            print("Exception while generating EC keys")
        }
        
    }
    
    func signTransaction(txString: String) -> String {
    
        do{
            guard let digest = txString.data(using: .utf8) else { return "No text to encrypt" }
            let signature = try ECKeyPair?.signUsingSha256(digest, context: self.context)
            return signature?.base64EncodedString() ?? ""
        } catch {
            print(error)
        }
        
        return ""
    }
    
}
