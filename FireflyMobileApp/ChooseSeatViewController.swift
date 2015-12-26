//
//  ChooseSeatViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/17/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit

extension ChooseSeatViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSize(width: 60, height: collectionView.frame.height)
    }
    
}

class ChooseSeatViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var seatTableView: UITableView!
    @IBOutlet weak var continueBtn: UIButton!
    var seatSelect = [AnyObject]()
    var seat = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeftButton()
        let defaults = NSUserDefaults.standardUserDefaults()
        let journeys = defaults.objectForKey("journey") as! NSArray
        var newSeat = NSMutableArray()
        var seatDict = NSMutableArray()
        var seatData = NSMutableArray()
        for info in journeys{
            
            seatData = info["seat_info"] as! NSMutableArray
            newSeat = seatData.mutableCopy() as! NSMutableArray
            var indDa = 0
            while newSeat.count != 0{
                if indDa == 3{
                    indDa = 0
                    seatDict.addObject(newSeat[0])
                    seat.addObject(seatDict)
                    newSeat.removeObjectAtIndex(0)
                    seatDict = NSMutableArray()
                    
                }else{
                    seatDict.addObject(newSeat[0])
                    newSeat.removeObjectAtIndex(0)
                    indDa++
                }
            }
            
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seat.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.seatTableView.dequeueReusableCellWithIdentifier("seatRowCell", forIndexPath: indexPath) as! CustomChooseSeatTableViewCell
        cell.seatCollectionView.tag = indexPath.row
        cell.seatCollectionView.reloadData()
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("seatCell", forIndexPath: indexPath)
        let view = cell.viewWithTag(200)
        let titleLabel = cell.viewWithTag(100) as! UILabel
        
        let seatDetail = seat[collectionView.tag][indexPath.row] as! NSDictionary
        titleLabel.text = seatDetail["seat_number"] as? String
        
        if seatDetail["status"] as! String == "available"{
            cell.backgroundColor = UIColor.lightGrayColor()
        }
        
        if seatSelect.count != 0{
            var indexSameSeat = 0
            for seatArr in seatSelect{
                if seatArr["seat_number"] as! String == seatDetail["seat_number"] as! String{
                    indexSameSeat++
                }
            }
            
            if indexSameSeat != 0{
                view?.backgroundColor = UIColor.greenColor()
            }else{
                view?.backgroundColor = UIColor.clearColor()
            }
            
        }else{
            view?.backgroundColor = UIColor.clearColor()
        }
        
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        let view = cell?.viewWithTag(200)
        
        let seatDetail = seat[collectionView.tag][indexPath.row] as! NSDictionary
        
        if seatSelect.count != 0{
            var indexSeat = 0
            var indexSameSeat = 0
            for seatArr in seatSelect{

                if seatArr["seat_number"] as! String == seatDetail["seat_number"] as! String{
                    seatSelect.removeAtIndex(indexSeat)
                    indexSameSeat++
                }
                indexSeat++
            }
        
            if indexSameSeat == 0{
                seatSelect.append(seatDetail)
                view?.backgroundColor = UIColor.greenColor()
            }else{
                view?.backgroundColor = UIColor.clearColor()
            }
        }else{
            seatSelect.append(seatDetail)
            view?.backgroundColor = UIColor.greenColor()
        }
    }
    
    @IBAction func continueButtonPressed(sender: AnyObject) {
        
        let seatNo = seatSelect
        
        print(seatNo)
        let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
        let paymentVC = storyboard.instantiateViewControllerWithIdentifier("PaymentVC") as! PaymentViewController
        //self.navigationController!.pushViewController(paymentVC, animated: true)
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
