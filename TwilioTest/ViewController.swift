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
    
    @IBAction func availableNumbersButtonAciton(_ sender: Any) {
        print("availableNumbersButtonAciton")
        
        TwilioManager.shared.availableNumbers(countryISO: "US", areaCode: "510", inRegion: nil) { (phoneNumbers, errorMsg) in
            print(phoneNumbers ?? "no numbers")
        }
    }
  
    @IBAction func IncomingNumbersButtonAciton(_ sender: Any) {
        print("IncomingNumbersButtonAciton")
        
        TwilioManager.shared.IncomingNumbers { (phoneNumbers, errorMsg) in
            print(phoneNumbers ?? "no numbers")
        }
    }
    
    @IBAction func sendMessageButtonAciton(_ sender: Any) {
        print("sendMessageButtonAciton")
        
        TwilioManager.shared.sendMessage(from: "+17606643093", to: "+14156105816", body: "Hello from Twilio, Rishi") { (response, errorMsg) in
            //print("error: \(success)")
            print("response: \(response)")
        }
    }
    
    @IBAction func buyNumberButtonAciton(_ sender: Any) {
        print("buyNumberButtonAciton")
        
        // TODO: USE TwilioManager
        
//        let url = "https://api.twilio.com/2010-04-01/Accounts/\(K.Twilio.SID)/IncomingPhoneNumbers.json"
//        
//        let params = ["AreaCode": "510"]
//        //let params = ["PhoneNumber": "+15103691691"]
//        
//        postRequest(url: url, method: .post, params: params)
    }
    
    @IBAction func messageListOutgoingButtonAciton(_ sender: Any) {
        TwilioManager.shared.messageList(phoneNo: myTwilioNumber,phoneDirection: .to) { (messageHistoryList, errorMsg) in
            
            guard let histories = messageHistoryList else {
                print("Error")
                return
            }
            
            print(histories)
        }
    }
    
    @IBAction func messageListIncomingButtonAciton(_ sender: Any) {
        TwilioManager.shared.messageList(phoneNo: myTwilioNumber,phoneDirection: .from) { (messageHistoryList, errorMsg) in
            
            guard let histories = messageHistoryList else {
                print("Error")
                return
            }
            
            print(histories)
        }
    }
  
}

