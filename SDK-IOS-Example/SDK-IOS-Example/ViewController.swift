//
//  ViewController.swift
//  SDK-IOS-Example
//
//  Created by Hamid Qureshi on 04/01/2020.
//  Copyright © 2020 Hamid Qureshi. All rights reserved.
//

import UIKit
import Activeledger_SDK_IOS

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let activeledgerSDK = ActiveledgerSDK()
        
        activeledgerSDK.setConnection(prot: "http", baseURL: "testnet-uk.activeledger.io", port: "5260")

        activeledgerSDK.generateKeys(type: "RSA", name: "ASL")

        activeledgerSDK.onBoardKeys()
        
    }


}

