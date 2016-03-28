//
//  FAQViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech MacPro User 2 on 2/2/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import WebKit

class FAQViewController: BaseViewController, UIScrollViewDelegate, UIWebViewDelegate {
    
    var secondLevel = Bool()
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AnalyticsManager.sharedInstance.logScreen("FAQ")
        //If you want to implement the delegate
        
        if secondLevel {
            setupLeftButton()
        }else{
            setupMenuButton()
        }
        //webView.delegate = self
        webView.scrollView.delegate = self
        webView.scrollView.showsHorizontalScrollIndicator = false
        showLoading(self) //
        //showHud("open")
        
        FireFlyProvider.request(.GetTerm) { (result) -> () in
            switch result {
            case .Success(let successResult):
                do {
                    //showHud("close")
                    let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                    
                    if json["status"] == "success"{
                        print(json["url"])
                        
                        if let url = NSURL(string: json["url"].stringValue){
                            let request = NSURLRequest(URL: url)
                            self.webView.loadRequest(request)
                        }
                    }else if json["status"] == "error"{
                        showErrorMessage(json["message"].string!)
                    }
                    hideLoading(self)
                }
                catch {
                    
                }
            case .Failure(let failureResult):
                //hideLoading(self)
            
                showErrorMessage(failureResult.nsError.localizedDescription)
                showHud("close")
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        //showLoading(self)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        webView.sizeToFit()
        showHud("close")
        //hideLoading(self)
    }
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        showHud("close")
        //hideLoading(self)
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentOffset.x > 0)
        {
            scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y)
        }
    }
    
}
