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

class FAQViewController: BaseViewController, UIWebViewDelegate, UIScrollViewDelegate {

    private var faqWebView: WKWebView!
    
    override func loadView() {
        faqWebView = WKWebView()
        
        //If you want to implement the delegate
        //webView?.navigationDelegate = self
        
        view = faqWebView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLeftButton()
       self.faqWebView.scrollView.delegate = self
        self.faqWebView.scrollView.showsHorizontalScrollIndicator = false
        self.showHud()
        FireFlyProvider.request(.GetTerm) { (result) -> () in
            switch result {
            case .Success(let successResult):
                do {
                    self.hideHud()
                    let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                    
                    if json["status"] == "success"{
                        print(json["url"])
                        
                        if let url = NSURL(string: json["url"].stringValue){
                            let request = NSURLRequest(URL: url)
                            self.faqWebView.loadRequest(request)
                        }
                    }
                
                    else{
                    self.showToastMessage(json["message"].string!)
                }
            }
            catch {
                
            }
            case .Failure(let failureResult):
                print (failureResult)
            }
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentOffset.x > 0)
        {
            scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y)
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        faqWebView.sizeToFit()
    }

}
