//
//  BoardingPassViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/17/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class BoardingPassViewController: CommonSearchDetailViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AnalyticsManager.sharedInstance.logScreen(GAConstants.boardingPassScreen)
    }
    
    @IBAction func ContinueBtnPressed(sender: AnyObject) {
        
        
        validateForm()
        
        if isValidate{
            
            let deptArr = (self.formValues()[Tags.ValidationDeparting] as! String).componentsSeparatedByString(" (")
            
            let arrivalArr = (self.formValues()[Tags.ValidationArriving] as! String).componentsSeparatedByString(" (")
            
            let signature = defaults.objectForKey("signatureLoad") as! String
            let pnr = self.formValues()[Tags.ValidationConfirmationNumber] as! String
            let departure_station_code = getStationCode(deptArr[0], locArr: location, direction : "Departing")
            //self.formValues()[Tags.ValidationDeparting] as! String
            let arrival_station_code = getStationCode(arrivalArr[0], locArr: travel, direction : "Arriving")
            showLoading() 
            FireFlyProvider.request(.RetrieveBoardingPass(signature, pnr, departure_station_code, arrival_station_code, ""), completion: { (result) -> () in
                
                switch result {
                case .Success(let successResult):
                    do {
                        let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                        
                        if  json["status"].string == "success"{
                            var i = 0
                            var j = 0
                            var dict = [String:AnyObject]()
                            for info in json["boarding_pass"].arrayValue{
                                let index = "\(j)"
                                let imageURL = info.dictionaryObject!["QRCodeURL"] as? String
                                Alamofire.request(.GET, imageURL!).response(completionHandler: { (request, response, data, error) -> Void in
                                    
                                    dict.updateValue(UIImage(data: data!)!, forKey: "\(index)")
                                    i += 1
                                    
                                    if i == j{
                                        
                                        let storyboard = UIStoryboard(name: "BoardingPass", bundle: nil)
                                        let boardingPassDetailVC = storyboard.instantiateViewControllerWithIdentifier("BoardingPassDetailVC") as! BoardingPassDetailViewController
                                        boardingPassDetailVC.boardingPassData = json["boarding_pass"].arrayObject!
                                        boardingPassDetailVC.imgDict = dict
                                        self.navigationController!.pushViewController(boardingPassDetailVC, animated: true)
                                        hideLoading()
                                    }
                                })
                                j += 1
                            }
                        }else{
                            
                            hideLoading()
                            
                            showErrorMessage(json["message"].string!)
                        }
                    }
                    catch {
                        hideLoading()
                        showErrorMessage("We are unable to locate the itinerary. Please verify the information is correct and try again.")
                    }
                    
                case .Failure(let failureResult):
                    
                    hideLoading()
                    showErrorMessage(failureResult.nsError.localizedDescription)
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
