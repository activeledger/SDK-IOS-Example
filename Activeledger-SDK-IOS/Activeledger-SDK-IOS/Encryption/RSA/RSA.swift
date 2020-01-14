//
//  RSA.swift
//  Activeledger-SDK-IOS
//
//  Created by Hamid Qureshi on 10/01/2020.
//  Copyright © 2020 Hamid Qureshi. All rights reserved.
//

import Foundation
import SwiftyRSA

public class RSA {
    
    var publicKey: PublicKey? = nil
    var privateKey: PrivateKey? = nil
    
    public var publicKeyPEM: String = ""
    public var privateKeyPEM: String = ""
    
    func generateKeys() {
           print("Generating RSA Keys")

           do{
               let keyPair = try SwiftyRSA.generateRSAKeyPair(sizeInBits: 2048)

               privateKey = keyPair.privateKey
               publicKey = keyPair.publicKey

               privateKeyPEM = try keyPair.privateKey.pemString()
               publicKeyPEM = try keyPair.publicKey.pemString()

               print("---PUB---")
               print(publicKeyPEM)
               print("---PRI---")
               print(privateKeyPEM)

           } catch {
                  print(error)
              }

       }
    
    func signTransaction(txString: String) -> String {
    
        do{
            let clear = try ClearMessage(string: txString, using: .utf8)
            let signature = try clear.signed(with: privateKey!, digestType: .sha256)
            return signature.base64String
        } catch {
            print(error)
        }
        
        return ""
    }
    
}
