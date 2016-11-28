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
        loadingIndicator.isHidden = indicator
        loadBoardingPassList()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginBoardingPassViewController.refreshBoardingPassList(_:)), name: NSNotification.Name(rawValue: "reloadBoardingPassList"), object: nil)
    }
    
    func loadBoardingPassList(){
        
        let userInfo = defaults.object(forKey: "userInfo") as! NSDictionary
        //var userData : Results<UserList>! = nil
        let userData = realm.objects(UserList.self)
        mainUser = userData.filter("userId == %@", userInfo["username"]! as! String)
        
        if mainUser.count != 0{
            pnrList = mainUser[0].pnr.sorted(byProperty: "departureDateTime", ascending: true)
            var activeFlight = [AnyObject]()
            var notActiveFlight = [AnyObject]()
            for data in pnrList{
                let formater = DateFormatter()
                formater.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
                
                let twentyFour = Locale(identifier: "en_GB")
                formater.locale = twentyFour
                //let newDate = formater.dateFromString(data.departureDateTime as! String)
                let today = Date()
                if today.compare(data.departureDateTime) == ComparisonResult.orderedAscending{
                    activeFlight.append(data)
                }else{
                    notActiveFlight.append(data)
                }
            }
            
            newFormatedBookingList.updateValue(activeFlight as AnyObject, forKey: "Active")
            newFormatedBookingList.updateValue(notActiveFlight as AnyObject, forKey: "notActive")
            print(newFormatedBookingList.count)
        }
        
    }
    
    func refreshBoardingPassList(_ notif : NSNotification){
        
        signature = mainUser[0].signature
        loadingIndicator.isHidden = true
        loadBoardingPassList()
        LoginMobileCheckinTableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return newFormatedBookingList.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            
            if newFormatedBookingList["Active"]?.count == 0{
                let cell = LoginMobileCheckinTableView.dequeueReusableCell(withIdentifier: "NoUpcomingCell", for: indexPath) as! CustomLoginManageFlightTableViewCell
                
                return cell
            }else{
                
                let cell = LoginMobileCheckinTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomLoginManageFlightTableViewCell
                
                let bookingList = newFormatedBookingList["Active"] as! [AnyObject]
                let bookingData = bookingList[indexPath.row] as! PNRList
                
                cell.pnrNumber.text = "\(bookingData.pnr)"
                cell.flightNumber.text = "\(bookingData.departureStationCode) - \(bookingData.arrivalStationCode)"
                cell.flightDate.text = bookingData.departureDayDate.capitalized
                
                return cell
            }
            
        }else{
            
            if newFormatedBookingList["notActive"]?.count == 0{
                let cell = LoginMobileCheckinTableView.dequeueReusableCell(withIdentifier: "NoCompletedCell", for: indexPath) as! CustomLoginManageFlightTableViewCell
                return cell
            }else{
                let cell = LoginMobileCheckinTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomLoginManageFlightTableViewCell
                
                let bookingList = newFormatedBookingList["notActive"] as! [AnyObject]
                let bookingData = bookingList[indexPath.row] as! PNRList
                
                cell.pnrNumber.text = "\(bookingData.pnr)"
                cell.flightNumber.text = "\(bookingData.departureStationCode) - \(bookingData.arrivalStationCode)"
                cell.flightDate.text = bookingData.departureDayDate.capitalized
                
                return cell
            }
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
            let boardingPassDetailVC = storyboard.instantiateViewController(withIdentifier: "BoardingPassDetailVC") as! BoardingPassDetailViewController
            boardingPassDetailVC.departCode = bookingData.departureStationCode//listPnr["departureStationCode"] as! String
            boardingPassDetailVC.pnrNumber = bookingData.pnr//listPnr["pnr"] as! String
            self.navigationController!.pushViewController(boardingPassDetailVC, animated: true)
            checkBoardingPass(bookingData.pnr, departCode: bookingData.departureStationCode, arrivalCode: bookingData.arrivalStationCode, isExist : true)
        }else{
            showLoading()
            checkBoardingPass(bookingData.pnr, departCode: bookingData.departureStationCode, arrivalCode: bookingData.arrivalStationCode, isExist : false)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = Bundle.main.loadNibNamed("PassengerHeader", owner: self, options: nil)?[0] as! PassengerHeaderView
        
        sectionView.views.backgroundColor = UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        
        //let index = UInt(section)
        var title = String()
        
        if section == 0{
            title = "Upcoming Trips"
        }else{
            title = "Completed Travels"
        }
        
        sectionView.sectionLbl.text = title
        sectionView.sectionLbl.textColor = UIColor.white
        sectionView.sectionLbl.textAlignment = NSTextAlignment.center
        
        return sectionView
        
    }
    
    func checkBoardingPass(_ pnr : String, departCode : String, arrivalCode : String, isExist : Bool){
        
        FireFlyProvider.request(.RetrieveBoardingPass(signature, pnr, departCode, arrivalCode, userId), completion: { (result) -> () in
            switch result {
            case .success(let successResult):
                do {
                    let json = try JSON(JSONSerialization.jsonObject(with: successResult.data, options: .mutableContainers))
                    
                    if  json["status"].string == "success"{
                        
                        self.saveBoardingPass(json["boarding_pass"].arrayObject! as [AnyObject], pnrStr: pnr)
                        
                        if !isExist{
                            let storyboard = UIStoryboard(name: "BoardingPass", bundle: nil)
                            let boardingPassDetailVC = storyboard.instantiateViewController(withIdentifier: "BoardingPassDetailVC") as! BoardingPassDetailViewController
                            boardingPassDetailVC.departCode = departCode
                            boardingPassDetailVC.pnrNumber = pnr
                            boardingPassDetailVC.load = true
                            self.navigationController!.pushViewController(boardingPassDetailVC, animated: true)
                            hideLoading()
                        }else{
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadBoardingPass"), object: nil)
                        }
                    }else{
                        
                        hideLoading()
                        showErrorMessage(json["message"].string!)
                        
                    }
                }
                catch {
                    
                }
                
            case .failure( _):
                
                if !isExist{
                    showErrorMessage("Boarding Pass has not been saved")
                }else{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadBoardingPass"), object: nil)
                }
                hideLoading()
            }
            
        })
        
    }
    
    func saveBoardingPass(_ boardingPassArr : [AnyObject], pnrStr : String){
        
        let userInfo = defaults.object(forKey: "userInfo") as! NSDictionary
        //var userList = Results<UserList>!()
        let userList = realm.objects(UserList.self)
        
        let mainUser = userList.filter("userId == %@", "\(userInfo["username"] as! String)")
        
        let pnr = PNRList()
        pnr.pnr = pnrStr
        
        var count = 0
        for tempBoardingInfo in boardingPassArr{
            
            let boardingInfo = tempBoardingInfo as! Dictionary<String,AnyObject>
            
            let boardingPass = BoardingPassList()
            count += 1
            
            if boardingPassArr.count == count{
                
                let formater = DateFormatter()
                formater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                let twentyFour = Locale(identifier: "en_GB")
                formater.locale = twentyFour
                pnr.departureStationCode = nilIfEmpty(boardingInfo["DepartureStationCode"]) 
                pnr.arrivalStationCode = boardingInfo["ArrivalStationCode"] as! String
                pnr.departureDateTime = formater.date(from: boardingInfo["DepartureDateTime"] as! String)!
                pnr.departureDayDate = boardingInfo["DepartureDate"] as! String
            }
            
            let url = URL(string: boardingInfo["QRCodeURL"] as! String)
            let data = try! Data(contentsOf: url!) //(contentsOfURL: url!)
            
            boardingPass.name = boardingInfo["Name"] as! String
            boardingPass.departureStation = boardingInfo["DepartureStation"] as! String
            boardingPass.arrivalStation = boardingInfo["ArrivalStation"] as! String
            boardingPass.departureDate = boardingInfo["DepartureDate"] as! String
            boardingPass.departureTime = boardingInfo["DepartureTime"] as! String
            boardingPass.boardingTime = boardingInfo["BoardingTime"] as! String
            boardingPass.fare = boardingInfo["Fare"] as! String
            boardingPass.flightNumber = boardingInfo["FlightNumber"] as! String
            boardingPass.SSR = boardingInfo["SSR"] as! String
            boardingPass.QRCodeURL = data
            boardingPass.recordLocator = boardingInfo["RecordLocator"] as! String
            boardingPass.arrivalStationCode = boardingInfo["ArrivalStationCode"] as! String
            boardingPass.departureStationCode = boardingInfo["DepartureStationCode"] as! String
            
            pnr.boardingPass.append(boardingPass)
        }
        
        
        if mainUser.count == 0{
            let user = UserList()
            user.userId = userInfo["username"] as! String
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
