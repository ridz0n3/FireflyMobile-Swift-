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

class PaymentWebViewController: BaseViewController, UIScrollViewDelegate, WKScriptMessageHandler, UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate {
    
    @IBOutlet var contentView: UIView! = nil
    
    var paymentType = String()
    var webView: WKWebView?
    var urlString = String()
    var signature = String()
    var book = String()
    var manage = String()
    
    override func loadView() {
        super.loadView()
        
        let contentController = WKUserContentController()
        contentController.add(
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
        
        if book == "book"{
            let flightType = defaults.object(forKey: "flightType") as! String
            AnalyticsManager.sharedInstance.logScreen("\(GAConstants.paymentBookWebScreen) (\(flightType))")
        }
            
        else if manage == "manage"{
        AnalyticsManager.sharedInstance.logScreen(GAConstants.paymentManageWebScreen)
        }
        
        if paymentType == "CI" || paymentType == "PX"{
            setupLeftButton()
        }else{
            setupMenuButton()
        }
        
        let url = NSURL(string: urlString)
        let req = NSURLRequest(url: url! as URL)

        self.webView?.navigationDelegate = self
        self.webView!.uiDelegate = self;
        self.webView!.load(req as URLRequest)
        // Do any additional setup after loading the view.
    }
    
    var count = 0
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showLoading()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.sizeToFit()
        hideLoading()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        hideLoading()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        let check = String(describing: navigationAction.request.url).components(separatedBy: "paymentDDProcess") //.componentsSeparatedBy(by: "paymentDDProcess")
        
        if check.count == 1{
            
            if ((navigationAction.targetFrame?.isMainFrame) == nil){
                
                let url = navigationAction.request.url
                let app = UIApplication.shared as UIApplication
                
                if app.canOpenURL(url!){
                    app.openURL(url!)
                }
                
                //self.webView?.loadRequest(navigationAction.request)
            }
        }else{
            showLoading() 
            _ = self.webView?.load(navigationAction.request)
        }
        return nil;
    }
    
    func userContentController(_ userContentController: WKUserContentController,didReceive message: WKScriptMessage) {
        //
        if(message.name == "callbackHandler") {
            showLoading() 
            FireFlyProvider.request(.FlightSummary(signature), completion: { (result) -> () in
                
                switch result {
                case .success(let successResult):
                    do {
                        let json = try JSON(JSONSerialization.jsonObject(with: successResult.data, options: .mutableContainers))
                        
                        if json["status"] == "success"{
                            
                            defaults.set(json.object, forKey: "itinerary")
                            defaults.synchronize()
                            
                            let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                            let flightSummaryFlightVC = storyboard.instantiateViewController(withIdentifier: "FlightSummaryVC") as! FlightSummaryViewController
                            self.navigationController!.pushViewController(flightSummaryFlightVC, animated: true)
                            
                            if self.book == "book"{
                                AnalyticsManager.sharedInstance.logScreen(GAConstants.flightBookingSummaryScreen)
                            }
                                
                            else if self.manage == "manage"{
                                AnalyticsManager.sharedInstance.logScreen(GAConstants.manageFlightHomeScreen)
                            }
                            
                        }else if json["status"] == "error"{
                            showErrorMessage(json["message"].string!)
                        }else if json["status"].string == "401"{
                            hideLoading()
                            showErrorMessage(json["message"].string!)
                            InitialLoadManager.sharedInstance.load()
                            
                            for views in (self.navigationController?.viewControllers)!{
                                if views.classForCoder == HomeViewController.classForCoder(){
                                    _ = self.navigationController?.popToViewController(views, animated: true)
                                    AnalyticsManager.sharedInstance.logScreen(GAConstants.homeScreen)
                                }
                            }
                        }
                        hideLoading()
                    }
                    catch {
                        
                    }
                    
                case .failure(let failureResult):
                    hideLoading()
                    showErrorMessage(failureResult.localizedDescription)// .nsError.localizedDescription)
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
