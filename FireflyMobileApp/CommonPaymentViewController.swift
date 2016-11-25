//
//  CommonPaymentViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/19/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import M13Checkbox
import XLForm
import SwiftyJSON

class CommonPaymentViewController: BaseXLFormViewController {
    
    var totalDue = Double()
    var paymentType = [AnyObject]()
    var cardType = [Dictionary<String,AnyObject>]()
    var paymentMethod = String()
    var cardInfo = [String : AnyObject]()
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var totalDueLbl: UILabel!
    @IBOutlet weak var creditCardCheckBox: M13Checkbox!
    @IBOutlet weak var maybank2uCheckBox: M13Checkbox!
    @IBOutlet weak var cimbCheckBox: M13Checkbox!
    @IBOutlet weak var fpxCheckBox: M13Checkbox!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueBtn.layer.cornerRadius = 10
        deleteBtn.layer.cornerRadius = 10
        deleteBtn.layer.borderColor = UIColor.orange.cgColor
        deleteBtn.layer.borderWidth = 1
        setupLeftButton()
        creditCardCheckBox.checkState = M13CheckboxState.checked
        
        creditCardCheckBox.strokeColor = UIColor.orange
        creditCardCheckBox.checkColor = UIColor.orange
        maybank2uCheckBox.strokeColor = UIColor.orange
        
        maybank2uCheckBox.checkColor = UIColor.orange
        cimbCheckBox.strokeColor = UIColor.orange
        cimbCheckBox.checkColor = UIColor.orange
        fpxCheckBox.strokeColor = UIColor.orange
        fpxCheckBox.checkColor = UIColor.orange
        
        paymentMethod = "Card"
        
        if cardInfo["card_type"] as! String == ""{
            
            var newFooter = footerView.frame
            newFooter.size.height = footerView.frame.size.height - 48
            footerView.frame = newFooter
            deleteBtn.isHidden = true
            
        }
        
        var newFrame = headerView.frame
        newFrame.size.height = headerView.frame.size.height - (60 * 3)
        headerView.frame = newFrame
        
        maybank2uCheckBox.isHidden = true
        cimbCheckBox.isHidden = true
        fpxCheckBox.isHidden = true
        
        rearrangePaymentType()
        initializeForm()
        
