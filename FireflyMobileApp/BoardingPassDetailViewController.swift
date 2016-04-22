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
        loadBoardingPass()
        loadingIndicator.hidden = load
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BoardingPassDetailViewController.refreshBoardingPass(_:)), name: "reloadBoardingPass", object: nil)
    }
    
    func refreshBoardingPass(notif : NSNotification){
        
        loadingIndicator.hidden = true
        loadBoardingPass()
        
    }
    
    func viewBoardingPass(){
        
        //1
        self.scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let scrollViewHeight:CGFloat = self.scrollView.frame.width
        
        let numberOfView = boardingList.count
        var i = 0
        for info in boardingList{
            let new = CGFloat(i)
            let xOrigin = new * self.view.frame.size.width
            boardingPassView = NSBundle.mainBundle().loadNibNamed("BoardingPassView", owner: self, options: nil)[0] as! UIView
            boardingPassView.frame = CGRectMake(xOrigin+5, 0,scrollViewWidth-10, self.scrollView.frame.height - 8)
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
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width * CGFloat(numberOfView), scrollViewHeight)
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0
        
    }
    
    func loadBoardingPass(){
        
        let userInfo = defaults.objectForKey("userInfo") as! [String : String]
        var userData : Results<UserList>! = nil
        userData = realm.objects(UserList)
        mainUser = userData.filter("userId == %@", userInfo["username"]!)
        
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
    
    //MARK: UIScrollViewDelegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = CGRectGetWidth(scrollView.frame)
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
