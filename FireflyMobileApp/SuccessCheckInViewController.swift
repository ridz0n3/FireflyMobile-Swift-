//
//  SuccessCheckInViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 2/15/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SCLAlertView
import RealmSwift

class SuccessCheckInViewController: BaseViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var border: UIView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var boardingPassBtn: UIButton!
    
    var msg = String()
    var boardingList = [AnyObject]()
    
    var signature = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuButton()
        AnalyticsManager.sharedInstance.logScreen(GAConstants.successCheckInViewScreen)
        boardingPassBtn.layer.borderWidth = 1
        boardingPassBtn.layer.cornerRadius = 10
        boardingPassBtn.layer.borderColor = UIColor.orangeColor().CGColor
        border.layer.borderWidth = 1
        closeButton.layer.cornerRadius = 10
        messageTextView.attributedText = msg.html2String
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeBtnPressed(sender: AnyObject) {
        
        for views in (self.navigationController?.viewControllers)!{
            if views.classForCoder == HomeViewController.classForCoder(){
                self.navigationController?.popToViewController(views, animated: true)
                AnalyticsManager.sharedInstance.logScreen(GAConstants.homeScreen)
            }
        }
        
    }
    
    
    @IBAction func boardingPassBtnPressed(sender: AnyObject) {
        
        if try! LoginManager.sharedInstance.isLogin(){
            
            let userInfo = defaults.objectForKey("userInfo")
            var userList = Results<UserList>!()
            userList = realm.objects(UserList)
            
            let mainUser = userList.filter("userId == %@",userInfo!["username"] as! String)
            
            if mainUser.count != 0{
                let mainPNR = mainUser[0].pnr.filter("pnr == %@", boardingList[0]["RecordLocator"] as! String)
                
                if mainPNR.count != 0{
                    var boardingPass = List<BoardingPassList>!()
                    for data in mainPNR{
                        
                        if data.departureStationCode == boardingList[0]["DepartureStationCode"] as! String{
                            
                            boardingPass = data.boardingPass
                            
                        }
                        
                    }
                    
                    let storyboard = UIStoryboard(name: "BoardingPass", bundle: nil)
                    let boardingPassDetailVC = storyboard.instantiateViewControllerWithIdentifier("BoardingPassDetailVC") as! BoardingPassDetailViewController
                    boardingPassDetailVC.boardingList = boardingPass
                    boardingPassDetailVC.isOffline = true
                    self.navigationController!.pushViewController(boardingPassDetailVC, animated: true)
                    
                }
            }
            
        }else{
            
            var i = 0
            var j = 0
            var dict = [String:AnyObject]()
            for info in boardingList{
                let index = "\(j)"
                let imageURL = info["QRCodeURL"] as? String
                Alamofire.request(.GET, imageURL!).response(completionHandler: { (request, response, data, error) -> Void in
                    
                    dict.updateValue(UIImage(data: data!)!, forKey: "\(index)")
                    i++
                    
                    if i == j{
                        
                        let storyboard = UIStoryboard(name: "BoardingPass", bundle: nil)
                        let boardingPassDetailVC = storyboard.instantiateViewControllerWithIdentifier("BoardingPassDetailVC") as! BoardingPassDetailViewController
                        boardingPassDetailVC.boardingPassData = self.boardingList
                        boardingPassDetailVC.imgDict = dict
                        self.navigationController!.pushViewController(boardingPassDetailVC, animated: true)
                        hideLoading()
                    }
                })
                j++
            }
            
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
