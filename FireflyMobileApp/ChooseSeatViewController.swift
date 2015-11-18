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
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //let cell = collectionView.cellForItemAtIndexPath(indexPath)
        //let view = cell?.viewWithTag(200)
        
        //var seatDict = [String : AnyObject]()
        
        //seatDict["row"] = String(format: "%i", collectionView.tag)
        //seatDict["cols"] = indexPath
        
       // if (seat.count != 0) {
           // var count = 0, ind = 0;
           // let discardedItem = Set<String>()
            //NSMutableIndexSet *discardedItems = [NSMutableIndexSet indexSet];
            
         //   for temp in seat{
         //       print(temp)
         //   }
            
           /* for(NSMutableDictionary *temp in seat){
                
                if ([[temp objectForKey:@"col"] isEqual:indexPath] && [[temp objectForKey:@"row"] isEqual:[NSString stringWithFormat:@"%li",collectionView.tag]]) {
                    [view setBackgroundColor:[UIColor clearColor]];
                    [discardedItems addIndex:ind];
                    count++;
                }
                ind++;
            }
            
            [seat removeObjectsAtIndexes:discardedItems];
            
            if(count == 0){
                [view setBackgroundColor:[UIColor greenColor]];
                [seat addObject:seatDict];
            }*/
        //}else{
            //[view setBackgroundColor:[UIColor greenColor]];
            //[seat addObject:seatDict];
          //  seat.insert(seatDict, atIndex: 0)
        //}
        
    }
    
    @IBAction func continueButtonPressed(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
        let paymentVC = storyboard.instantiateViewControllerWithIdentifier("PaymentVC") as! PaymentViewController
        self.navigationController!.pushViewController(paymentVC, animated: true)
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
