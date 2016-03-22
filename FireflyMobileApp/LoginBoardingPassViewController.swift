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
            
            let userInfo = defaults.objectForKey("userInfo")
            var userList = Results<UserList>!()
            userList = realm.objects(UserList)
            
            let mainUser = userList.filter("userId == %@",userInfo!["username"] as! String)
            
            if mainUser.count != 0{
                let mainPNR = mainUser[0].pnr.filter("pnr == %@", bookingList["pnr"] as! String)
                
                if mainPNR.count != 0{
                    
                    var check = 0
                    var boardingPass = List<BoardingPassList>!()
                    for data in mainPNR{
                        
                        if data.departureStationCode == bookingList["departure_station_code"] as! String{
                    
                            boardingPass = data.boardingPass
                            check += 1
                            
                        }
                        
                    }
                    
                    //if check == 0{
                        sentData(bookingList)
                    /*}else{
                        let storyboard = UIStoryboard(name: "BoardingPass", bundle: nil)
                        let boardingPassDetailVC = storyboard.instantiateViewControllerWithIdentifier("BoardingPassDetailVC") as! BoardingPassDetailViewController
                        boardingPassDetailVC.boardingList = boardingPass
                        boardingPassDetailVC.isOffline = true
                        self.navigationController!.pushViewController(boardingPassDetailVC, animated: true)
                    }*/
                    
                }else{
                    sentData(bookingList)
                }
            }else{
                sentData(bookingList)
            }
        }
    }
    
    func sentData(bookingList : NSDictionary){
        
        showLoading() 
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
                        for info in json["boarding_pass"].arrayObject!{
                            let index = "\(j)"
                            let imageURL = info["QRCodeURL"] as! String
                            
                            Alamofire.request(.GET, imageURL).response(completionHandler: { (request, response, data, error) -> Void in
                                
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
                    
                }
                
            case .Failure(let failureResult):
                
                hideLoading()
                showErrorMessage(failureResult.nsError.localizedDescription)
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
                    
                    if pnrData.departureDateTime.compare(pnr.departureDateTime) == NSComparisonResult.OrderedSame{
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