        // Do any additional setup after loading the view.
    }
    
    func rearrangePaymentType(){
        
        let xchannelPosition : CGFloat = 44
        var yonlinePosition : CGFloat = 362
        var countType1 = Int()
        var countType2 = Int()
        
        for channel in paymentType as! [Dictionary<String, AnyObject>]{
            
            let url = URL(string: (channel["channel_logo"] as! String))!
            let data = try! Data(contentsOf: url)
            
            if channel["channel_type"] as! Int == 1{
                
                let img = UIImageView(frame: CGRect(x: xchannelPosition, y: 299, width: 138, height: 62))
                img.image = UIImage(data: data)
                img.contentMode = .scaleAspectFit
                headerView.addSubview(img)
                
                //xchannelPosition = xchannelPosition + 70
                countType1 += 1
                cardType.append(channel)
                
            }else if channel["channel_type"] as! Int == 2{
                
                let img = UIImageView(frame: CGRect(x: 44, y: yonlinePosition, width: 78, height: 52))
                img.contentMode = .scaleAspectFit
                img.image = UIImage(data: data)
                headerView.addSubview(img)
                
                countType2 += 1
                yonlinePosition = yonlinePosition + 53
                
            }
        }
        
        if countType2 != 0{
            
            var newFrame = headerView.frame
            newFrame.size.height = headerView.frame.size.height + (60 * CGFloat(countType2))
            headerView.frame = newFrame
            
            for i in 0...countType2-1{
                if i == 0{
                    maybank2uCheckBox.isHidden = false
                }else if i == 1{
                    cimbCheckBox.isHidden = false
                }else{
                    fpxCheckBox.isHidden = false
                }
            }
        }
        
    }
    
    
    @IBAction func checkBtn(_ sender: AnyObject) {
        
        let btn = sender as! UIButton
        
        if btn.tag == 1{
            creditCardCheckBox.checkState = M13CheckboxState.checked
            maybank2uCheckBox.checkState = M13CheckboxState.unchecked
            cimbCheckBox.checkState = M13CheckboxState.unchecked
            fpxCheckBox.checkState = M13CheckboxState.unchecked
            self.form.formRow(withTag: Tags.HideSection)?.value = "notHide"
            if cardInfo["card_type"] as! String != ""{
                
                var newFooter = footerView.frame
                newFooter.size.height = footerView.frame.size.height + 48
                footerView.frame = newFooter
                deleteBtn.isHidden = false
                
            }
            tableView.reloadData()
            paymentMethod = "Card"
        }else if btn.tag == 2{
            creditCardCheckBox.checkState = M13CheckboxState.unchecked
            maybank2uCheckBox.checkState = M13CheckboxState.checked
            cimbCheckBox.checkState = M13CheckboxState.unchecked
            fpxCheckBox.checkState = M13CheckboxState.unchecked
            self.form.formRow(withTag: Tags.HideSection)?.value = "hide"
            if cardInfo["card_type"] as! String != ""{
                
                var newFooter = footerView.frame
                newFooter.size.height = footerView.frame.size.height - 48
                footerView.frame = newFooter
                deleteBtn.isHidden = true
                
            }
            tableView.reloadData()
            paymentMethod = "MU"
        }else if btn.tag == 3{
            creditCardCheckBox.checkState = M13CheckboxState.unchecked
            maybank2uCheckBox.checkState = M13CheckboxState.unchecked
            cimbCheckBox.checkState = M13CheckboxState.checked
            fpxCheckBox.checkState = M13CheckboxState.unchecked
            self.form.formRow(withTag: Tags.HideSection)?.value = "hide"
            if cardInfo["card_type"] as! String != ""{
                
                var newFooter = footerView.frame
                newFooter.size.height = footerView.frame.size.height - 48
                footerView.frame = newFooter
                deleteBtn.isHidden = true
                
            }
            tableView.reloadData()
            paymentMethod = "CI"
        }else{
            creditCardCheckBox.checkState = M13CheckboxState.unchecked
            maybank2uCheckBox.checkState = M13CheckboxState.unchecked
            cimbCheckBox.checkState = M13CheckboxState.unchecked
            fpxCheckBox.checkState = M13CheckboxState.checked
            self.form.formRow(withTag: Tags.HideSection)?.value = "hide"
            if cardInfo["card_type"] as! String != ""{
                
                var newFooter = footerView.frame
                newFooter.size.height = footerView.frame.size.height - 48
                footerView.frame = newFooter
                deleteBtn.isHidden = true
                
            }
            tableView.reloadData()
            paymentMethod = "PX"
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeForm() {
        
        let form : XLFormDescriptor
        let section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "")
        section = XLFormSectionDescriptor()
        section.hidden = "$\(Tags.HideSection).value contains 'hide'"
        form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: Tags.HideSection, rowType: XLFormRowDescriptorTypeText, title:"")
        row.hidden = true
        row.value = "notHide"
        section.addFormRow(row)
        
        // Title
        row = XLFormRowDescriptor(tag: Tags.ValidationCardType, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Card Type:*")
        
        var tempArray = [AnyObject]()
        for cType in cardType{
            tempArray.append(XLFormOptionsObject(value: cType["channel_code"] as! String, displayText: cType["channel_name"] as! String))
            
            if cType["channel_code"] as! String == cardInfo["card_type"]! as! String{
                row.value = cType["channel_name"] as! String
            }
        }
        
        row.selectorOptions = tempArray
        row.isRequired = true
        if cardInfo["card_type"]! as! String != ""{
            row.disabled = NSNumber(value: true)
        }
        section.addFormRow(row)
        
        //card number
        row = XLFormRowDescriptor(tag: Tags.ValidationCardNumber, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Card Number:*")
        row.value = cardInfo["card_number"]! as! String
        row.isRequired = true
        if cardInfo["card_number"]! as! String != ""{
            row.disabled = NSNumber(value: true)
        }
        section.addFormRow(row)
        
        // Title
        row = XLFormRowDescriptor(tag: Tags.ValidationCardExpiredDate, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Expiration Date:*")
        
        if cardInfo["expiration_date_month"]! as! String != ""{
            row.value = "\(cardInfo["expiration_date_month"]! as! String)/\(cardInfo["expiration_date_year"]! as! String)"
            row.disabled = NSNumber(value: true)
        }
        row.isRequired = true
        section.addFormRow(row)
        
        //holder name
        row = XLFormRowDescriptor(tag: Tags.ValidationHolderName, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Card Holder Name:*")
        //row.addValidator(XLFormRegexValidator(msg: "Card holder name is invalid.", andRegexString: "^[a-zA-Z ]{0,}$"))
        row.value = cardInfo["card_holder_name"]! as! String
        row.isRequired = true
        if cardInfo["card_holder_name"]! as! String != ""{
            row.disabled = NSNumber(value: true)
        }
        section.addFormRow(row)
        
        //CVV/CVC Number
        row = XLFormRowDescriptor(tag: Tags.ValidationCcvNumber, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"CVV/CVC Number:*")
        row.isRequired = true
        section.addFormRow(row)
        
        if try! LoginManager.sharedInstance.isLogin(){
            // Save family and friend
            
            var isSelect = Bool()
            
            if cardInfo["account_number_id"] as! String != ""{
                isSelect = true
            }else{
                isSelect = false
            }
            
            row = XLFormRowDescriptor(tag: Tags.SaveFamilyAndFriend, rowType: XLFormRowDescriptorCheckbox, title:"Add this credit card to your account for faster booking.")
            row.value =  [
                CustomCheckBoxCell.kSave.status.description(): isSelect
            ]
            section.addFormRow(row)
        }
        
        self.form = form
    }
    
    func getCardTypeCode(_ cardName:String, cardArr:[Dictionary<String,AnyObject>])->String{
        var cardCode = String()
        for cardData in cardArr{
            if cardData["channel_name"] as! String == cardName{
                cardCode = (cardData["channel_code"] as! String)
            }
        }
        return cardCode
    }
    
    func checkDate(_ date:String) -> Bool{
        
        let currentDate = date.components(separatedBy: "/")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        let monthString = formatter.string(from: Date())
        formatter.dateFormat = "yyyy"
        let yearString = formatter.string(from: Date())
        
        
        if currentDate[1] == yearString{
            if Int(currentDate[0])! <= Int(monthString)!{
                return false
            }
        }
        
        return true
        
    }
    
    func luhnCheck(_ number: String) -> Bool {
        var sum = 0
        let reversedCharacters = number.characters.reversed().map { String($0) }
        for (idx, element) in reversedCharacters.enumerated() {
            guard let digit = Int(element) else { return false }
            switch ((idx % 2 == 1), digit) {
            case (true, 9): sum += 9
            case (true, 0...8): sum += (digit * 2) % 9
            default: sum += digit
            }
        }
        return sum % 10 == 0
    }
    
    @IBAction func deleteBtnPressed(_ sender: AnyObject) {
    
        let personID = defaults.object(forKey: "personID") as! String
        let signature = defaults.object(forKey: "signature") as! String
        
        showLoading()
    
        FireFlyProvider.request(.RemoveCreditCard(personID, signature)) { (result) in
            
            switch result {
            case .success(let successResult):
                do {
                    let json = try JSON(JSONSerialization.jsonObject(with: successResult.data, options: .mutableContainers))
                    
                    if json["status"] == "success"{
                        showToastMessage(json["message"].string!)
                        self.cardInfo = ["card_type" : "" as AnyObject,
                                        "account_number_id" : "" as AnyObject,
                                        "card_holder_name" : "" as AnyObject,
                                        "expiration_date_month" : "" as AnyObject,
                                        "card_number" : "" as AnyObject,
                                        "expiration_date_year" : "" as AnyObject]
                        self.tableView.reloadData()
                        var newFooter = self.footerView.frame
                        newFooter.size.height = self.footerView.frame.size.height - 48
                        self.footerView.frame = newFooter
                        self.deleteBtn.isHidden = true
                        self.initializeForm()
                    }else if json["status"] == "error"{
                        showErrorMessage(json["message"].string!)
                    }else if json["status"].string == "401"{
                        hideLoading()
                        showErrorMessage(json["message"].string!)
                        InitialLoadManager.sharedInstance.load()
                        
                        for views in (self.navigationController?.viewControllers)!{
                            if views.classForCoder == HomeViewController.classForCoder(){
                                _ = self.navigationController?.popToViewController(views, animated: true)
                                AnalyticsManager.sharedInstance.logScreen(GAConstants.homeScreen)
                            }
                        }
                    }
                    hideLoading()
                }
                catch {
                    
                }
                
            case .failure(let failureResult):
                
                hideLoading()
                showErrorMessage(failureResult.localizedDescription)
            }
            
        }
        
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
