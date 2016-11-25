//
//  MobileCheckInTermViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 2/5/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import M13Checkbox
import SwiftyJSON
import Alamofire
import RealmSwift

class MobileCheckInTermViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var termTableView: UITableView!
    
    @IBOutlet weak var rule1Btn: UIButton!
    @IBOutlet weak var rule1Img: UIImageView!
    @IBOutlet var rule1View: UIView!
    
    @IBOutlet var rule2View: UIView!
    @IBOutlet weak var rule2Btn: UIButton!
    @IBOutlet weak var rule2Title1: UILabel!
    @IBOutlet weak var rule2Title2: UILabel!
    @IBOutlet weak var rule2Title3: UILabel!
    @IBOutlet weak var rule2Info1: UITextView!
    @IBOutlet weak var rule2Info2: UITextView!
    @IBOutlet weak var rule2Info3: UITextView!
    @IBOutlet weak var termContentView: UIView!
    @IBOutlet weak var termScview: UIScrollView!
    
    var termDetail = Dictionary<String,AnyObject>()
    var termRules = Dictionary<String,AnyObject>()
    var checkStatus = [String]()
    var pnr = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        AnalyticsManager.sharedInstance.logScreen(GAConstants.mobileCheckInTermScreen)
        setupLeftButton()
        continueBtn.layer.cornerRadius = 10
        termRules = (termDetail["rules"] as! [AnyObject])[0] as! Dictionary<String, AnyObject>
        
        termTableView.estimatedRowHeight = 38.0
        termTableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return termRules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MobileTermTableViewCell
        
        let i = indexPath.row + 1
        let rules = termRules["rule_\(i)"] as! NSDictionary
        
        cell.termText.text = rules["text"] as? String
        cell.termCheck.tag = indexPath.row
        cell.termCheck.isUserInteractionEnabled = false
        cell.termCheck.strokeColor = UIColor.orange
        cell.termCheck.checkColor = UIColor.orange
        if checkStatus.count != termRules.count{
            checkStatus.append("false")
        }else{
            
            if checkStatus[indexPath.row] == "true"{
                cell.termCheck.checkState = M13CheckboxState.checked
            }else{
                cell.termCheck.checkState = M13CheckboxState.unchecked
            }
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            
            let i = indexPath.row + 1
            let rules = termRules["rule_\(i)"] as! NSDictionary
            
            Alamofire.request(rules["image"] as! String).response(completionHandler: { response in
                self.rule1Img.image = UIImage(data: response.data!)
            })
            
            rule1View = Bundle.main.loadNibNamed("Rule1View", owner: self, options: nil)?[0] as! UIView
            
            rule1View.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)//(0, 0, self.view.frame.size.width, self.view.frame.size.height)
            rule1View.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.25)
            rule1Btn.layer.cornerRadius = 10
            rule1Btn.layer.borderWidth = 1
            rule1Btn.layer.borderColor = UIColor.orange.cgColor
            
            if checkStatus[indexPath.row] == "true"{
                checkStatus.remove(at: indexPath.row)
                checkStatus.insert("false", at: indexPath.row)
                rule1Btn.setTitle("Disagree", for: UIControlState.normal)
            }else{
                checkStatus.remove(at: indexPath.row)
                checkStatus.insert("true", at: indexPath.row)
                rule1Btn.setTitle("Agree", for: UIControlState.normal)
            }
            
            let applicationLoadViewIn = CATransition()
            applicationLoadViewIn.type = kCATransitionFade
            applicationLoadViewIn.duration = 2.0
            applicationLoadViewIn.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            rule1View.layer.add(applicationLoadViewIn, forKey: kCATransitionReveal)
            self.view.addSubview(rule1View)
            
            
        }else if indexPath.row == 1{
            let i = indexPath.row + 1
            let rules = termRules["rule_\(i)"] as! NSDictionary
            
            rule2View = Bundle.main.loadNibNamed("Rule2View", owner: self, options: nil)?[0] as! UIView
            
            rule2View.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            rule2View.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.25)
            rule2Btn.layer.cornerRadius = 10
            rule2Btn.layer.borderWidth = 1
            rule2Btn.layer.borderColor = UIColor.orange.cgColor
            
            rule2Title1.text = rules["title_1"] as? String
            rule2Title2.text = rules["title_2"] as? String
            rule2Title3.text = rules["title_3"] as? String
            
            rule2Info1.attributedText = (rules["html_1"] as! String).html2String
            rule2Info2.attributedText = (rules["html_2"] as! String).html2String
            rule2Info3.attributedText = (rules["html_3"] as! String).html2String
            
            if checkStatus[indexPath.row] == "true"{
                checkStatus.remove(at: indexPath.row)
                checkStatus.insert("false", at: indexPath.row)
                rule2Btn.setTitle("Disagree", for: UIControlState.normal)
            }else{
                checkStatus.remove(at: indexPath.row)
                checkStatus.insert("true", at: indexPath.row)
                rule2Btn.setTitle("Agree", for: UIControlState.normal)
            }
            
            let applicationLoadViewIn = CATransition()
            applicationLoadViewIn.type = kCATransitionFade
            applicationLoadViewIn.duration = 2.0
            applicationLoadViewIn.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            rule2View.layer.add(applicationLoadViewIn, forKey: kCATransitionReveal)
            self.view.addSubview(rule2View)
            
            
        }else{
            
            if checkStatus[indexPath.row] == "true"{
                checkStatus.remove(at: indexPath.row)
                checkStatus.insert("false", at: indexPath.row)
            }else{
                checkStatus.remove(at: indexPath.row)
                checkStatus.insert("true", at: indexPath.row)
            }
            
        }
        termTableView.reloadData()
    }
    
    @IBAction func continueBtnPressed(sender: AnyObject) {
        
        var statusCount = 0
        for status in checkStatus{
            
            if status == "false"{
                statusCount += 1
            }
        }
        
        if statusCount != 0{
            showErrorMessage("You must read and understand the important dangerous goods information and terms and condition.")
        }else{
            let departure_station_code = termDetail["departure_station_code"] as! String
            let arrival_station_code = termDetail["arrival_station_code"] as! String
            let signature = termDetail["signature"] as! String
            let passengers = termDetail["passengers"]
            
            showLoading() 
            FireFlyProvider.request(.CheckInConfirmation(pnr, departure_station_code, arrival_station_code, signature, passengers!), completion: { (result) -> () in
                
                switch result {
                case .success(let successResult):
                    do {
                        let json = try JSON(JSONSerialization.jsonObject(with: successResult.data, options: .mutableContainers))
                        
                        if  json["status"].string == "success"{
                            
                            if try! LoginManager.sharedInstance.isLogin(){
                                
                                self.saveBoardingPass(json["boarding_pass"].arrayObject! as [AnyObject], pnrStr: self.pnr)
                                
                            }
                            
                            let storyboard = UIStoryboard(name: "MobileCheckIn", bundle: nil)
                            let successVC = storyboard.instantiateViewController(withIdentifier: "SuccessCheckInVC") as! SuccessCheckInViewController
                            successVC.msg = json["html"].string!
                            successVC.boardingList = json["boarding_pass"].arrayObject! as [AnyObject]
                            successVC.signature = signature
                            self.navigationController!.pushViewController(successVC, animated: true)
                            
                        }else if json["status"].string == "401"{
                            hideLoading()
                            showErrorMessage(json["message"].string!)
                            InitialLoadManager.sharedInstance.load()
                            
                            for views in (self.navigationController?.viewControllers)!{
                                if views.classForCoder == HomeViewController.classForCoder(){
                                    _ = self.navigationController?.popToViewController(views, animated: true)
                                    AnalyticsManager.sharedInstance.logScreen(GAConstants.homeScreen)
                                }
                            }
                        }else{
                            
                            showErrorMessage(json["message"].string!)
                        }
                        hideLoading()
                    }
                    catch {
                        
                    }
                    
                case .failure(let failureResult):
                    hideLoading()
                    showErrorMessage(failureResult.localizedDescription)
                }
            })
            
        }
        
    }
    
    func saveBoardingPass(_ boardingPassArr : [AnyObject], pnrStr : String){
        
        let userInfo = defaults.object(forKey: "userInfo") as! NSDictionary
        var userList : Results<UserList>! = nil
        userList = realm.objects(UserList.self)
        
        let mainUser = userList.filter("userId == \(userInfo["username"] as! String)")
        
        let pnr = PNRList()
        pnr.pnr = pnrStr
        
        var count = 0
        for boardingInfo in boardingPassArr{
            let boardingPass = BoardingPassList()
            count += 1
            
            if boardingPassArr.count == count{
                
                let formater = DateFormatter()
                formater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                let twentyFour = Locale(identifier: "en_GB")
                formater.locale = twentyFour
                
                pnr.departureStationCode = nilIfEmpty(boardingInfo["DepartureStationCode"] as AnyObject)
                pnr.arrivalStationCode = boardingInfo["ArrivalStationCode"] as! String
                pnr.departureDateTime = formater.date(from: boardingInfo["DepartureDateTime"] as! String)!
                pnr.departureDayDate = boardingInfo["DepartureDate"] as! String
            }
            
            let url = URL(string: boardingInfo["QRCodeURL"] as! String)!
            let data = try! Data(contentsOf: url)
            
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
                    
                    if (pnrData.pnr == pnr.pnr) && (pnrData.departureStationCode == pnr.departureStationCode){
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
    
    @IBAction func rule1BtnPressed(sender: AnyObject) {
        rule1View.removeFromSuperview()
        
    }
    
    @IBAction func rule2BtnPressed(sender: AnyObject) {
        rule2View.removeFromSuperview()
        
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
