//
//  BeaconQRCodeViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/31/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit

class BeaconQRCodeViewController: BaseViewController, UIScrollViewDelegate {

    @IBOutlet var QRview: UIView!
    @IBOutlet var NotCheckIn: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var border: UIView!
    @IBOutlet weak var pnr: UILabel!
    
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBOutlet weak var seat: UILabel!
    @IBOutlet weak var flightNo: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var passengerName: UILabel!
    
    
    @IBOutlet weak var nBorder: UIView!
    @IBOutlet weak var nPnr: UILabel!
    @IBOutlet weak var nName: UILabel!
    @IBOutlet weak var nDestination: UILabel!
    @IBOutlet weak var nDate: UILabel!
    @IBOutlet weak var nTime: UILabel!
    @IBOutlet weak var nFlightNo: UILabel!
    @IBOutlet weak var nSeat: UILabel!
    
    var data = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bookingList = data["list_booking"] as! NSDictionary
        // Do any additional setup after loading the view.
        
        //1
        self.scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let scrollViewHeight:CGFloat = self.scrollView.frame.width
        
        let numberOfView = bookingList["passengers"]!.count
        var count = 0
        var countNotCheckin = 0
        for i in 0...numberOfView - 1{
            
            let passengerInfo = bookingList["passengers"]![i] as! NSDictionary
            
            if passengerInfo["check_in"]! as! String == "Y"{
                let new = CGFloat(i)
                let xOrigin = new * self.view.frame.size.width
                QRview = NSBundle.mainBundle().loadNibNamed("BeaconView", owner: self, options: nil)[0] as! UIView
                QRview.frame = CGRectMake(xOrigin+5, 0,scrollViewWidth-10, self.scrollView.frame.height)
                QRview.layer.borderWidth = 1
                QRview.layer.cornerRadius = 10
                
                border.layer.cornerRadius = 5
                border.layer.borderWidth = 1
                pnr.text = bookingList["pnr"] as? String//"BBK3NX"
                destination.text = "\(bookingList["departure_station_code"]!) - \(bookingList["arrival_station_code"]!)"
                passengerName.text = "\(passengerInfo["title"]!) \(passengerInfo["first_name"]!) \(passengerInfo["last_name"]!)"
                time.text = bookingList["time"]! as? String
                date.text = bookingList["date"]! as? String
                scrollView.addSubview(QRview)
                count++
            }else{
                let new = CGFloat(i)
                let xOrigin = new * self.view.frame.size.width
                NotCheckIn = NSBundle.mainBundle().loadNibNamed("NotCheckInView", owner: self, options: nil)[0] as! UIView
                NotCheckIn.frame = CGRectMake(xOrigin+5, 0,scrollViewWidth-10, self.scrollView.frame.height)
                NotCheckIn.layer.borderWidth = 1
                NotCheckIn.layer.cornerRadius = 10
                
                nBorder.layer.cornerRadius = 5
                nBorder.layer.borderWidth = 1
                nPnr.text = bookingList["pnr"] as? String//"BBK3NX"
                nDestination.text = "\(bookingList["departure_station_code"]!) - \(bookingList["arrival_station_code"]!)"
                nName.text = "\(passengerInfo["title"]!) \(passengerInfo["first_name"]!) \(passengerInfo["last_name"]!)"
                nTime.text = bookingList["time"]! as? String
                nDate.text = bookingList["date"]! as? String
                scrollView.addSubview(NotCheckIn)
                countNotCheckin++
            }
            
        }
        
        var width = CGFloat()
        
        if count == 0{
            NotCheckIn = NSBundle.mainBundle().loadNibNamed("NotCheckInView", owner: self, options: nil)[0] as! UIView
            NotCheckIn.frame = CGRectMake(5, 0,scrollViewWidth-10, self.scrollView.frame.height)
            NotCheckIn.layer.borderWidth = 1
            NotCheckIn.layer.cornerRadius = 10
            
            nBorder.layer.cornerRadius = 5
            nBorder.layer.borderWidth = 1
            nPnr.text = bookingList["pnr"] as? String//"BBK3NX"
            nDestination.text = "\(bookingList["departure_station_code"]!) - \(bookingList["arrival_station_code"]!)"
            //nName.text = "\(passengerInfo["title"]!) \(passengerInfo["first_name"]!) \(passengerInfo["last_name"]!)"
            nTime.text = bookingList["time"]! as? String
            nDate.text = bookingList["date"]! as? String
            scrollView.addSubview(NotCheckIn)
            pageControl.numberOfPages = 1
            
            width = self.scrollView.frame.width
        }else{
            pageControl.numberOfPages = count + countNotCheckin
            width = self.scrollView.frame.width * CGFloat(numberOfView)
        }
        
        //4
        closeBtn.layer.borderWidth = 1
        closeBtn.layer.cornerRadius = 10
        closeBtn.layer.borderColor = UIColor.orangeColor().CGColor
        self.scrollView.contentSize = CGSizeMake(width, scrollViewHeight)
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0
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
    @IBAction func CloseBtnPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
