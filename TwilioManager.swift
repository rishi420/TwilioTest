//
//  Twilio.swift
//  PrivateText
//
//  Created by Warif Akhand Rishi on 8/20/17.
//  Copyright © 2017 Inventive Apps Ltd. All rights reserved.
//

import UIKit
import Alamofire

struct Twilio {
    static let SID = ""
    static let authToken = ""
}

let myTwilioNumber = "+XXXXXXXXXXX"

class TwilioManager: NSObject {
    
    enum PhoneDirection {
        case to
        case from
    }
    
    static let shared = TwilioManager()
    
    private override init() {
        super.init()
    }
    
    private func request(url: String, method: HTTPMethod, params: [String: Any]? = .none, completion: @escaping ([String: Any]?, Error?) -> ()) {
        // credentials
        let credentialData = "\(Twilio.SID):\(Twilio.authToken)".utf8
        let base64Credentials = Data(credentialData).base64EncodedString()
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        Alamofire.request(url, method: method, parameters: params,
                          encoding: URLEncoding.default, headers: headers)
            .authenticate(user: Twilio.SID,
                          password: Twilio.authToken).responseJSON { response in
                            
                            switch response.result {
                            case .success:
                                //print("success \(response)")
                                let responseObject = try? JSONSerialization.jsonObject(with: response.data!, options: []) as! [String: AnyObject]
                                completion(responseObject, nil)
                            case .failure(let error):
                                print(error)
                                completion(nil, error)
                            }
        }
    }
    
    func availableNumbers(countryISO: String, areaCode: String? = nil, inRegion: String? = nil, completion: @escaping ([String]?, String?) -> ()) {
        
        let url = "https://api.twilio.com/2010-04-01/Accounts/\(Twilio.SID)/AvailablePhoneNumbers/\(countryISO.uppercased())/Local.json"
        
        // params
        var params: [String: String]? = nil
        
        if let areaCode = areaCode {
            params = ["AreaCode": areaCode, "SmsEnabled": "True"] // 510
        } else if let inRegion = inRegion {
            params = ["InRegion": inRegion, "SmsEnabled": "True"]
        }
    
        request(url: url, method: .get, params: params) { (response, error) in
           
            guard let response = response else {
                print(error?.localizedDescription ?? "Unknown error")
                completion(nil, error?.localizedDescription)
                return
            }
            
            guard let phoneList = response["available_phone_numbers"] as? [[String: Any]] else {
                print("Number array parsing error")
                completion(nil, nil)
                return
            }
            
            let phoneNumbers = phoneList.map { $0["phone_number"] as! String }
            //print(phoneNumbers)
            completion(phoneNumbers, nil)
        }
    }
    
    func IncomingNumbers(completion: @escaping ([String]?, String?) -> ()) {
        
        let url = "https://api.twilio.com/2010-04-01/Accounts/\(Twilio.SID)/IncomingPhoneNumbers.json"
        request(url: url, method: .get) { (response, error) in
            guard let response = response else {
                print(error?.localizedDescription ?? "Unknown error")
                completion(nil, error?.localizedDescription)
                return
            }
            
            guard let phoneList = response["incoming_phone_numbers"] as? [[String: Any]] else {
                print("Number array parsing error")
                completion(nil, nil)
                return
            }
            
            let phoneNumbers = phoneList.map { $0["phone_number"] as! String }
            //print(phoneNumbers)
            completion(phoneNumbers, nil)
        }
    }
    
    func sendMessage(from: String, to: String, body: String, completion: @escaping (Bool, Any) -> ()) {
        
        let url = "https://api.twilio.com/2010-04-01/Accounts/\(Twilio.SID)/Messages.json"
        
        let params: [String: String] = ["From": from,
                                        "To": to,
                                        "Body": body]
        
        request(url: url, method: .post, params: params) { (response, error) in
            
            guard let response = response else {
                let errorMsg = error?.localizedDescription ?? "Unknown error"
                completion(false, errorMsg)
                return
            }
            
            guard let status = response["status"] as? String else {
                completion(false, response["message"] as? String ?? "")
                return
            }
            
            if status != "undelivered" && status != "failed" {
                completion(true, (msg: response["body"] as? String ?? "" , msgId: response["sid"] as? String ?? ""))
            } else {
                completion(false, response["message"] as? String ?? "")
            }
        }
    }
    
    func buyNumber(phoneNo: String, completion: @escaping ([String: Any]?, String?) -> ()) {
        
        let url = "https://api.twilio.com/2010-04-01/Accounts/\(Twilio.SID)/IncomingPhoneNumbers.json"
        //let params = ["AreaCode": "510"]
        let params = ["PhoneNumber": phoneNo]
        request(url: url, method: .post, params: params) { (response, error) in
            print("buyNumber \(String(describing: response))")
            completion(response, error?.localizedDescription)
        }
    }
    
    func messageList(phoneNo: String, phoneDirection: PhoneDirection, completion: @escaping ([[String: Any]]?, String?) -> ()) {
        
        let url = "https://api.twilio.com/2010-04-01/Accounts/\(Twilio.SID)/Messages.json"
        
        // TODO: PAGING
        let params = [(phoneDirection == .to) ? "To": "From": phoneNo]
        request(url: url, method: .get, params: params) { (response, error) in
            
            guard let response = response else {
                let errorMsg = error?.localizedDescription ?? "Unknown error"
                completion(nil, errorMsg)
                return
            }
            
            guard let messages = response["messages"] as? [[String: Any]] else {
                completion(nil, nil)
                return
            }
            
            completion(messages, nil)
        }
    }
}


