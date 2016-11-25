//
//  CommonSeatSelectionViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/19/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import SCLAlertView

class CommonSeatSelectionViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var seatTableView: UITableView!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var stdSeatLbl: UILabel!
    @IBOutlet weak var preferedSeatLbl: UILabel!
    @IBOutlet weak var desiredSeatLbl: UILabel!
    
    var seatFare = [AnyObject]()
    var seatSelect = [AnyObject]()
    var sectionSelect = IndexPath()
    var sectionSeatRemove = IndexPath()
    var isEdit = Bool()
    var selectChange = Bool()
    var isSelect = Bool()
    var returnCheckInCount = Int()
    var details = [Dictionary<String,AnyObject>]()
    var passenger = [AnyObject]()
    var journeys = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueBtn.layer.cornerRadius = 10
        setupLeftButton()
        
        seatTableView.estimatedRowHeight = 80
        seatTableView.rowHeight = UITableViewAutomaticDimension
        
        sectionSelect = IndexPath(row: 0, section: 0)//(forRow: 0, inSection: 0)
        
        stdSeatLbl.text = "\(seatFare[0]["name"] as! String) \(seatFare[0]["price"] as! String)"
        preferedSeatLbl.text = "\(seatFare[1]["name"] as! String) \(seatFare[1]["price"] as! String)"
        desiredSeatLbl.text = "\(seatFare[2]["name"] as! String) \(seatFare[2]["price"] as! String)"
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK : Tableview delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if details.count == 2 {
            return 3
        }
        else{
            return 2
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if details.count == 2{
            if section == 0 || section == 1{
                if isEdit{
                    return passenger[0].count
                }else{
                    return passenger.count
                }
                
            }else{
                return details[0]["seat_info"]!.count
            }
        }else{
            if section == 0{
                if isEdit{
                    return passenger[0].count
                }else{
                    return passenger.count
                }
            }else{
                return details[0]["seat_info"]!.count
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        if details.count == 2{
            
            if section == 0{
                let view = Bundle.main.loadNibNamed("directionView", owner: self, options: nil)?[0] as! DirectionView
                view.direction.text = "\(details[0]["departure_station"]!) - \(details[0]["arrival_station"]!)"
                return view
            }else{
                let view = Bundle.main.loadNibNamed("directionView", owner: self, options: nil)?[0] as! DirectionView
                view.direction.text = "\(details[1]["departure_station"]!) - \(details[1]["arrival_station"]!)"
                return view
            }
            
        }else{
            
            let view = Bundle.main.loadNibNamed("directionView", owner: self, options: nil)?[0] as! DirectionView
            view.direction.text = "\(details[0]["departure_station"]!) - \(details[0]["arrival_station"]!)"
            return view
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if details.count == 2{
            if indexPath.section != 2{
                
                let cell = self.seatTableView.cellForRow(at: indexPath) as! CustomSeatSelectionTableViewCell
                cell.rowView.backgroundColor = UIColor.yellow
                sectionSelect = indexPath
                self.seatTableView.reloadData()
                
            }
        }else{
            if indexPath.section != 1{
                
                let cell = self.seatTableView.cellForRow(at: indexPath) as! CustomSeatSelectionTableViewCell
                cell.rowView.backgroundColor = UIColor.yellow
                sectionSelect = indexPath
                self.seatTableView.reloadData()
                
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = self.seatTableView.dequeueReusableCell(withIdentifier: "PassengerCell", for: indexPath) as! CustomSeatSelectionTableViewCell
            
            let passengerDetail = passenger[indexPath.row] as! Dictionary<String, AnyObject>
            let passengerName = "\(passengerDetail["title"]!). \(passengerDetail["first_name"]!) \(passengerDetail["last_name"]!)"
            
            if (indexPath.section == sectionSelect.section) && (indexPath.row == sectionSelect.row){
                cell.rowView.backgroundColor = UIColor.yellow
            }else{
                cell.rowView.backgroundColor = UIColor.clear
            }
            
            cell.removeSeat.accessibilityHint = "section:\(indexPath.section),row:\(indexPath.row)"
            cell.removeSeat.addTarget(self, action: #selector(CommonSeatSelectionViewController.removeSeat(_:)), for: .touchUpInside)
            if seatDict.count != 0{
                
                if seatDict["\(indexPath.section)"] != nil{
                    
                    let tempSeat = seatDict["\(indexPath.section)"] as! [String:AnyObject]
                    
                    if tempSeat["\(indexPath.row)"] != nil{
                        let data = tempSeat["\(indexPath.row)"] as! NSDictionary
                        cell.seatNumber.text = data["seat_number"] as? String
                        
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
            cell.seatNumber.layer.borderColor = UIColor.black.cgColor
            cell.passengerName.text = passengerName
            
            return cell
        }else if (indexPath.section == 1 && details.count == 2){
            let cell = self.seatTableView.dequeueReusableCell(withIdentifier: "PassengerCell", for: indexPath) as! CustomSeatSelectionTableViewCell
            
            let passengerDetail = passenger[indexPath.row] as! Dictionary<String, AnyObject>
            
            let passengerName = "\(passengerDetail["title"]!). \(passengerDetail["first_name"]!) \(passengerDetail["last_name"]!)"
            
            if (indexPath.section == sectionSelect.section) && (indexPath.row == sectionSelect.row){
                cell.rowView.backgroundColor = UIColor.yellow
            }else{
                cell.rowView.backgroundColor = UIColor.clear
            }
            
            cell.removeSeat.accessibilityHint = "section:\(indexPath.section),row:\(indexPath.row)"
            cell.removeSeat.addTarget(self, action: #selector(CommonSeatSelectionViewController.removeSeat(_:)), for: .touchUpInside)
            
            if seatDict.count != 0{
                
                if seatDict["\(indexPath.section)"] != nil{
                    if seatDict["\(indexPath.section)"] != nil{
                        
                        let tempSeat = seatDict["\(indexPath.section)"] as! Dictionary<String, AnyObject>
                        
                        if tempSeat["\(indexPath.row)"] != nil{
                            
                            let data = tempSeat["\(indexPath.row)"] as! Dictionary<String, AnyObject>
                            cell.seatNumber.text = data["seat_number"] as? String
                            
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
            cell.seatNumber.layer.borderColor = UIColor.black.cgColor
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
    
    func removeSeat(_ sender:UIButton){
        
        let indexpathArr = sender.accessibilityHint?.components(separatedBy: ",")
        let section = indexpathArr![0].components(separatedBy: "section:")
        let row = indexpathArr![1].components(separatedBy: "row:")
        
        if section[1] == "0"{
            passengers1.removeValue(forKey: "\(row[1])")
            
            if passengers1.count == 0{
                seatDict.removeValue(forKey: "\(section[1])")
            }else{
                seatDict.updateValue(passengers1 as AnyObject, forKey: "\(section[1])")
            }
            
        }else{
            passengers2.removeValue(forKey: "\(row[1])")
            if passengers2.count == 0{
                seatDict.removeValue(forKey: "\(section[1])")
            }else{
                seatDict.updateValue(passengers2 as AnyObject, forKey: "\(section[1])")
            }
        }
        
        sectionSeatRemove = IndexPath(row: Int(row[1])!, section: Int(section[1])!)//NSIndexPath(forRow: Int(row[1])!, inSection: Int(section[1])!)
        self.seatTableView.reloadData()
        
    }
    
    func cellConfiguration(_ indexPath:IndexPath, selectIndex : Int) -> CustomSeatSelectionTableViewCell{
        
        let cell = self.seatTableView.dequeueReusableCell(withIdentifier: "seatRowCell", for: indexPath) as! CustomSeatSelectionTableViewCell
        
        var seatCols = [AnyObject]()
        
        if selectIndex != 0 && selectIndex != 1{
            let temp = details[0]["seat_info"] as! [AnyObject]
            seatCols = temp[indexPath.row] as! [AnyObject]
        }
        else{
            let temp = details[selectIndex]["seat_info"] as! [AnyObject]
            seatCols = temp[indexPath.row] as! [AnyObject]
        }
        
        
        if seatCols[0]["seat_type"] as! String == "preferred"{
            cell.rowView.backgroundColor =  UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 1.0)
        }else if seatCols[0]["seat_type"] as! String  == "standard"{
            cell.rowView.backgroundColor = UIColor(red: 255/255, green: 165/255, blue: 0/255, alpha: 1.0)
        }else{
            cell.rowView.backgroundColor = UIColor(red: 149/255, green: 201/255, blue: 74/255, alpha: 1.0)
        }
        
        var index = 0
        for seatDetail in seatCols{
            
            if index == 0{
                
                if selectIndex == 90 && !isSelect{
                    self.cellConfig(cell.lbla, btn: cell.colABtn, view: cell.colAView, seatDetail: seatDetail as! Dictionary<String, String> , row: indexPath.row, action: #selector(CommonSeatSelectionViewController.nonSelect))
                }else{
                    self.cellConfig(cell.lbla, btn: cell.colABtn, view: cell.colAView, seatDetail: seatDetail as! Dictionary<String, String> , row: indexPath.row, action: #selector(CommonSeatSelectionViewController.selectColASeat(_:)))
                }
                
                
            }else if index == 1{
                
                if selectIndex == 90 && !isSelect{
                    self.cellConfig(cell.lblC, btn: cell.colCBtn, view: cell.colCView, seatDetail: seatDetail as! Dictionary<String, String> , row: indexPath.row, action: #selector(CommonSeatSelectionViewController.nonSelect))
                }else{
                    self.cellConfig(cell.lblC, btn: cell.colCBtn, view: cell.colCView, seatDetail: seatDetail as! Dictionary<String, String> , row: indexPath.row, action: #selector(CommonSeatSelectionViewController.selectColCSeat(_:)))
                }
                
                
                
            }else if index == 2{
                
                if selectIndex == 90 && !isSelect{
                    self.cellConfig(cell.lblD, btn: cell.colDBtn, view: cell.colDView, seatDetail: seatDetail as! Dictionary<String, String> , row: indexPath.row, action: #selector(CommonSeatSelectionViewController.nonSelect))
                }else{
                    self.cellConfig(cell.lblD, btn: cell.colDBtn, view: cell.colDView, seatDetail: seatDetail as! Dictionary<String, String> , row: indexPath.row, action: #selector(CommonSeatSelectionViewController.selectColDSeat(_:)))
                }
                
                
            }else{
                
                if selectIndex == 90 && !isSelect{
                    self.cellConfig(cell.lblF, btn: cell.colFBtn, view: cell.colFView, seatDetail: seatDetail as! Dictionary<String, String> , row: indexPath.row, action: #selector(CommonSeatSelectionViewController.nonSelect))
                }else{
                    self.cellConfig(cell.lblF, btn: cell.colFBtn, view: cell.colFView, seatDetail: seatDetail as! Dictionary<String, String> , row: indexPath.row, action: #selector(CommonSeatSelectionViewController.selectColFSeat(_:)))
                }
                
                
                
            }
            
            index += 1
        }
        
        return cell
    }
    
    // MARK: - Helper
    var seatDict = [String:AnyObject]()
    var passengers1 = [String:AnyObject]()
    var passengers2 = [String:AnyObject]()
    var isFirstSelect = Bool()
    var isStandardSelect = Bool()
    var isPreferedSelect = Bool()
    
    var seatTypeDict = [String:AnyObject]()
    var seatType1 = [String:AnyObject]()
    var seatType2 = [String:AnyObject]()
    
    func seatSelect(_ seatDetail: Dictionary<String,AnyObject>, btn: UIButton){
        
        // Create custom Appearance Configuration
        let appearance = SCLAlertView.SCLAppearance(
            kCircleIconHeight: 40,
            kTitleFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCircularIcon: true
        )
        let alertViewIcon = UIImage(named: "alertIcon")
        let messageView = SCLAlertView(appearance: appearance)
        messageView.addButton("Ok") {
            
            self.selectChange = true
            var sectionIndex = Int()
            var rowIndex = Int()
            var countError = Int()
            
            if self.sectionSelect.section != 0 && self.sectionSelect.section != 1{
                sectionIndex = 0
                rowIndex = 0
            }else{
                sectionIndex = self.sectionSelect.section
                rowIndex = self.sectionSelect.row
            }
            
            
            if self.seatDict.count != 0{
                
                if !self.isFirstSelect{
                    if (self.seatTypeDict["\(sectionIndex)"] != nil){
                        let passengerSection = self.seatTypeDict["\(sectionIndex)"] as! NSDictionary
                        if (passengerSection["\(rowIndex)"] != nil){
                            let passengerRow = passengerSection["\(rowIndex)"]
                            if passengerRow as! String == "desired"{
                                
                                if seatDetail["seat_type"] as! String == "desired"{
                                    if self.seatDict["\(sectionIndex)"]?.count == self.passenger.count{
                                        
                                        if sectionIndex == 0{
                                            self.passengers1.updateValue(seatDetail as AnyObject, forKey: "\(rowIndex)")
                                            self.seatDict.updateValue(self.passengers1 as AnyObject, forKey: "\(sectionIndex)")
                                        }else{
                                            self.passengers2.updateValue(seatDetail as AnyObject, forKey: "\(rowIndex)")
                                            self.seatDict.updateValue(self.passengers2 as AnyObject, forKey: "\(sectionIndex)")
                                        }
                                        
                                        btn.isUserInteractionEnabled = false
                                        //btn.backgroundColor = UIColor.greenColor()
                                        
                                    }else{
                                        if sectionIndex == 0{
                                            self.passengers1.updateValue(seatDetail as AnyObject, forKey: "\(rowIndex)")
                                            self.seatDict.updateValue(self.passengers1 as AnyObject, forKey: "\(sectionIndex)")
                                        }else{
                                            self.passengers2.updateValue(seatDetail as AnyObject, forKey: "\(rowIndex)")
                                            self.seatDict.updateValue(self.passengers2 as AnyObject, forKey: "\(sectionIndex)")
                                        }
                                        
                                        //btn.backgroundColor = UIColor.greenColor()
                                        btn.isUserInteractionEnabled = false
                                    }
                                }else{
                                    showErrorMessage("Seat downgrade not allowed")
                                    countError += 1
                                }
                                
                            }else if passengerRow as! String == "preferred"{
                                
                                if seatDetail["seat_type"] as! String == "desired" || seatDetail["seat_type"] as! String == "preferred"{
                                    //isPreferedSelect = true
                                    if self.seatDict["\(sectionIndex)"]?.count == self.passenger.count{
                                        
                                        if sectionIndex == 0{
                                            self.passengers1.updateValue(seatDetail as AnyObject, forKey: "\(rowIndex)")
                                            self.seatDict.updateValue(self.passengers1 as AnyObject, forKey: "\(sectionIndex)")
                                        }else{
                                            self.passengers2.updateValue(seatDetail as AnyObject, forKey: "\(rowIndex)")
                                            self.seatDict.updateValue(self.passengers2 as AnyObject, forKey: "\(sectionIndex)")
                                        }
                                        
                                        btn.isUserInteractionEnabled = false
                                        //btn.backgroundColor = UIColor.greenColor()
                                        
                                    }else{
                                        if sectionIndex == 0{
                                            self.passengers1.updateValue(seatDetail as AnyObject, forKey: "\(rowIndex)")
                                            self.seatDict.updateValue(self.passengers1 as AnyObject, forKey: "\(sectionIndex)")
                                        }else{
                                            self.passengers2.updateValue(seatDetail as AnyObject, forKey: "\(rowIndex)")
                                            self.seatDict.updateValue(self.passengers2 as AnyObject, forKey: "\(sectionIndex)")
                                        }
                                        
                                        //btn.backgroundColor = UIColor.greenColor()
                                        btn.isUserInteractionEnabled = false
                                    }
                                }else{
                                    showErrorMessage("Seat downgrade not allowed")
                                    countError += 1
                                }
                                
                            }else{
                                if self.seatDict["\(sectionIndex)"]?.count == self.passenger.count{
                                    
                                    if sectionIndex == 0{
                                        self.passengers1.updateValue(seatDetail as AnyObject, forKey: "\(rowIndex)")
                                        self.seatDict.updateValue(self.passengers1 as AnyObject, forKey: "\(sectionIndex)")
                                    }else{
                                        self.passengers2.updateValue(seatDetail as AnyObject, forKey: "\(rowIndex)")
                                        self.seatDict.updateValue(self.passengers2 as AnyObject, forKey: "\(sectionIndex)")
                                    }
                                    
                                    btn.isUserInteractionEnabled = false
                                    //btn.backgroundColor = UIColor.greenColor()
                                    
                                }else{
                                    if sectionIndex == 0{
                                        self.passengers1.updateValue(seatDetail as AnyObject, forKey: "\(rowIndex)")
                                        self.seatDict.updateValue(self.passengers1 as AnyObject, forKey: "\(sectionIndex)")
                                    }else{
                                        self.passengers2.updateValue(seatDetail as AnyObject, forKey: "\(rowIndex)")
                                        self.seatDict.updateValue(self.passengers2 as AnyObject, forKey: "\(sectionIndex)")
                                    }
                                    
                                    //btn.backgroundColor = UIColor.greenColor()
                                    btn.isUserInteractionEnabled = false
                                }
                            }
                        }else{
                            //isStandardSelect = true
                            if self.seatDict["\(sectionIndex)"]?.count == self.passenger.count{
                                
                                if sectionIndex == 0{
                                    self.passengers1.updateValue(seatDetail as AnyObject, forKey: "\(rowIndex)")
                                    self.seatDict.updateValue(self.passengers1 as AnyObject, forKey: "\(sectionIndex)")
                                }else{
                                    self.passengers2.updateValue(seatDetail as AnyObject, forKey: "\(rowIndex)")
                                    self.seatDict.updateValue(self.passengers2 as AnyObject, forKey: "\(sectionIndex)")
                                }
                                
                                btn.isUserInteractionEnabled = false
                                //btn.backgroundColor = UIColor.greenColor()
                                
                            }else{
                                if sectionIndex == 0{
                                    self.passengers1.updateValue(seatDetail as AnyObject, forKey: "\(rowIndex)")
                                    self.seatDict.updateValue(self.passengers1 as AnyObject, forKey: "\(sectionIndex)")
                                }else{
                                    self.passengers2.updateValue(seatDetail as AnyObject, forKey: "\(rowIndex)")
                                    self.seatDict.updateValue(self.passengers2 as AnyObject, forKey: "\(sectionIndex)")
                                }
                                
                                //btn.backgroundColor = UIColor.greenColor()
                                btn.isUserInteractionEnabled = false
                            }
                            
                        }
                    }else{
                        //isStandardSelect = true
                        if self.seatDict["\(sectionIndex)"]?.count == self.passenger.count{
                            
                            if sectionIndex == 0{
                                self.passengers1.updateValue(seatDetail as AnyObject, forKey: "\(rowIndex)")
                                self.seatDict.updateValue(self.passengers1 as AnyObject, forKey: "\(sectionIndex)")
                            }else{
                                self.passengers2.updateValue(seatDetail as AnyObject, forKey: "\(rowIndex)")
                                self.seatDict.updateValue(self.passengers2 as AnyObject, forKey: "\(sectionIndex)")
                            }
                            
                            btn.isUserInteractionEnabled = false
                            //btn.backgroundColor = UIColor.greenColor()
                            
                        }else{
                            if sectionIndex == 0{
                                self.passengers1.updateValue(seatDetail as AnyObject, forKey: "\(rowIndex)")
                                self.seatDict.updateValue(self.passengers1 as AnyObject, forKey: "\(sectionIndex)")
                            }else{
                                self.passengers2.updateValue(seatDetail as AnyObject, forKey: "\(rowIndex)")
                                self.seatDict.updateValue(self.passengers2 as AnyObject, forKey: "\(sectionIndex)")
                            }
                            
                            //btn.backgroundColor = UIColor.greenColor()
                            btn.isUserInteractionEnabled = false
                        }
                    }
                }else{
                    //isStandardSelect = true
                    if self.seatDict["\(sectionIndex)"]?.count == self.passenger.count{
                        
                        if sectionIndex == 0{
                            self.passengers1.updateValue(seatDetail as AnyObject, forKey: "\(rowIndex)")
                            self.seatDict.updateValue(self.passengers1 as AnyObject, forKey: "\(sectionIndex)")
                        }else{
                            self.passengers2.updateValue(seatDetail as AnyObject, forKey: "\(rowIndex)")
                            self.seatDict.updateValue(self.passengers2 as AnyObject, forKey: "\(sectionIndex)")
                        }
                        
                        btn.isUserInteractionEnabled = false
                        //btn.backgroundColor = UIColor.greenColor()
                        
                    }else{
                        if sectionIndex == 0{
                            self.passengers1.updateValue(seatDetail as AnyObject, forKey: "\(rowIndex)")
                            self.seatDict.updateValue(self.passengers1 as AnyObject, forKey: "\(sectionIndex)")
                        }else{
                            self.passengers2.updateValue(seatDetail as AnyObject, forKey: "\(rowIndex)")
                            self.seatDict.updateValue(self.passengers2 as AnyObject, forKey: "\(sectionIndex)")
                        }
                        
                        //btn.backgroundColor = UIColor.greenColor()
                        btn.isUserInteractionEnabled = false
                    }
                }
                
            }else{
                
                if (self.seatTypeDict["\(sectionIndex)"] != nil){
                    let passengerSection = self.seatTypeDict["\(sectionIndex)"] as! NSDictionary
                    if (passengerSection["\(rowIndex)"] != nil){
                        let passengerRow = passengerSection["\(rowIndex)"]
                        
                        if passengerRow as! String == "desired"{
                            
                            if seatDetail["seat_type"] as! String == "desired"{
                                if sectionIndex == 0{
                                    self.passengers1.updateValue(seatDetail as AnyObject, forKey: "\(rowIndex)")
                                    self.seatDict.updateValue(self.passengers1 as AnyObject, forKey: "\(sectionIndex)")
                                }else{
                                    self.passengers2.updateValue(seatDetail as AnyObject, forKey: "\(rowIndex)")
                                    self.seatDict.updateValue(self.passengers2 as AnyObject, forKey: "\(sectionIndex)")
                                }
                                
                                //btn.backgroundColor = UIColor.greenColor()
                                btn.isUserInteractionEnabled = false
                            }else{
                                showErrorMessage("Seat downgrade not allowed")
                                countError += 1
                            }
                        }else if passengerRow as! String == "preferred"{
                            if seatDetail["seat_type"] as! String == "desired" || seatDetail["seat_type"] as! String == "preferred"{
                                if sectionIndex == 0{
                                    self.passengers1.updateValue(seatDetail as AnyObject, forKey: "\(rowIndex)")
                                    self.seatDict.updateValue(self.passengers1 as AnyObject, forKey: "\(sectionIndex)")
                                }else{
                                    self.passengers2.updateValue(seatDetail as AnyObject, forKey: "\(rowIndex)")
                                    self.seatDict.updateValue(self.passengers2 as AnyObject, forKey: "\(sectionIndex)")
                                }
                                
                                //btn.backgroundColor = UIColor.greenColor()
                                btn.isUserInteractionEnabled = false
                            }else{
                                showErrorMessage("Seat downgrade not allowed")
                                countError += 1
                            }
                        }else{
                            if sectionIndex == 0{
                                self.passengers1.updateValue(seatDetail as AnyObject, forKey: "\(rowIndex)")
                                self.seatDict.updateValue(self.passengers1 as AnyObject, forKey: "\(sectionIndex)")
                            }else{
                                self.passengers2.updateValue(seatDetail as AnyObject, forKey: "\(rowIndex)")
                                self.seatDict.updateValue(self.passengers2 as AnyObject, forKey: "\(sectionIndex)")
                            }
                            
                            //btn.backgroundColor = UIColor.greenColor()
                            btn.isUserInteractionEnabled = false
                        }
                    }else{
                        if sectionIndex == 0{
                            self.passengers1.updateValue(seatDetail as AnyObject, forKey: "\(rowIndex)")
                            self.seatDict.updateValue(self.passengers1 as AnyObject, forKey: "\(sectionIndex)")
                        }else{
                            self.passengers2.updateValue(seatDetail as AnyObject, forKey: "\(rowIndex)")
                            self.seatDict.updateValue(self.passengers2 as AnyObject, forKey: "\(sectionIndex)")
                        }
                        
                        //btn.backgroundColor = UIColor.greenColor()
                        btn.isUserInteractionEnabled = false
                    }
                }else{
                    self.isFirstSelect = true
                    if sectionIndex == 0{
                        self.passengers1.updateValue(seatDetail as AnyObject, forKey: "\(rowIndex)")
                        self.seatDict.updateValue(self.passengers1 as AnyObject, forKey: "\(sectionIndex)")
                    }else{
                        self.passengers2.updateValue(seatDetail as AnyObject, forKey: "\(rowIndex)")
                        self.seatDict.updateValue(self.passengers2 as AnyObject, forKey: "\(sectionIndex)")
                    }
                    
                    //btn.backgroundColor = UIColor.greenColor()
                    btn.isUserInteractionEnabled = false
                }
                
            }
            
            if countError == 0{
                var passengerCount = 0
                if self.isEdit{
                    passengerCount = self.passenger[0].count
                }else{
                    passengerCount = self.passenger.count
                }
                
                if rowIndex == passengerCount - 1{
                    
                    if sectionIndex != self.details.count - 1{
                        sectionIndex += 1
                        rowIndex = 0
                    }
                    
                    self.sectionSelect = IndexPath(row: rowIndex, section: sectionIndex)//NSIndexPath(forRow: rowIndex, inSection: sectionIndex)
                }else{
                    
                    rowIndex += 1
                    
                    if self.isEdit{
                        let passengerInfo = self.journeys[sectionIndex]["passengers"] as! [AnyObject]
                        let passengerData = passengerInfo[rowIndex]
                        
                        if passengerData["checked_in"] as! String != "Y"{
                            self.sectionSelect = IndexPath(row: rowIndex, section: sectionIndex)
                        }else{
                            
                            rowIndex += 1
                            if rowIndex <= passengerCount - 1{
                                for i in rowIndex..<passengerCount{
                                    
                                    let isCheckSeat = self.checkSeat(passengerInfo[i])
                                    
                                    if !isCheckSeat{
                                        self.sectionSelect = IndexPath(row: rowIndex, section: sectionIndex)
                                        break
                                    }
                                    
                                }
                            }else{
                                if sectionIndex != self.details.count - 1{
                                    sectionIndex += 1
                                    rowIndex = 0
                                    self.sectionSelect = IndexPath(row: rowIndex, section: sectionIndex)
                                }
                                
                            }
                            
                        }
                    }else{
                        self.sectionSelect = IndexPath(row: rowIndex, section: sectionIndex)
                    }
                    
                }
                self.seatTableView.reloadData()
            }

        }
        messageView.showSuccess("Seat Selection", subTitle: "Seat : \(seatDetail["seat_number"] as! String)", closeButtonTitle: "Cancel", colorStyle: 0xEC581A, circleIconImage: alertViewIcon)

    }
    
    func checkSeat(_ passengerInfo : AnyObject) -> Bool{
        
        if passengerInfo["checked_in"] as! String != "Y"{
            return false
        }else{
            return true
        }
        //return true
    }
    
    func cellConfig(_ lbl : UILabel, btn:UIButton, view:UIView, seatDetail:Dictionary<String,String>, row:Int, action:Selector){
        
        if seatDict.count != 0{
            
            if seatDict["\(sectionSelect.section)"] != nil{
                var indexSameSeat = 0
                let tempSeat = seatDict["\(sectionSelect.section)"] as! Dictionary<String,AnyObject>
                //tempSeat["\(sectionSeatRemove.row)"]
                var passengerCount = 0
                if isEdit{
                    passengerCount = passenger[0].count
                }else{
                    passengerCount = passenger.count
                }
                
                for i in 0...passengerCount - 1{
                    
                    if tempSeat["\(i)"] != nil{
                        if let tempSeat = tempSeat["\(i)"]!["seat_number"] as! String? {
                            if tempSeat == seatDetail["seat_number"] {
                                indexSameSeat += 1
                            }
                        }
                    }
                    
                }
                
                if indexSameSeat != 0{
                    lbl.backgroundColor = UIColor.green
                    btn.isUserInteractionEnabled = false
                }else{
                    lbl.backgroundColor = UIColor.clear
                    btn.isUserInteractionEnabled = true
                }
                
            }else{
                lbl.backgroundColor = UIColor.clear
                btn.isUserInteractionEnabled = true
            }
        }else{
            lbl.backgroundColor = UIColor.clear
            btn.isUserInteractionEnabled = true
        }
        
        if seatDetail["status"]  == "available" || seatDetail["status"] == "selected"{
            view.backgroundColor = UIColor.lightGray
        }else{
            view.backgroundColor = UIColor.red
            btn.isUserInteractionEnabled = false
        }
        
        lbl.text = seatDetail["seat_number"]
        //btn.setTitle(seatDetail["seat_number"] as? String, forState: UIControlState.Normal)
        btn.tag = row
        btn.addTarget(self, action: action, for: .touchUpInside)
    }
    
    func nonSelect(){
        
    }
    
    func selectColASeat(_ sender:UIButton){
        
        var section = Int()
        
        if sectionSelect.section != 0 && sectionSelect.section != 1{
            section = 0
        }else{
            section = sectionSelect.section
        }
        
        let seatRowTemp = details[section]["seat_info"] as! [[Dictionary<String,AnyObject>]]
        let seatRow = seatRowTemp[sender.tag]
        
        let seatDetail = seatRow[0]
        
        self.seatSelect(seatDetail, btn: sender)
        
    }
    
    func selectColCSeat(_ sender:UIButton){
        
        var section = Int()
        
        if sectionSelect.section != 0 && sectionSelect.section != 1{
            section = 0
        }else{
            section = sectionSelect.section
        }
        
        let seatRowTemp = details[section]["seat_info"] as! [[Dictionary<String,AnyObject>]]
        let seatRow = seatRowTemp[sender.tag]
        
        let seatDetail = seatRow[1] as Dictionary<String,AnyObject>
        
        self.seatSelect(seatDetail, btn: sender)
        
    }
    
    func selectColDSeat(_ sender:UIButton){
        
        var section = Int()
        
        if sectionSelect.section != 0 && sectionSelect.section != 1{
            section = 0
        }else{
            section = sectionSelect.section
        }
        
        let seatRowTemp = details[section]["seat_info"] as! [[Dictionary<String,AnyObject>]]
        let seatRow = seatRowTemp[sender.tag]
        
        let seatDetail = seatRow[2] as Dictionary<String,AnyObject>
        
        self.seatSelect(seatDetail, btn: sender)
        
    }
    
    func selectColFSeat(_ sender:UIButton){
        
        var section = Int()
        
        if sectionSelect.section != 0 && sectionSelect.section != 1{
            section = 0
        }else{
            section = sectionSelect.section
        }
        
        let seatRowTemp = details[section]["seat_info"] as! [[Dictionary<String,AnyObject>]]
        let seatRow = seatRowTemp[sender.tag]
        
        let seatDetail = seatRow[3] as Dictionary<String,AnyObject>
        
        self.seatSelect(seatDetail, btn: sender)
        
    }
    
}
