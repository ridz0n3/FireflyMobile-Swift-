//
//  BoardingPassDetailViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 2/15/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift
import Realm

class BoardingPassDetailViewController: BaseViewController, UIScrollViewDelegate {
    
    var boardingList = List<BoardingPassList>()
    var isOffline = Bool()
    
    @IBOutlet var boardingPassView: UIView!
    var boardingPassData = [AnyObject]()
    var imgDict = [String:AnyObject]()
    var load = Bool()
    var departCode = String()
    var pnrNumber = String()
    
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var border: UIView!
    @IBOutlet weak var pnr: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var departLbl: UILabel!
    @IBOutlet weak var flightDateLbl: UILabel!
    @IBOutlet weak var boardingTimeLbl: UILabel!
    @IBOutlet weak var flightNoLbl: UILabel!
    @IBOutlet weak var arriveLbl: UILabel!
    @IBOutlet weak var departureTimeLbl: UILabel!
    @IBOutlet weak var fareLbl: UILabel!
    @IBOutlet weak var ssrLbl: UILabel!
    
    var listPnr = PNRList()
    var mainUser : Results<UserList>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeftButton()
        AnalyticsManager.sharedInstance.logScreen(GAConstants.boardingPassDetailScreen)
        
        if boardingPassData.count == 0{
            loadBoardingPass()
        }else{
            notLogin()
        }
        loadingIndicator.isHidden = load
        NotificationCenter.default.addObserver(self, selector: #selector(BoardingPassDetailViewController.refreshBoardingPass(_:)), name: NSNotification.Name(rawValue: "reloadBoardingPass"), object: nil)
    }
    
    func refreshBoardingPass(_ notif : NSNotification){
        
        loadingIndicator.isHidden = true
        loadBoardingPass()
        
    }
    
    func viewBoardingPass(){
        
        //1
        self.scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)//
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let scrollViewHeight:CGFloat = self.scrollView.frame.width
        
        let numberOfView = boardingList.count
        var i = 0
        for info in boardingList{
            let new = CGFloat(i)
            let xOrigin = new * self.view.frame.size.width
            boardingPassView = Bundle.main.loadNibNamed("BoardingPassView", owner: self, options: nil)?[0] as! UIView
            boardingPassView.frame = CGRect(x: xOrigin+5, y: 0, width: scrollViewWidth-10, height: self.scrollView.frame.height - 8)//
            boardingPassView.layer.borderWidth = 1
            
            border.layer.cornerRadius = 5
            border.layer.borderWidth = 1
            
            img.image = UIImage(data: info.QRCodeURL)
            pnr.text = info.recordLocator
            nameLbl.text = info.name
            departLbl.text = info.departureStation
            flightDateLbl.text = info.departureDate
            boardingTimeLbl.text = info.boardingTime
            flightNoLbl.text = info.flightNumber
            arriveLbl.text = info.arrivalStation
            departureTimeLbl.text = info.departureTime
            fareLbl.text = info.fare
            ssrLbl.text = info.SSR
            
            scrollView.addSubview(boardingPassView)
            i += 1
            
        }

        pageControl.numberOfPages = numberOfView
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width * CGFloat(numberOfView), height: scrollViewHeight)
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0
        
    }
    
    func notLogin(){
        
        //1
        self.scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let scrollViewHeight:CGFloat = self.scrollView.frame.width
        
        let numberOfView = boardingPassData.count
        var i = 0
        for tempInfo in boardingPassData{
            
            let info = tempInfo as! Dictionary<String, AnyObject>
            
            let new = CGFloat(i)
            let xOrigin = new * self.view.frame.size.width
            boardingPassView = Bundle.main.loadNibNamed("BoardingPassView", owner: self, options: nil)?[0] as! UIView
            boardingPassView.frame = CGRect(x: xOrigin+5, y: 0, width: scrollViewWidth-10, height: self.scrollView.frame.height - 8)
            boardingPassView.layer.borderWidth = 1
            
            border.layer.cornerRadius = 5
            border.layer.borderWidth = 1
            
            img.image = imgDict["\(i)"] as? UIImage
            pnr.text = info["RecordLocator"] as? String
            nameLbl.text = info["Name"] as? String
            departLbl.text = info["DepartureStation"] as? String
            flightDateLbl.text = info["DepartureDate"] as? String
            boardingTimeLbl.text = info["BoardingTime"] as? String
            flightNoLbl.text = info["FlightNumber"] as? String
            arriveLbl.text = info["ArrivalStation"] as? String
            departureTimeLbl.text = info["DepartureTime"] as? String
            fareLbl.text = info["Fare"] as? String
            ssrLbl.text = info["SSR"] as? String
            
            scrollView.addSubview(boardingPassView)
            i += 1
        }
        
        pageControl.numberOfPages = numberOfView
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width * CGFloat(numberOfView), height: scrollViewHeight)
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0
        
    }
    
    func loadBoardingPass(){
        
        let userInfo = defaults.object(forKey: "userInfo") as! NSDictionary
        //var userData : Results<UserList>! = nil
        let userData = realm.objects(UserList.self)
        mainUser = userData.filter("userId == %@", "\(userInfo["username"]! as! String)")
        
        if mainUser.count != 0{
            
            let mainPNR = mainUser[0].pnr.filter("pnr == %@", pnrNumber)
            
            for boardingInfo in mainPNR{
                
                if boardingInfo.departureStationCode == departCode{
                    boardingList = boardingInfo.boardingPass
                }
                
            }
            
            viewBoardingPass()
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func backButtonPressed(_ sender: UIBarButtonItem){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadBoardingPassList"), object: nil)
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    //MARK: UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage);
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
