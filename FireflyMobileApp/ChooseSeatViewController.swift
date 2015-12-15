//
//  ChooseSeatViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/17/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit

class ChooseSeatViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var seatTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeftButton()
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
        return 5
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.seatTableView.dequeueReusableCellWithIdentifier("seatRowCell", forIndexPath: indexPath) as! CustomChooseSeatTableViewCell
        cell.seatCollectionView.tag = indexPath.row + 1
        cell.seatCollectionView.reloadData()
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("seatCell", forIndexPath: indexPath)
        
        let titleLabel = cell.viewWithTag(100) as! UILabel
        
        if indexPath.row == 0 {
            
            titleLabel.text = String(format: "%iA", collectionView.tag)
            
        }else if (indexPath.row == 1) {
            
            titleLabel.text = String(format: "%iC", collectionView.tag)
            cell.contentView.backgroundColor = UIColor.redColor()
            cell.userInteractionEnabled = false
            
        }else if (indexPath.row == 2) {
            
            titleLabel.text = String(format: "%iD", collectionView.tag)
            
        }else{
            titleLabel.text = String(format: "%iF", collectionView.tag)
            cell.contentView.backgroundColor = UIColor.lightGrayColor()
        }
        
        return cell;
    }
    
    var seatSelect = [AnyObject]()
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        let view = cell?.viewWithTag(200)
        let seatLbl = cell?.viewWithTag(100) as! UILabel
        
        var seatDict = [String : AnyObject]()
        seatDict.updateValue(seatLbl.text!, forKey: "seatNo")
        
        if seatSelect.count != 0{
            var count = Int()
            var indexUnselect = Int()
            for seatArr in seatSelect{
                
                if seatArr["seatNo"] as! String == seatDict["seatNo"] as! String{                    view!.backgroundColor = UIColor.clearColor()
                    seatSelect.removeAtIndex(indexUnselect)
                    count++
                }
                indexUnselect++
            }
            
            if count == 0{
                view!.backgroundColor = UIColor.greenColor()
                seatSelect.append(seatDict)
            }
        }else{
            view!.backgroundColor = UIColor.greenColor()
            seatSelect.append(seatDict)
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
