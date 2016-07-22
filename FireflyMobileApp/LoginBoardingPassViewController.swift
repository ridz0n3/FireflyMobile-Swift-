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
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var listPnr = PNRList()
    var newFormatedBookingList = [String : AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AnalyticsManager.sharedInstance.logScreen(GAConstants.loginBoardingPassScreen)
        loadingIndicator.hidden = indicator
        loadBoardingPassList()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginBoardingPassViewController.refreshBoardingPassList(_:)), name: "reloadBoardingPassList", object: nil)
    }
    
    func loadBoardingPassList(){
        
        let userInfo = defaults.objectForKey("userInfo") as! NSDictionary
        var userData : Results<UserList>! = nil
        userData = realm.objects(UserList)
        mainUser = userData.filter("userId == %@", userInfo["username"]! as! String)
        
        if mainUser.count != 0{
            pnrList = mainUser[0].pnr.sorted("departureDateTime", ascending: true)
            var activeFlight = [AnyObject]()
            var notActiveFlight = [AnyObject]()
            for data in pnrList{
                let formater = NSDateFormatter()
                formater.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
                
                let twentyFour = NSLocale(localeIdentifier: "en_GB")
                formater.locale = twentyFour
                //let newDate = formater.dateFromString(data.departureDateTime as! String)
                let today = NSDate()
                if today.compare(data.departureDateTime) == NSComparisonResult.OrderedAscending{
                    activeFlight.append(data)
                }else{
                    notActiveFlight.append(data)
                }
            }
            
            newFormatedBookingList.updateValue(activeFlight, forKey: "Active")
            newFormatedBookingList.updateValue(notActiveFlight, forKey: "notActive")
            print(newFormatedBookingList.count)
        }
        
    }
    
    func refreshBoardingPassList(notif : NSNotification){
        
        signature = mainUser[0].signature
        loadingIndicator.hidden = true
        loadBoardingPassList()
        LoginMobileCheckinTableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return newFormatedBookingList.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            
            if newFormatedBookingList["Active"]?.count == 0{
                return 1
            }else{
                return (newFormatedBookingList["Active"]?.count)!
            }
            
        }else{
            
            if newFormatedBookingList["notActive"]?.count == 0{
                return 1
            }else{
                return (newFormatedBookingList["notActive"]?.count)!
            }
            
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            if newFormatedBookingList["Active"]?.count == 0{
                let cell = LoginMobileCheckinTableView.dequeueReusableCellWithIdentifier("NoUpcomingCell", forIndexPath: indexPath) as! CustomLoginManageFlightTableViewCell
                
                return cell
            }else{
                
                let cell = LoginMobileCheckinTableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomLoginManageFlightTableViewCell
                
                let bookingList = newFormatedBookingList["Active"] as! [AnyObject]
                let bookingData = bookingList[indexPath.row] as! PNRList
                
                cell.pnrNumber.text = "\(bookingData.pnr)"
                cell.flightNumber.text = "\(bookingData.departureStationCode) - \(bookingData.arrivalStationCode)"
                cell.flightDate.text = bookingData.departureDayDate.capitalizedString
                
                return cell
            }
            
        }else{
            
            if newFormatedBookingList["notActive"]?.count == 0{
                let cell = LoginMobileCheckinTableView.dequeueReusableCellWithIdentifier("NoCompletedCell", forIndexPath: indexPath) as! CustomLoginManageFlightTableViewCell
                return cell
            }else{
                let cell = LoginMobileCheckinTableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomLoginManageFlightTableViewCell
                
                let bookingList = newFormatedBookingList["notActive"] as! [AnyObject]
                let bookingData = bookingList[indexPath.row] as! PNRList
                
                cell.pnrNumber.text = "\(bookingData.pnr)"
                cell.flightNumber.text = "\(bookingData.departureStationCode) - \(bookingData.arrivalStationCode)"
                cell.flightDate.text = bookingData.departureDayDate.capitalizedString
                
                return cell
            }
            
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var bookingList = [AnyObject]()
        var bookingData = PNRList()
        
        if indexPath.section == 0{
            bookingList = newFormatedBookingList["Active"] as! [AnyObject]
            bookingData = bookingList[indexPath.row] as! PNRList
        }else{
            bookingList = newFormatedBookingList["notActive"] as! [AnyObject]
            bookingData = bookingList[indexPath.row] as! PNRList
        }
        
        //listPnr = pnrList[indexPath.row]
        let boardingPass = bookingData.boardingPass
        
        if boardingPass.count != 0{
            
            let storyboard = UIStoryboard(name: "BoardingPass", bundle: nil)
            let boardingPassDetailVC = storyboard.instantiateViewControllerWithIdentifier("BoardingPassDetailVC") as! BoardingPassDetailViewController
            boardingPassDetailVC.departCode = bookingData.departureStationCode//listPnr["departureStationCode"] as! String
            boardingPassDetailVC.pnrNumber = bookingData.pnr//listPnr["pnr"] as! String
            self.navigationController!.pushViewController(boardingPassDetailVC, animated: true)
            checkBoardingPass(bookingData.pnr, departCode: bookingData.departureStationCode, arrivalCode: bookingData.arrivalStationCode, isExist : true)
        }else{
            showLoading()
            checkBoardingPass(bookingData.pnr, departCode: bookingData.departureStationCode, arrivalCode: bookingData.arrivalStationCode, isExist : false)
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = NSBundle.mainBundle().loadNibNamed("PassengerHeader", owner: self, options: nil)[0] as! PassengerHeaderView
        
        sectionView.views.backgroundColor = UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        
        //let index = UInt(section)
        var title = String()
        
        if section == 0{
            title = "Upcoming Trips"
        }else{
            title = "Completed Travels"
        }
        
        sectionView.sectionLbl.text = title
        sectionView.sectionLbl.textColor = UIColor.whiteColor()
        sectionView.sectionLbl.textAlignment = NSTextAlignment.Center
        
        return sectionView
        
    }
    
    func checkBoardingPass(pnr : String, departCode : String, arrivalCode : String, isExist : Bool){
        
        FireFlyProvider.request(.RetrieveBoardingPass(signature, pnr, departCode, arrivalCode, userId), completion: { (result) -> () in
            switch result {
            case .Success(let successResult):
                do {
                    let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                    
                    if  json["status"].string == "success"{
                        
                        self.saveBoardingPass(json["boarding_pass"].arrayObject!, pnrStr: pnr)
                        
                        if !isExist{
                            let storyboard = UIStoryboard(name: "BoardingPass", bundle: nil)
                            let boardingPassDetailVC = storyboard.instantiateViewControllerWithIdentifier("BoardingPassDetailVC") as! BoardingPassDetailViewController
                            boardingPassDetailVC.departCode = departCode
                            boardingPassDetailVC.pnrNumber = pnr
                            boardingPassDetailVC.load = true
                            self.navigationController!.pushViewController(boardingPassDetailVC, animated: true)
                            hideLoading()
                        }else{
                            NSNotificationCenter.defaultCenter().postNotificationName("reloadBoardingPass", object: nil)
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
                }else{
                    NSNotificationCenter.defaultCenter().postNotificationName("reloadBoardingPass", object: nil)
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
                let twentyFour = NSLocale(localeIdentifier: "en_GB")
                formater.locale = twentyFour
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
