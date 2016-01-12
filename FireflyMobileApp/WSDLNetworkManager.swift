//
//  WSDLNetworkManager.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/19/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class WSDLNetworkManager: NSObject {
    
    func sharedClient() -> WSDLNetworkManager{
        
        let sharedClient = WSDLNetworkManager()
        return sharedClient
        
    }
    
    func createRequestWithService(serviceName: String, withParams: NSDictionary, completion: (result: JSON) -> Void) {

        let serviceUrl = String(format: "%@/%@", kBaseURL,serviceName)
    
        Alamofire.request(.POST, serviceUrl, parameters: withParams as? [String : AnyObject], encoding: .JSON).responseJSON(options: .MutableContainers) { (response) -> Void in
            if response.result.isSuccess == true{
                completion(result: JSON(response.result.value!))
            }else{
                completion(result: JSON(response.result.error!))
            }
        }
    }
        
    func test(serviceName:String, completion:(result:AnyObject) -> Void){
        
        Alamofire.request(.GET, serviceName, parameters: nil).responseJSON { (response) -> Void in
            completion(result: response.result.value!)
        }
        
    }


}
