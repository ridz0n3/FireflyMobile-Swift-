//
//  PaymentWebViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/6/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON

class PaymentWebViewController: BaseViewController, WKScriptMessageHandler {

    @IBOutlet var contentView: UIView! = nil
    
    var webView: WKWebView?
    var urlString = String()
    
    override func loadView() {
        super.loadView()
        
        let contentController = WKUserContentController()
        contentController.addScriptMessageHandler(
            self,
            name: "callbackHandler"
        )
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        self.webView = WKWebView(frame: self.view.frame, configuration: config)
        self.view = self.webView!
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuButton()
        let url = NSURL(string: urlString)
        let req = NSURLRequest(URL: url!)
        self.webView!.loadRequest(req)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func userContentController(userContentController: WKUserContentController,didReceiveScriptMessage message: WKScriptMessage) {
        if(message.name == "callbackHandler") {
            
            let signature = defaults.objectForKey("signature") as! String
            
            showHud()
            FireFlyProvider.request(.FlightSummary(signature), completion: { (result) -> () in
                self.hideHud()
                switch result {
                case .Success(let successResult):
                    do {
                        self.hideHud()
                        
                        let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                        
                        if json["status"] == "success"{
                            self.showToastMessage(json["status"].string!)
                            defaults.setObject(json.object, forKey: "itinerary")
                            defaults.synchronize()
                            
                            let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                            let flightSummaryFlightVC = storyboard.instantiateViewControllerWithIdentifier("FlightSummaryVC") as! FlightSummaryViewController
                            self.navigationController!.pushViewController(flightSummaryFlightVC, animated: true)
                            
                        }else{
                            self.showToastMessage(json["message"].string!)
                        }
                    }
                    catch {
                        
                    }
                    print (successResult.data)
                case .Failure(let failureResult):
                    print (failureResult)
                }
            })
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
