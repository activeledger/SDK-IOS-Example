//
//  ActiveledgerSDK.swift
//  Activeledger-SDK-IOS
//
//  Created by Hamid Qureshi on 04/01/2020.
//  Copyright © 2020 Hamid Qureshi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyRSA
import SwiftyJSON
import LocalAuthentication

public class ActiveledgerSDK {
    
    public init() {}
    
    public var url: String = "123"
    public var keyType: String = "rsa"
    public var keyName: String = "AwesomeKey"
        
    var publicKey: PublicKey? = nil
    var privateKey: PrivateKey? = nil
        
    public var publicKeyPEM: String = ""
    public var privateKeyPEM: String = ""
    
    public func setConnection(prot: String, baseURL: String, port: String) {
        
        url = "\(prot)://\(baseURL):\(port)"

        print(" url is \(url)")
    }
    
    public func getKeyName() -> String {
        return keyName
    }
    
    public func generateKeys(type: String, name: String) {
        
        keyType = type
        keyName = name
                
        if(type == "ec"){
            generateECKeys()
        } else {
            generateRSAKeys()
        }
        
    }
    
    func generateRSAKeys() {
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
    
    var ECKeyPair: EllipticCurveKeyPair.Manager? = nil
    
    func generateECKeys() {
        print("Generating EC Keys")
        
//           struct Shared {
//                    keypair = {
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
//                }()
//            }
        
        do{
        
//            let key = try Shared.keypair.publicKey().data()
            let key = try ECKeyPair?.publicKey().data()
            publicKeyPEM = key?.PEM ?? "no key generated"
        }catch{
            print("Exception while generating EC keys")
        }
    }
    

    public func onBoardKeys(){
                    
        let transaction  = generateOnboardTransaction()
        executeTransaction(transaction: transaction)
    
    }
        
    
    func generateOnboardTransaction() -> String{
        
        var kType = "rsa"
        
        if(keyType == "ec"){
            kType = "secp256k1"
        }
        
            do{
            
                let key = JSON([
                    "type": kType,
                    "publicKey": publicKeyPEM
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
                
                let base64String = signOnboardTransaction(txString: txString)
                                
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
    
    var context: LAContext! = LAContext()

        
        func signOnboardTransaction(txString: String) -> String {
            
            var base64String = ""
            
            do {
            
                if(keyType == "ec"){
                    
                    guard let digest = txString.data(using: .utf8) else { return "No text to encrypt" }
                    
                    let signature = try ECKeyPair?.signUsingSha256(digest, context: self.context)
                    
                    base64String = signature?.base64EncodedString() ?? base64String
                
                } else {
                
                    let clear = try ClearMessage(string: txString, using: .utf8)
                    let signature = try clear.signed(with: privateKey!, digestType: .sha256)
        
                    base64String = signature.base64String

                }
                
            } catch {
                print(error)
            }
            
            print("------signature base 64---")
            print(base64String)
            
            return base64String
        }
    
    
    public func executeTransaction(transaction: String){
                    
          var request = URLRequest(url: URL(string: url)!)
          request.httpMethod = HTTPMethod.post.rawValue
          request.setValue("application/json", forHTTPHeaderField: "Content-Type")

          let data = (transaction.data(using: .utf8))! as Data

          request.httpBody = data
          
          AF.request(request)
                  .responseJSON {
                      response in
                      switch response.result {
                                    case .success:
                                        print(response)

                                        break
                                    case .failure(let error):

                                        print(error)
                                    }
               }
          
      }
    
}
