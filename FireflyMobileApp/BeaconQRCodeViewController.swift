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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var border: UIView!
    @IBOutlet weak var pnr: UILabel!
    
    @IBOutlet weak var closeBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //1
        self.scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let scrollViewHeight:CGFloat = self.scrollView.frame.width
        
        let numberOfView = 3
        pageControl.numberOfPages = numberOfView+1
        for i in 0...numberOfView{
            let new = CGFloat(i)
            let xOrigin = new * self.view.frame.size.width
            QRview = NSBundle.mainBundle().loadNibNamed("BeaconView", owner: self, options: nil)[0] as! UIView
            QRview.frame = CGRectMake(xOrigin+5, 0,scrollViewWidth-10, self.scrollView.frame.height)
            QRview.layer.borderWidth = 1
            QRview.layer.cornerRadius = 10
            
            border.layer.cornerRadius = 5
            border.layer.borderWidth = 1
            pnr.text = "BBK3NX"
            scrollView.addSubview(QRview)
            
        }
        
        //4
        closeBtn.layer.borderWidth = 1
        closeBtn.layer.cornerRadius = 10
        closeBtn.layer.borderColor = UIColor.orangeColor().CGColor
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width * 4, scrollViewHeight)
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
