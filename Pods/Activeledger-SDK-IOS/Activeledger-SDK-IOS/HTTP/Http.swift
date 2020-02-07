//
//  Http.swift
//  Activeledger-SDK-IOS
//
//  Created by Hamid Qureshi on 10/01/2020.
//  Copyright © 2020 Hamid Qureshi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RxSwift

public class Http {
    
    public func executeTransaction(url: String, transaction: String) -> Single<JSON> {
                
        return Single<JSON>.create{ (observer) -> Disposable in
                     
           
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
                    
                        do{
                            let json = try JSON(data: response.data!)
        
                            observer(.success(json))

                        } catch (let error) {
                            observer(.error(error))
                        }
                       
                        break
                        
                    case .failure(let error):
                        observer(.error(error))
                        
                   }
                    
            }
                        
            return Disposables.create()
            
        }
           
    }
    
}
