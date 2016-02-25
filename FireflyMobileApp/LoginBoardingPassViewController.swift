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

class LoginBoardingPassViewController: CommonListViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if isOffline{
            
            let bookingList = pnrList[indexPath.row]
            let boardingPass = bookingList.boardingPass
            
            let storyboard = UIStoryboard(name: "BoardingPass", bundle: nil)
            let boardingPassDetailVC = storyboard.instantiateViewControllerWithIdentifier("BoardingPassDetailVC") as! BoardingPassDetailViewController
            boardingPassDetailVC.boardingList = boardingPass
            boardingPassDetailVC.isOffline = true
            self.navigationController!.pushViewController(boardingPassDetailVC, animated: true)
            
        }else{
            let bookingList = listBooking[indexPath.row] as! NSDictionary
            
            showHud("open")
            FireFlyProvider.request(.RetrieveBoardingPass(signature, bookingList["pnr"] as! String, bookingList["departure_station_code"] as! String, bookingList["arrival_station_code"] as! String, userId), completion: { (result) -> () in
                switch result {
                case .Success(let successResult):
                    do {
                        let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                        
                        if  json["status"].string == "success"{
                            
                            self.saveBoardingPass(json["boarding_pass"].arrayObject!, pnrStr: bookingList["pnr"] as! String)
                            
                            var i = 0
                            var j = 0
                            var dict = [String:AnyObject]()
                            for info in json["boarding_pass"].arrayValue{
                                let index = "\(j)"
                                let imageURL = info["QRCodeURL"].stringValue
                                
                                Alamofire.request(.GET, imageURL).response(completionHandler: { (request, response, data, error) -> Void in
                                    
                                    dict.updateValue(UIImage(data: data!)!, forKey: "\(index)")
                                    i++
                                    
                                    if i == j{
                                        showHud("close")
                                        let storyboard = UIStoryboard(name: "BoardingPass", bundle: nil)
                                        let boardingPassDetailVC = storyboard.instantiateViewControllerWithIdentifier("BoardingPassDetailVC") as! BoardingPassDetailViewController
                                        boardingPassDetailVC.boardingPassData = json["boarding_pass"].arrayValue
                                        boardingPassDetailVC.imgDict = dict
                                        self.navigationController!.pushViewController(boardingPassDetailVC, animated: true)
                                    }
                                })
                                j++
                            }
                        }else{
                            showHud("close")
                            //showErrorMessage(json["message"].string!)
                            showErrorMessage(json["message"].string!)
                        }
                    }
                    catch {
                        
                    }
                    
                case .Failure(let failureResult):
                    showHud("close")
                    showErrorMessage(failureResult.nsError.localizedDescription)
                }
                
            })
        }
        
        
        
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
            count++
            
            if boardingPassArr.count == count{
                
                let formater = NSDateFormatter()
                formater.dateFormat = "dd MM yyyy"
                
                pnr.departureStationCode = boardingInfo["DepartureStationCode"] as! String
                pnr.arrivalStationCode = boardingInfo["ArrivalStationCode"] as! String
                pnr.departureDateTime = formater.dateFromString(boardingInfo["DepartureDayDate"] as! String)!
                pnr.departureDayDate = boardingInfo["DepartureDayDate"] as! String
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
                    if pnrData.departureDayDate == pnr.departureDayDate{
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
