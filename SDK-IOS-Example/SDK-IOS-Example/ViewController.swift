//
//  ViewController.swift
//  SDK-IOS-Example
//
//  Created by Hamid Qureshi on 04/01/2020.
//  Copyright © 2020 Hamid Qureshi. All rights reserved.
//

import UIKit
import Activeledger_SDK_IOS
import RxSwift

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var encryptionPicker: UIPickerView!
        
    @IBOutlet weak var lblPublicKey: UILabel!
    @IBOutlet weak var lblPrivateKey: UILabel!
    
    @IBOutlet weak var lblKeyName: UILabel!
    @IBOutlet weak var lblOnboardID: UILabel!
    
    private let bag = DisposeBag()
        
    let encryptionList = ["RSA", "EllipticCurve"]
    
    var encryptionSelected = "RSA"
    
    var activeledgerSDK: ActiveledgerSDK?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        activeledgerSDK = ActiveledgerSDK(http: "http", baseURL: "testnet-uk.activeledger.io", port: "5260")
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
      }
      
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent
        component: Int) -> Int {
        encryptionList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        encryptionList[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        encryptionSelected = encryptionList[row]
        print(encryptionSelected)
    }
    
    @IBAction func generateKeys(_ sender: UIButton) {
        print("generate key clicked")
        activeledgerSDK?.generateKeys(type: encryptionSelected, name: "ASL")
        lblPublicKey.text = activeledgerSDK?.getPublicKeyPEM()
        lblPrivateKey.text = activeledgerSDK?.getPrivateKeyPEM()
    }
    
    @IBAction func onboardKeys(_ sender: Any) {
        activeledgerSDK?.onBoardKeys()
            .subscribe(onSuccess: { response in
            
                print("-----result---")
                print(response)
                
                self.lblKeyName.text = self.activeledgerSDK?.onboardName
                self.lblOnboardID.text = self.activeledgerSDK?.onboardID
                
            }, onError: { error in
                print(error)
            }).disposed(by: bag)
        
    
    }
    
}

