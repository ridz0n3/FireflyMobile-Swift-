//
//  Terms.swift
//  FireflyMobileApp
//
//  Created by Me-Tech on 12/22/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class TermsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
  
    @IBOutlet weak var tableView: UITableView!
    var tncArray: NSArray = []
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell")
        let myLabel = cell!.viewWithTag(1) as! UILabel
        let myWebView = cell!.viewWithTag(2)as! UIWebView
        
        myLabel.text = self.tncArray[indexPath.row]["title"] as? String
        myWebView.loadHTMLString(self.tncArray[indexPath.row]["body"] as! String, baseURL: nil)
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tncArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func viewDidLoad() {
        setupLeftButton()
        FireFlyProvider.request(.Terms(), completion: { (result) -> () in
            
            switch result {
            case .Success(let successResult):
                do {
                    self.hideHud()
                    let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                    
                    if json["status"].string == "success"{
                        self.showToastMessage(json["status"].string!)
                        self.tncArray = json["term"].arrayObject! as NSArray
                        self.tableView.reloadData()
                    }
                    else{
                        self.showToastMessage(json["terms"].string!)
                    }
                }
                catch {
                    
                }
                //print (successResult.data)
            case .Failure(let failureResult):
                print (failureResult)
            }
            
        })

    }
}

