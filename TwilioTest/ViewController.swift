//
//  ViewController.swift
//  TwilioTest
//
//  Created by fawad on 22/01/2017.
//  Copyright © 2017 fawad. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func postRequest(url: String, method: HTTPMethod, params: [String: Any]? = .none) {
        // credentials
        let credentialData = "\(K.Twilio.SID):\(K.Twilio.authToken)".utf8
        let base64Credentials = Data(credentialData).base64EncodedString()
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        Alamofire.request(url, method: method, parameters: params,
                          encoding: URLEncoding.default, headers: headers)
            .authenticate(user: K.Twilio.SID,
                          password: K.Twilio.authToken).responseJSON { response in
                            
                            switch response.result {
                            case .success:
                                print("success \(response)")
                            case .failure(let error):
                                print(error)
                            }
        }
    }
    
    @IBAction func availableNumbersButtonAciton(_ sender: Any) {
        print("availableNumbersButtonAciton")
        
        let url = "https://api.twilio.com/2010-04-01/Accounts/\(K.Twilio.SID)/AvailablePhoneNumbers/US/Local.json"
        
        // params
        let params = ["AreaCode": "510", "SmsEnabled": "True"]
        //let params = ["InRegion": "AR"]
        
        postRequest(url: url, method: .get, params: params)
    }
  
    @IBAction func IncomingNumbersButtonAciton(_ sender: Any) {
        print("IncomingNumbersButtonAciton")
        
        let url = "https://api.twilio.com/2010-04-01/Accounts/\(K.Twilio.SID)/IncomingPhoneNumbers.json"
        
        postRequest(url: url, method: .get)
    }
    
    @IBAction func sendMessageButtonAciton(_ sender: Any) {
        print("sendMessageButtonAciton")
        
        let url = "https://api.twilio.com/2010-04-01/Accounts/\(K.Twilio.SID)/Messages.json"
        
        // params
        let params: [String: String] = ["From": "FROM_NUMBER",
                                        "To": "TO_NUMBER",
                                        "Body": "Hello from Twilio, Rishi123"]
        
        postRequest(url: url, method: .post, params: params)
    }
    
    @IBAction func buyNumberButtonAciton(_ sender: Any) {
        print("buyNumberButtonAciton")
        
        let url = "https://api.twilio.com/2010-04-01/Accounts/\(K.Twilio.SID)/IncomingPhoneNumbers.json"
        
        let params = ["AreaCode": "510"]
        //let params = ["PhoneNumber": "+15103691691"]
        
        postRequest(url: url, method: .post, params: params)
    }
    
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}

