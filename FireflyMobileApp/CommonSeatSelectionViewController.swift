//
//  CommonSeatSelectionViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/19/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit

class CommonSeatSelectionViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var seatTableView: UITableView!
    @IBOutlet weak var continueBtn: UIButton!
    var seatSelect = [AnyObject]()
    var sectionSelect = NSIndexPath()
    var isEdit = Bool()
    
    var details = NSMutableArray()
    var passenger = NSArray()
    var journeys = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        continueBtn.layer.cornerRadius = 10
        setupLeftButton()
        sectionSelect = NSIndexPath(forRow: 0, inSection: 0)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK : Tableview delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if details.count == 2{
            return 3
        }else{
            return 2
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if details.count == 2{
            if section == 0 || section == 1{
                
                if isEdit{
                    return passenger[0].count
                }else{
                    return passenger.count
                }
                
            }else{
                return details[0]["seat_info"]!!.count
            }
        }else{
            if section == 0{
                return passenger.count
            }else{
                return details[0]["seat_info"]!!.count
            }
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if details.count == 2{
            if section == 2{
                return 0
            }else{
                return 40
            }
        }else{
            if section == 1{
                return 0
            }else{
                return 40
            }
        }
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if details.count == 2{
            
            if section == 0{
                let view = NSBundle.mainBundle().loadNibNamed("directionView", owner: self, options: nil)[0] as! DirectionView
                view.direction.text = "\(details[0]["departure_station"]!!) - \(details[0]["arrival_station"]!!)"
                return view
            }else{
                let view = NSBundle.mainBundle().loadNibNamed("directionView", owner: self, options: nil)[0] as! DirectionView
                view.direction.text = "\(details[1]["departure_station"]!!) - \(details[1]["arrival_station"]!!)"
                return view
            }
            
        }else{
            
            let view = NSBundle.mainBundle().loadNibNamed("directionView", owner: self, options: nil)[0] as! DirectionView
            view.direction.text = "\(details[0]["departure_station"]!!) - \(details[0]["arrival_station"]!!)"
            return view
            
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if details.count == 2{
            if indexPath.section != 2{
                let cell = self.seatTableView.cellForRowAtIndexPath(indexPath) as! CustomSeatSelectionTableViewCell
                cell.rowView.backgroundColor = UIColor.yellowColor()
                sectionSelect = indexPath
                self.seatTableView.reloadData()
            }
        }else{
            if indexPath.section != 1{
                let cell = self.seatTableView.cellForRowAtIndexPath(indexPath) as! CustomSeatSelectionTableViewCell
                cell.rowView.backgroundColor = UIColor.yellowColor()
                sectionSelect = indexPath
                self.seatTableView.reloadData()
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = self.seatTableView.dequeueReusableCellWithIdentifier("PassengerCell", forIndexPath: indexPath) as! CustomSeatSelectionTableViewCell
            
            var passengerDetail = NSDictionary()
            
            if isEdit{
                passengerDetail = passenger[0][indexPath.row] as! NSDictionary
            }else{
                passengerDetail = passenger[indexPath.row] as! NSDictionary
            }
            
            let passengerName = "\(passengerDetail["title"]!). \(passengerDetail["first_name"]!) \(passengerDetail["last_name"]!)"
            
            //if passengerDetail["checked_in"] as! String == "Y"{
                cell.rowView.backgroundColor = UIColor.lightGrayColor()
            //}else{
                if (indexPath.section == sectionSelect.section) && (indexPath.row == sectionSelect.row){
                    cell.rowView.backgroundColor = UIColor.yellowColor()
                }else{
                    cell.rowView.backgroundColor = UIColor.clearColor()
                }
                
                cell.removeSeat.accessibilityHint = "section:\(indexPath.section),row:\(indexPath.row)"
                cell.removeSeat.addTarget(self, action: "removeSeat:", forControlEvents: .TouchUpInside)
            //}
            
            
            
            if seatDict.count != 0{
                
                if seatDict["\(indexPath.section)"] != nil{
                    
                    let tempSeat = seatDict["\(indexPath.section)"] as! NSDictionary
                    
                    if tempSeat["\(indexPath.row)"] != nil{
                        
                        cell.seatNumber.text = tempSeat["\(indexPath.row)"]!["seat_number"] as? String
                        
                    }else{
                        cell.seatNumber.text = ""
                    }
                    
                }else{
                    cell.seatNumber.text = ""
                }
                
            }else{
                cell.seatNumber.text = ""
            }
            
            cell.seatNumber.layer.cornerRadius = 10
            cell.seatNumber.layer.borderWidth = 1
            cell.seatNumber.layer.borderColor = UIColor.blackColor().CGColor
            cell.passengerName.text = passengerName
            
            return cell
        }else if (indexPath.section == 1 && details.count == 2){
            let cell = self.seatTableView.dequeueReusableCellWithIdentifier("PassengerCell", forIndexPath: indexPath) as! CustomSeatSelectionTableViewCell
            
            //let passengerDetail = passenger[indexPath.row] as! NSDictionary
            var passengerDetail = NSDictionary()
            
            if isEdit{
                passengerDetail = passenger[1][indexPath.row] as! NSDictionary
            }else{
                passengerDetail = passenger[indexPath.row] as! NSDictionary
            }
            
            let passengerName = "\(passengerDetail["title"]!). \(passengerDetail["first_name"]!) \(passengerDetail["last_name"]!)"
            
            //if passengerDetail["checked_in"] as! String == "Y"{
            //    cell.rowView.backgroundColor = UIColor.lightGrayColor()
            //}else{
                if (indexPath.section == sectionSelect.section) && (indexPath.row == sectionSelect.row){
                    cell.rowView.backgroundColor = UIColor.yellowColor()
                }else{
                    cell.rowView.backgroundColor = UIColor.clearColor()
                }
                
                cell.removeSeat.accessibilityHint = "section:\(indexPath.section),row:\(indexPath.row)"
                cell.removeSeat.addTarget(self, action: "removeSeat:", forControlEvents: .TouchUpInside)
           // }
            
            if seatDict.count != 0{
                
                if seatDict["\(indexPath.section)"] != nil{
                    if seatDict["\(indexPath.section)"] != nil{
                        
                        let tempSeat = seatDict["\(indexPath.section)"] as! NSDictionary
                        
                        if tempSeat["\(indexPath.row)"] != nil{
                            
                            cell.seatNumber.text = tempSeat["\(indexPath.row)"]!["seat_number"] as? String
                            
                        }else{
                            cell.seatNumber.text = ""
                        }
                        
                    }else{
                        cell.seatNumber.text = ""
                    }
                }else{
                    cell.seatNumber.text = ""
                }
                
                
            }else{
                cell.seatNumber.text = ""
            }
            
            cell.seatNumber.layer.cornerRadius = 10
            cell.seatNumber.layer.borderWidth = 1
            cell.seatNumber.layer.borderColor = UIColor.blackColor().CGColor
            cell.passengerName.text = passengerName
            cell.removeSeat.tag = indexPath.row
            
            
            return cell
        }else{
            
            var cell = CustomSeatSelectionTableViewCell()
            
            if details.count == 2{
                cell = cellConfiguration(indexPath, selectIndex: sectionSelect.section)
            }else{
                cell = cellConfiguration(indexPath, selectIndex: 0)
            }
            
            return cell
        }
    }
    
    func removeSeat(sender:UIButton){
        let indexpathArr = sender.accessibilityHint?.componentsSeparatedByString(",")
        let section = indexpathArr![0].componentsSeparatedByString("section:")
        let row = indexpathArr![1].componentsSeparatedByString("row:")
        
        if section[1] == "0"{
            passengers1.removeValueForKey("\(row[1])")
            seatDict.updateValue(passengers1, forKey: "\(section[1])")
        }else{
            passengers2.removeValueForKey("\(row[1])")
            seatDict.updateValue(passengers2, forKey: "\(section[1])")
        }
        
        self.seatTableView.reloadData()
        
    }
    
    func cellConfiguration(indexPath:NSIndexPath, selectIndex : Int) -> CustomSeatSelectionTableViewCell{
        
        let cell = self.seatTableView.dequeueReusableCellWithIdentifier("seatRowCell", forIndexPath: indexPath) as! CustomSeatSelectionTableViewCell
        
        var seatCols = NSArray()
        
        if selectIndex != 0 && selectIndex != 1{
            seatCols = details[0]["seat_info"]!![indexPath.row] as! NSArray
        }else{
            seatCols = details[selectIndex]["seat_info"]!![indexPath.row] as! NSArray
        }
        
        
        if seatCols[0]["seat_type"] as! String == "preferred"{
            cell.rowView.backgroundColor =  UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 1.0)
        }else if seatCols[0]["seat_type"] as! String == "standard"{
            cell.rowView.backgroundColor = UIColor(red: 255/255, green: 165/255, blue: 0/255, alpha: 1.0)
        }else{
            cell.rowView.backgroundColor = UIColor(red: 149/255, green: 201/255, blue: 74/255, alpha: 1.0)
        }
        
        var index = 0
        for seatDetail in seatCols{
            
            if index == 0{
                
                self.cellConfig(cell.colABtn, view: cell.colAView, seatDetail: seatDetail as! NSDictionary, row: indexPath.row, action: "selectColASeat:")
                
            }else if index == 1{
                
                self.cellConfig(cell.colCBtn, view: cell.colCView, seatDetail: seatDetail as! NSDictionary, row: indexPath.row, action: "selectColCSeat:")
                
            }else if index == 2{
                
                self.cellConfig(cell.colDBtn, view: cell.colDView, seatDetail: seatDetail as! NSDictionary, row: indexPath.row, action: "selectColDSeat:")
            }else{
                
                self.cellConfig(cell.colFBtn, view: cell.colFView, seatDetail: seatDetail as! NSDictionary, row: indexPath.row, action: "selectColFSeat:")
                
            }
            
            index++
        }
        
        return cell
    }
    
    // MARK: - Helper
    var seatDict = [String:AnyObject]()
    var passengers1 = [String:AnyObject]()
    var passengers2 = [String:AnyObject]()
    
    func seatSelect(seatDetail: NSDictionary, btn: UIButton){
        
        var sectionIndex = Int()
        var rowIndex = Int()
        
        if sectionSelect.section != 0 && sectionSelect.section != 1{
            sectionIndex = 0
            rowIndex = 0
        }else{
            sectionIndex = sectionSelect.section
            rowIndex = sectionSelect.row
        }
        
        if seatDict.count != 0{
            
            if seatDict["\(sectionIndex)"]?.count == passenger.count{
                
                if sectionIndex == 0{
                    passengers1.updateValue(seatDetail, forKey: "\(rowIndex)")
                    seatDict.updateValue(passengers1, forKey: "\(sectionIndex)")
                }else{
                    passengers2.updateValue(seatDetail, forKey: "\(rowIndex)")
                    seatDict.updateValue(passengers2, forKey: "\(sectionIndex)")
                }
                
                btn.userInteractionEnabled = false
                btn.backgroundColor = UIColor.greenColor()
                
            }else{
                if sectionIndex == 0{
                    passengers1.updateValue(seatDetail, forKey: "\(rowIndex)")
                    seatDict.updateValue(passengers1, forKey: "\(sectionIndex)")
                }else{
                    passengers2.updateValue(seatDetail, forKey: "\(rowIndex)")
                    seatDict.updateValue(passengers2, forKey: "\(sectionIndex)")
                }
                
                btn.backgroundColor = UIColor.greenColor()
                btn.userInteractionEnabled = false
            }
            
            
        }else{
            if sectionIndex == 0{
                passengers1.updateValue(seatDetail, forKey: "\(rowIndex)")
                seatDict.updateValue(passengers1, forKey: "\(sectionIndex)")
            }else{
                passengers2.updateValue(seatDetail, forKey: "\(rowIndex)")
                seatDict.updateValue(passengers2, forKey: "\(sectionIndex)")
            }
            
            btn.backgroundColor = UIColor.greenColor()
            btn.userInteractionEnabled = false
        }
        
        self.seatTableView.reloadData()
    }
    
    func cellConfig(btn:UIButton, view:UIView, seatDetail:NSDictionary, row:Int, action:Selector){
        
        if seatDict.count != 0{
            
            if seatDict["\(sectionSelect.section)"] != nil{
                var indexSameSeat = 0
                let tempSeat = seatDict["\(sectionSelect.section)"] as! NSDictionary
                
                for var i=0; i<tempSeat.count; i=i+1{
                    if tempSeat["\(i)"]!["seat_number"] as! String == seatDetail["seat_number"] as! String{
                        indexSameSeat++
                    }
                }
                
                if indexSameSeat != 0{
                    btn.backgroundColor = UIColor.greenColor()
                    btn.userInteractionEnabled = false
                }else{
                    btn.backgroundColor = UIColor.clearColor()
                    btn.userInteractionEnabled = true
                }
                
            }else{
                btn.backgroundColor = UIColor.clearColor()
                btn.userInteractionEnabled = true
            }
        }else{
            btn.backgroundColor = UIColor.clearColor()
            btn.userInteractionEnabled = true
        }
        
        if seatDetail["status"] as! String == "available" || seatDetail["status"] as! String == "selected"{
            view.backgroundColor = UIColor.lightGrayColor()
        }else{
            view.backgroundColor = UIColor.redColor()
            btn.userInteractionEnabled = false
        }
        
        btn.setTitle(seatDetail["seat_number"] as? String, forState: UIControlState.Normal)
        btn.tag = row
        btn.addTarget(self, action: action, forControlEvents: .TouchUpInside)
    }
    
    func selectColASeat(sender:UIButton){
        
        var section = Int()
        
        if sectionSelect.section != 0 && sectionSelect.section != 1{
            section = 0
        }else{
            section = sectionSelect.section
        }
        
        let seatRow = details[section]["seat_info"]!![sender.tag] as! NSArray
        
        let seatDetail = seatRow[0] as! NSDictionary
        
        self.seatSelect(seatDetail, btn: sender)
        
    }
    
    func selectColCSeat(sender:UIButton){
        
        var section = Int()
        
        if sectionSelect.section != 0 && sectionSelect.section != 1{
            section = 0
        }else{
            section = sectionSelect.section
        }
        
        let seatRow = details[section]["seat_info"]!![sender.tag] as! NSArray
        
        let seatDetail = seatRow[1] as! NSDictionary
        
        self.seatSelect(seatDetail, btn: sender)
        
    }
    
    func selectColDSeat(sender:UIButton){
        
        var section = Int()
        
        if sectionSelect.section != 0 && sectionSelect.section != 1{
            section = 0
        }else{
            section = sectionSelect.section
        }
        
        let seatRow = details[section]["seat_info"]!![sender.tag] as! NSArray
        
        let seatDetail = seatRow[2] as! NSDictionary
        
        self.seatSelect(seatDetail, btn: sender)
        
    }
    
    func selectColFSeat(sender:UIButton){
        
        var section = Int()
        
        if sectionSelect.section != 0 && sectionSelect.section != 1{
            section = 0
        }else{
            section = sectionSelect.section
        }
        
        let seatRow = details[section]["seat_info"]!![sender.tag] as! NSArray
        
        let seatDetail = seatRow[3] as! NSDictionary
        
        self.seatSelect(seatDetail, btn: sender)
        
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
