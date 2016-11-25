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
        //AnalyticsManager.sharedInstance.logScreen("FAQ")
        AnalyticsManager.sharedInstance.logScreen(GAConstants.faqScreen)
        
        if secondLevel {
            setupLeftButton()
        }else{
            setupMenuButton()
        }
        webView.delegate = self
        webView.scrollView.delegate = self
        webView.scrollView.showsHorizontalScrollIndicator = false
        
        showLoading()
        FireFlyProvider.request(.GetTerm) { (result) -> () in
            switch result {
            case .success(let successResult):
                do {
                    let json = try JSON(JSONSerialization.jsonObject(with: successResult.data, options: .mutableContainers))
                    
                    if json["status"] == "success"{
                        print(json["url"])
                        
                        if let url = URL(string: json["url"].stringValue){
                            let request = URLRequest(url: url)
                            self.webView.loadRequest(request)
                        }
                    }else if json["status"] == "error"{
                        showErrorMessage(json["message"].string!)
                    }
                    
                }
                catch {
                    
                }
            case .failure(let failureResult):
                hideLoading()
                showErrorMessage(failureResult.localizedDescription)
                
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        hideLoading()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        hideLoading()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.x > 0)
        {
            scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)//(0, scrollView.contentOffset.y)
        }
    }
    
}
