//
//  CommonMHFlightDetailViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 2/28/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import M13Checkbox

class CommonMHFlightDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var flightDetailTableView: UITableView!
    @IBOutlet weak var continueView: UIView!
    @IBOutlet weak var fareRule: UITextView!
    @IBOutlet weak var termCondition: UITextView!
    @IBOutlet weak var termCheckBox: M13Checkbox!
    
    @IBOutlet weak var continueBtn: UIButton!
    var infant = String()
    var adult = String()
    var flightDetail : Array<JSON> = []
    var checkGoingIndexPath = IndexPath()
    var checkReturnIndexPath = IndexPath()
    var checkGoingIndex = String()
    var checkReturnIndex = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeftButton()
        continueBtn.layer.cornerRadius = 10
        if flightDetail.count == 0{
            self.continueView.isHidden = true
        }
        checkGoingIndexPath = IndexPath(row: 0, section: 0)
        checkReturnIndexPath = IndexPath(row: 0, section: 0)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if flightDetail.count == 0{
            return 1
        }else{
            return flightDetail.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if flightDetail.count == 0{
            return 1
        }else{
            let flightDict = flightDetail[section].dictionary
            
            if flightDict!["flights"]?.count == 0{
                return 1
            }else{
                return (flightDict!["flights"]?.count)!
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let flightDict = flightDetail[indexPath.section].dictionary
        
        if flightDict!["flights"]?.count == 0{
            return 107
        }else{
            return 222
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if flightDetail.count == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoFlightCell", for: indexPath)
            return cell
        }else{
            
            let flightDict = flightDetail[indexPath.section].dictionary
            
            if flightDict!["flights"]?.count == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "NoFlightCell", for: indexPath)
                return cell
            }else{
                let cell = self.flightDetailTableView.dequeueReusableCell(withIdentifier: "flightCell", for: indexPath) as! CustomMHFlightDetailTableViewCell
                
                let flights = flightDict!["flights"]?.array
                let flightData = flights![indexPath.row].dictionary
                
                let economyPromo = flightData!["economy_promo_class"]!.dictionary
                let economy = flightData!["economy_class"]!.dictionary
                let business = flightData!["business_class"]!.dictionary
                
                cell.flightNumber.text = String(format: "FLIGHT NO. FY %@", flightData!["flight_number"]!.string!)
                cell.operateLbl.text = String(format: "Operated by Malaysia Airlines (MH%@)", flightData!["mh_flight_number"]!.string!)
                cell.departureAirportLbl.text = "\(flightDict!["departure_station_name"]!.stringValue)"
                cell.arrivalAirportLbl.text = "\(flightDict!["arrival_station_name"]!.stringValue)"
                cell.departureTimeLbl.text = flightData!["departure_time"]!.string
                cell.arrivalTimeLbl.text = flightData!["arrival_time"]!.string
                
                if economyPromo!["status"]?.string == "sold out"{
                    cell.economyPromoSoldView.isHidden = false
                    cell.economyPromoNotAvailableView.isHidden = true
                    cell.economyPromoBtn.isHidden = true
                }else if economyPromo!["status"]?.string == "Not Available"{
                    cell.economyPromoSoldView.isHidden = true
                    cell.economyPromoNotAvailableView.isHidden = false
                    cell.economyPromoBtn.isHidden = true
                }else{
                    cell.economyPromoNotAvailableView.isHidden = true
                    cell.economyPromoSoldView.isHidden = true
                    cell.economyPromoPriceLbl.text = String(format: "%@ MYR", economyPromo!["total_fare"]!.string!)
                    
                    cell.economyPromoBtn.isHidden = false
                    
                    cell.economyPromoBtn.accessibilityHint = "section:\(indexPath.section) row:\(indexPath.row) index:1"
                    cell.economyPromoBtn.addTarget(self, action: #selector(CommonMHFlightDetailViewController.checkCategory(_:)), for: .touchUpInside)
                    
                }
                
                if economy!["status"]?.string == "sold out"{
                    cell.economySoldView.isHidden = false
                    cell.economyNotAvailableView.isHidden = true
                    cell.economyBtn.isHidden = true
                }else if economy!["status"]?.string == "Not Available"{
                    cell.economySoldView.isHidden = true
                    cell.economyNotAvailableView.isHidden = false
                    cell.economyBtn.isHidden = true
                }else{
                    cell.economyNotAvailableView.isHidden = true
                    cell.economySoldView.isHidden = true
                    cell.economyPriceLbl.text = String(format: "%@ MYR", economy!["total_fare"]!.string!)
                    
                    cell.economyBtn.isHidden = false
                    
                    cell.economyBtn.accessibilityHint = "section:\(indexPath.section) row:\(indexPath.row) index:2"
                    cell.economyBtn.addTarget(self, action: #selector(CommonMHFlightDetailViewController.checkCategory(_:)), for: .touchUpInside)
                }
                
                if business!["status"]?.string == "sold out"{
                    cell.businessSoldView.isHidden = false
                    cell.businessNotAvailableView.isHidden = true
                    cell.businessBtn.isHidden = true
                }else if business!["status"]?.string == "Not Available"{
                    cell.businessSoldView.isHidden = true
                    cell.businessNotAvailableView.isHidden = false
                    cell.businessBtn.isHidden = true
                }else{
                    cell.businessNotAvailableView.isHidden = true
                    cell.businessSoldView.isHidden = true
                    cell.businessPriceLbl.text = String(format: "%@ MYR", business!["total_fare"]!.string!)
                    cell.businessBtn.isHidden = false
                    
                    cell.businessBtn.accessibilityHint = "section:\(indexPath.section) row:\(indexPath.row) index:3"
                    cell.businessBtn.addTarget(self, action: #selector(CommonMHFlightDetailViewController.checkCategory(_:)), for: .touchUpInside)
                }
                
                cell.economyPromoCheckBox.strokeColor = UIColor.orange
                cell.economyPromoCheckBox.checkColor = UIColor.orange
                cell.economyCheckBox.strokeColor = UIColor.orange
                cell.businessCheckBox.strokeColor = UIColor.orange
                cell.economyCheckBox.checkColor = UIColor.orange
                cell.businessCheckBox.checkColor = UIColor.orange
                
                if indexPath.section == 1{
                    cell.flightIcon.image = UIImage(named: "arrival_icon")
                    if checkReturnIndexPath.section == 1{
                        if checkReturnIndexPath.row == indexPath.row{
                            if checkReturnIndex == "1"{
                                cell.economyPromoCheckBox.checkState = .checked
                                cell.economyCheckBox.checkState = .unchecked
                                cell.businessCheckBox.checkState = .unchecked
                            }else if checkReturnIndex == "2"{
                                cell.economyPromoCheckBox.checkState = .unchecked
                                cell.economyCheckBox.checkState = .checked
                                cell.businessCheckBox.checkState = .unchecked
                            }else if checkReturnIndex == "3"{
                                cell.economyPromoCheckBox.checkState = .unchecked
                                cell.economyCheckBox.checkState = .unchecked
                                cell.businessCheckBox.checkState = .checked
                            }
                        }else{
                            cell.economyPromoCheckBox.checkState = .unchecked
                            cell.economyCheckBox.checkState = .unchecked
                            cell.businessCheckBox.checkState = .unchecked
                        }
                    }else{
                        cell.economyPromoCheckBox.checkState = .unchecked
                        cell.economyCheckBox.checkState = .unchecked
                        cell.businessCheckBox.checkState = .unchecked
                    }
                }else{
                    cell.flightIcon.image = UIImage(named: "departure_icon")
                    if checkGoingIndexPath.section == 0{
                        if checkGoingIndexPath.row == indexPath.row{
                            if checkGoingIndex == "1"{
                                cell.economyPromoCheckBox.checkState = .checked
                                cell.economyCheckBox.checkState = .unchecked
                                cell.businessCheckBox.checkState = .unchecked
                            }else if checkGoingIndex == "2"{
                                cell.economyPromoCheckBox.checkState = .unchecked
                                cell.economyCheckBox.checkState = .checked
                                cell.businessCheckBox.checkState = .unchecked
                            }else if checkGoingIndex == "3"{
                                cell.economyPromoCheckBox.checkState = .unchecked
                                cell.economyCheckBox.checkState = .unchecked
                                cell.businessCheckBox.checkState = .checked
                            }
                        }else{
                            cell.economyPromoCheckBox.checkState = .unchecked
                            cell.economyCheckBox.checkState = .unchecked
                            cell.businessCheckBox.checkState = .unchecked
                        }
                    }else{
                        cell.economyPromoCheckBox.checkState = .unchecked
                        cell.economyCheckBox.checkState = .unchecked
                        cell.businessCheckBox.checkState = .unchecked
                    }
                }
                return cell
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let flightHeader = Bundle.main.loadNibNamed("MHFlightHeaderView", owner: self, options: nil)?[0] as! MHFlightHeaderView
        
        let flightDict = flightDetail[section].dictionary
        
        flightHeader.destinationLbl.text = String(format: "%@ - %@", (flightDict!["departure_station_name"]?.string?.uppercased())!,flightDict!["arrival_station_name"]!.string!.uppercased()) //"PENANG - SUBANG"
        flightHeader.directionLbl.text = String(format: "(%@)", flightDict!["type"]!.string!)// "(Return Flight)"
        flightHeader.dateLbl.text = String(format: "%@", flightDict!["departure_date"]!.string!) //"26 JAN 2015"
        
        flightHeader.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 88)//CGRectMake(0, 0,self.view.frame.size.width, 88)
        return flightHeader
    }
    
    func checkCategory(_ sender : UIButton){
        let index = sender.accessibilityHint?.components(separatedBy: " ")
        let section = index![0].components(separatedBy: ":")
        let row = index![1].components(separatedBy: ":")
        let indexCheck = index![2].components(separatedBy: ":")
        
        if section[1] == "0"{
            checkGoingIndex = indexCheck[1]
            checkGoingIndexPath = IndexPath(row: Int(row[1])!, section: Int(section[1])!)
        }else{
            checkReturnIndex = indexCheck[1]
            checkReturnIndexPath = IndexPath(row: Int(row[1])!, section: Int(section[1])!)
        }
        
        flightDetailTableView.reloadData()
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
