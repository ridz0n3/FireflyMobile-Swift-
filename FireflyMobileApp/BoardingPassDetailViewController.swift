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

class BoardingPassDetailViewController: BaseViewController, UIScrollViewDelegate {

    @IBOutlet var boardingPassView: UIView!
    var boardingPassData = [JSON]()
    var imgDict = [String:AnyObject]()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeftButton()
        //1
        self.scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let scrollViewHeight:CGFloat = self.scrollView.frame.width
        
        let numberOfView = boardingPassData.count
        var i = 0
        for info in boardingPassData{
            
            let new = CGFloat(i)
            let xOrigin = new * self.view.frame.size.width
            boardingPassView = NSBundle.mainBundle().loadNibNamed("BoardingPassView", owner: self, options: nil)[0] as! UIView
            boardingPassView.frame = CGRectMake(xOrigin+5, 0,scrollViewWidth-10, self.scrollView.frame.height - 8)
            boardingPassView.layer.borderWidth = 1
            
            border.layer.cornerRadius = 5
            border.layer.borderWidth = 1
            
            /*let imageURL = info["QRCodeURL"] as? String
            Alamofire.request(.GET, imageURL!).response(completionHandler: { (request, response, data, error) -> Void in
                self.img.image = UIImage(data: data!)
                
            })*/
            
            img.image = imgDict["\(i)"] as? UIImage
            pnr.text = info["RecordLocator"].string
            nameLbl.text = info["Name"].string
            departLbl.text = info["DepartureStation"].string
            flightDateLbl.text = info["DepartureDate"].string
            boardingTimeLbl.text = info["BoardingTime"].string
            flightNoLbl.text = info["FlightNumber"].string
            arriveLbl.text = info["ArrivalStation"].string
            departureTimeLbl.text = info["DepartureTime"].string
            fareLbl.text = info["Fare"].string
            ssrLbl.text = info["SSR"].string
            
            scrollView.addSubview(boardingPassView)
            i++
        }
        
        pageControl.numberOfPages = numberOfView
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width * CGFloat(numberOfView), scrollViewHeight)
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0
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
