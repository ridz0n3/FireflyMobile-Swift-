//
//  RSDFDatePickerViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 12/3/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import RSDayFlow

class RSDFDatePickerViewController: BaseViewController, RSDFDatePickerViewDelegate, RSDFDatePickerViewDataSource {
    
    @IBOutlet weak var dateView: UIView!
    var customDatePickerView = RSDFCustomDatePickerView()
    var calendar = Calendar.current
    var today = Date()
    var dateFormatter = DateFormatter()
    var selectedDate = String()
    let calendarUnit: NSCalendar.Unit = [.year, .month, .day]
    var typeDate = String()
    var currentDate = Date()
    var selectDate = Date()
    var isDepart = Bool()
    var dateSelected = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let todayComponent = (self.calendar as NSCalendar).components(calendarUnit, from: currentDate)
        today = self.calendar.date(from: todayComponent)!
        
        self.view.backgroundColor = UIColor.white// [UIColor colorWithWhite:0.8 alpha:0.3];
        
        if isDepart{
            customDatePickerView = RSDFCustomDatePickerView(frame: self.view.bounds, calendar: calendar)
        }else{
            customDatePickerView = RSDFCustomDatePickerView(frame: self.view.bounds, calendar: calendar, start: currentDate, end: nil)
        }
        
        calendar.locale = NSLocale(localeIdentifier: "en_US") as Locale
        customDatePickerView.select(dateSelected)
        customDatePickerView.delegate = self
        customDatePickerView.dataSource = self
        customDatePickerView.autoresizingMask = UIViewAutoresizing.flexibleHeight
        customDatePickerView.isPagingEnabled = true
        
        
        dateView.addSubview(customDatePickerView)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        customDatePickerView.scroll(to: dateSelected, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func datePickerView(_ didSelectview: RSDFDatePickerView, didSelect date: Date) {
        
        //self.dismissViewControllerAnimated(true, completion: nil)
        //selectDate = date
        //selectedDate = dateFormatters().stringFromDate(date)
        
        if dateFormatters().string(from: date) == ""{
            showErrorMessage("Please select Date")
        }else if date.compare(currentDate) == ComparisonResult.orderedAscending && typeDate == "return"{
            showErrorMessage("Please make sure that your return date is not earlier than your departure date.")
        }else{
            let pageDict: Dictionary<String,String>! = [
                "date": dateFormatters().string(from: date),
            ]
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: typeDate), object: nil, userInfo: pageDict)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func datePickerView(_ view: RSDFDatePickerView, shouldHighlight date: Date) -> Bool {
        
        if todays().compare(date) == ComparisonResult.orderedDescending{
            return false
        }
        
        return true
    }
    
    func datePickerView(_ view: RSDFDatePickerView, shouldSelect date: Date) -> Bool {
        
        if todays().compare(date) == ComparisonResult.orderedDescending{
            return false
        }
        
        return true
    }
    
    func todays() -> Date{
        
        let todayComponent = (self.calendar as NSCalendar).components(calendarUnit, from: Date() )//self.calendar.components(calendarUnit, fromDate: NSDate() )
        today = self.calendar.date(from: todayComponent)!
        
        return today
    }
    
    func dateFormatters() -> DateFormatter{
        
        dateFormatter = DateFormatter()
        dateFormatter.calendar = calendar
        dateFormatter.locale = calendar.locale
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
        
    }
    
    @IBAction func closedButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func doneSelectedDate(_ sender: AnyObject) {
        
        let dateFormaters = DateFormatter()
        dateFormaters.dateFormat = "yyyy-MM-dd"
        selectedDate = dateFormaters.string(from: dateSelected)
        
        if selectedDate == ""{
            showErrorMessage("Please select Date")
        }else if selectDate.compare(currentDate) == ComparisonResult.orderedDescending && typeDate == "return"{
            showErrorMessage("Please make sure that your return date is not earlier than your departure date.")
        }else{
            let pageDict: Dictionary<String,String>! = [
                "date": selectedDate,
            ]
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: typeDate), object: nil, userInfo: pageDict)
            self.dismiss(animated: true, completion: nil)
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
