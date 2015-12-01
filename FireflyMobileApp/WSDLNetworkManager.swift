//
//  WSDLNetworkManager.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/19/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import Alamofire

class WSDLNetworkManager: NSObject {
    
    func sharedClient() -> WSDLNetworkManager{
        
        let sharedClient = WSDLNetworkManager()
        return sharedClient
        
    }
    
    func createRequestWithService(serviceName: String, withParams: NSDictionary, completion: (result: AnyObject) -> Void) {

        let serviceUrl = String(format: "%@%@", kBaseURL,serviceName)
        
        Alamofire.request(.POST, serviceUrl, parameters: withParams as? [String : AnyObject]).responseJSON(options: .MutableContainers) { (response) -> Void in
            if response.result.isSuccess == true{
                completion(result: response.result.value!)
            }else{
                completion(result: response.result.error!)
            }
        }
    }


}
