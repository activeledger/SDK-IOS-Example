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


public class ActiveledgerSDK {
    
    public init() {}
    
    public var url: String = "123"
    public var keyType: String = "RSA"
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
                
        if(type == "EC"){
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
    
    func generateECKeys() {
        print("Generating EC Keys")
    }
    

    public func onBoardKeys(){
                    
        let transaction  = generateOnboardTransaction()
        executeTransaction(transaction: transaction)
    
    }
        
    
    func generateOnboardTransaction() -> String{
        
                do{
                
                    let key = JSON([
                        "type": "rsa",
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
        
        func signOnboardTransaction(txString: String) -> String {
            
            if(keyType == "EC"){
                
            
            } else {
            
                do {
        
                    let clear = try ClearMessage(string: txString, using: .utf8)
                    let signature = try clear.signed(with: privateKey!, digestType: .sha256)
        
                    let base64String = signature.base64String
        
                    print("------signature base 64---")
                    print(base64String)
        
                    return base64String
        
                } catch {
                    print(error)
                }
                
            }
            return ""
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
