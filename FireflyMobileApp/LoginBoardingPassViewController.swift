//
//  LoginBoardingPassViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 2/16/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import RealmSwift
import Realm

class LoginBoardingPassViewController: CommonListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AnalyticsManager.sharedInstance.logScreen(GAConstants.loginBoardingPassScreen)
        
        loadBoardingPassList()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginBoardingPassViewController.refreshBoardingPassList(_:)), name: "reloadBoardingPassList", object: nil)
    }
    
    func loadBoardingPassList(){
        
        let userInfo = defaults.objectForKey("userInfo") as! [String : String]
        var userData : Results<UserList>! = nil
        userData = realm.objects(UserList)
        mainUser = userData.filter("userId == %@", userInfo["username"]!)
        
        if mainUser.count != 0{
            pnrList = mainUser[0].pnr.sorted("departureDateTime", ascending: false)
        }
        
    }
    
    func refreshBoardingPassList(notif : NSNotification){
        
        signature = mainUser[0].signature
        
        loadBoardingPassList()
        LoginMobileCheckinTableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let listPnr = pnrList[indexPath.row]
        let boardingPass = listPnr.boardingPass
        
        if boardingPass.count != 0{
            
            let storyboard = UIStoryboard(name: "BoardingPass", bundle: nil)
            let boardingPassDetailVC = storyboard.instantiateViewControllerWithIdentifier("BoardingPassDetailVC") as! BoardingPassDetailViewController
            boardingPassDetailVC.boardingList = boardingPass
            boardingPassDetailVC.isOffline = true
            self.navigationController!.pushViewController(boardingPassDetailVC, animated: true)
            checkBoardingPass(listPnr["pnr"] as! String, departCode: listPnr["departureStationCode"] as! String, arrivalCode: listPnr["arrivalStationCode"] as! String, isExist : true)
        }else{
            showLoading()
            checkBoardingPass(listPnr["pnr"] as! String, departCode: listPnr["departureStationCode"] as! String, arrivalCode: listPnr["arrivalStationCode"] as! String, isExist: false)
        }
    }
    
    func checkBoardingPass(pnr : String, departCode : String, arrivalCode : String, isExist : Bool){
        
        FireFlyProvider.request(.RetrieveBoardingPass(signature, pnr, departCode, arrivalCode, userId), completion: { (result) -> () in
            switch result {
            case .Success(let successResult):
                do {
                    let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                    
                    if  json["status"].string == "success"{
                        
                        self.saveBoardingPass(json["boarding_pass"].arrayObject!, pnrStr: pnr)
                        
                        var i = 0
                        var j = 0
                        var dict = [String:AnyObject]()
                        for info in json["boarding_pass"].arrayObject!{
                            let index = "\(j)"
                            let imageURL = info["QRCodeURL"] as! String
                            
                            Alamofire.request(.GET, imageURL).response(completionHandler: { (request, response, data, error) -> Void in
                                
                                dict.updateValue(UIImage(data: data!)!, forKey: "\(index)")
                                i += 1
                                
                                if i == j{
                                    
                                    if !isExist{
                                        let storyboard = UIStoryboard(name: "BoardingPass", bundle: nil)
                                        let boardingPassDetailVC = storyboard.instantiateViewControllerWithIdentifier("BoardingPassDetailVC") as! BoardingPassDetailViewController
                                        boardingPassDetailVC.boardingPassData = json["boarding_pass"].arrayObject!
                                        boardingPassDetailVC.imgDict = dict
                                        self.navigationController!.pushViewController(boardingPassDetailVC, animated: true)
                                        hideLoading()
                                    }else{
                                        let info = ["boardingPassData" : json["boarding_pass"].arrayObject!, "imgDict" : dict]
                                        
                                        NSNotificationCenter.defaultCenter().postNotificationName("reloadBoardingPass", object: nil, userInfo: info as [NSObject : AnyObject])
                                    }
                                    
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
                    
                }
                
            case .Failure(let failureResult):
                
                
                
                if !isExist{
                    showErrorMessage("Boarding Pass has not been saved")
                }
                hideLoading()
            }
            
        })
        
    }
    
    func saveBoardingPass(boardingPassArr : [AnyObject], pnrStr : String){
        
        let userInfo = defaults.objectForKey("userInfo")
        var userList = Results<UserList>!()
        userList = realm.objects(UserList)
        
        let mainUser = userList.filter("userId == %@",userInfo!["username"] as! String)
        
        let pnr = PNRList()
        pnr.pnr = pnrStr
        
        var count = 0
        for boardingInfo in boardingPassArr{
            let boardingPass = BoardingPassList()
            count += 1
            
            if boardingPassArr.count == count{
                
                let formater = NSDateFormatter()
                formater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                
                pnr.departureStationCode = boardingInfo["DepartureStationCode"] as! String
                pnr.arrivalStationCode = boardingInfo["ArrivalStationCode"] as! String
                pnr.departureDateTime = formater.dateFromString(boardingInfo["DepartureDateTime"] as! String)!
                pnr.departureDayDate = boardingInfo["DepartureDate"] as! String
            }
            
            let url = NSURL(string: boardingInfo["QRCodeURL"] as! String)
            let data = NSData(contentsOfURL: url!)
            
            boardingPass.name = boardingInfo["Name"] as! String
            boardingPass.departureStation = boardingInfo["DepartureStation"] as! String
            boardingPass.arrivalStation = boardingInfo["ArrivalStation"] as! String
            boardingPass.departureDate = boardingInfo["DepartureDate"] as! String
            boardingPass.departureTime = boardingInfo["DepartureTime"] as! String
            boardingPass.boardingTime = boardingInfo["BoardingTime"] as! String
            boardingPass.fare = boardingInfo["Fare"] as! String
            boardingPass.flightNumber = boardingInfo["FlightNumber"] as! String
            boardingPass.SSR = boardingInfo["SSR"] as! String
            boardingPass.QRCodeURL = data!
            boardingPass.recordLocator = boardingInfo["RecordLocator"] as! String
            boardingPass.arrivalStationCode = boardingInfo["ArrivalStationCode"] as! String
            boardingPass.departureStationCode = boardingInfo["DepartureStationCode"] as! String
            
            pnr.boardingPass.append(boardingPass)
        }
        
        
        if mainUser.count == 0{
            let user = UserList()
            user.userId = userInfo!["username"] as! String
            user.pnr.append(pnr)
            
            try! realm.write({ () -> Void in
                realm.add(user)
            })
        }else{
            let mainPNR = mainUser[0].pnr.filter("pnr == %@", pnrStr)
            if mainPNR.count != 0{
                
                for pnrData in mainPNR{
                    
                    if (pnrData.pnr == pnr.pnr) && pnrData.departureStationCode == pnr.departureStationCode{
                        realm.beginWrite()
                        realm.delete(pnrData)
                        try! realm.commitWrite()
                    }
                    
                }
                
            }
            
            try! realm.write({ () -> Void in
                mainUser[0].pnr.append(pnr)
            })
            
        }
        
    }
    
}
