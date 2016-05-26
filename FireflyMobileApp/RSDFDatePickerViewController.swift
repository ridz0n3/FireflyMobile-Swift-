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
    var calendar = NSCalendar.currentCalendar()
    var today = NSDate()
    var dateFormatter = NSDateFormatter()
    var selectedDate = String()
    let calendarUnit: NSCalendarUnit = [.Year, .Month, .Day]
    var typeDate = String()
    var currentDate = NSDate()
    var selectDate = NSDate()
    var isDepart = Bool()
    var dateSelected = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let todayComponent = self.calendar.components(calendarUnit, fromDate: currentDate)
        today = self.calendar.dateFromComponents(todayComponent)!
        
        self.view.backgroundColor = UIColor.whiteColor()// [UIColor colorWithWhite:0.8 alpha:0.3];
        
        if isDepart{
            customDatePickerView = RSDFCustomDatePickerView(frame: self.view.bounds, calendar: calendar)
        }else{
            customDatePickerView = RSDFCustomDatePickerView(frame: self.view.bounds, calendar: calendar, startDate: currentDate, endDate: nil)
        }
        
        calendar.locale = NSLocale.currentLocale()
        customDatePickerView.selectDate(dateSelected)
        customDatePickerView.delegate = self
        customDatePickerView.dataSource = self
        customDatePickerView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        customDatePickerView.pagingEnabled = true
        
        
        dateView.addSubview(customDatePickerView)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        customDatePickerView.scrollToDate(dateSelected, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func datePickerView(view: RSDFDatePickerView!, didSelectDate date: NSDate!) {
        
        //self.dismissViewControllerAnimated(true, completion: nil)
        //selectDate = date
        //selectedDate = dateFormatters().stringFromDate(date)
        
        if dateFormatters().stringFromDate(date) == ""{
            showErrorMessage("Please select Date")
        }else if date.compare(currentDate) == NSComparisonResult.OrderedAscending && typeDate == "return"{
            showErrorMessage("Please make sure that your return date is not earlier than your departure date.")
        }else{
            let pageDict: Dictionary<String,String>! = [
                "date": dateFormatters().stringFromDate(date),
            ]
            
            NSNotificationCenter.defaultCenter().postNotificationName(typeDate, object: nil, userInfo: pageDict)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    func datePickerView(view: RSDFDatePickerView!, shouldHighlightDate date: NSDate!) -> Bool {
        
        if todays().compare(date) == NSComparisonResult.OrderedDescending{
            return false
        }
        
        return true
    }
    
    func datePickerView(view: RSDFDatePickerView!, shouldSelectDate date: NSDate!) -> Bool {
        
        if todays().compare(date) == NSComparisonResult.OrderedDescending{
            return false
        }
        
        return true
    }
    
    func todays() -> NSDate{
        
        let todayComponent = self.calendar.components(calendarUnit, fromDate: NSDate() )
        today = self.calendar.dateFromComponents(todayComponent)!
        
        return today
    }
    
    func dateFormatters() -> NSDateFormatter{
        
        dateFormatter = NSDateFormatter()
        dateFormatter.calendar = calendar
        dateFormatter.locale = calendar.locale
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
        
    }
    
    @IBAction func closedButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func doneSelectedDate(sender: AnyObject) {
        
        let dateFormaters = NSDateFormatter()
        dateFormaters.dateFormat = "yyyy-MM-dd"
        selectedDate = dateFormaters.stringFromDate(dateSelected)
        
        if selectedDate == ""{
            showErrorMessage("Please select Date")
        }else if selectDate.compare(currentDate) == NSComparisonResult.OrderedDescending && typeDate == "return"{
            showErrorMessage("Please make sure that your return date is not earlier than your departure date.")
        }else{
            let pageDict: Dictionary<String,String>! = [
                "date": selectedDate,
            ]
            
            NSNotificationCenter.defaultCenter().postNotificationName(typeDate, object: nil, userInfo: pageDict)
            self.dismissViewControllerAnimated(true, completion: nil)
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
