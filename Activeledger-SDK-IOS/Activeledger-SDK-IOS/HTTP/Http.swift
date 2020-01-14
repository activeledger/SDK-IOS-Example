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

public class Http {
    
    public func executeTransaction(url: String, transaction: String) -> JSON? {
                     
           
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let data = (transaction.data(using: .utf8))! as Data
        
        var resp: JSON? = nil

        request.httpBody = data

        AF.request(request)
            .responseJSON {
                response in
                
                switch response.result {
    
                case .success:
                
                    print(response)
                    resp = JSON(response)

                    break
                    
                case .failure(let error):
                    print(error)
                
               }
                
        }
        
        return resp
           
    }
    
}
