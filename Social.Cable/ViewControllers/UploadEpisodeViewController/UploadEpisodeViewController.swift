//
//  UploadEpisodeViewController.swift
//  Social.Cable
//
//  Created by Arun Kumar Rathore on 09/08/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import RPFloatingPlaceholders

class UploadEpisodeViewController: BaseViewController {

    @IBOutlet weak var viewCover: UIView!
    @IBOutlet weak var viewPhoto: UIView!
    @IBOutlet weak var viewEpisode: UIView!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var textFieldSeasonTitle: RPFloatingPlaceholderTextField!
    @IBOutlet weak var textFieldAirDate: RPFloatingPlaceholderTextField!
    @IBOutlet weak var textFieldSeasonDescription: RPFloatingPlaceholderTextField!
    @IBOutlet weak var textFieldEpisodeTitle: RPFloatingPlaceholderTextField!
    
    var datePicker = UIDatePicker()
    var timePicker = UIDatePicker()
    var hour:Int = 0
    var minutes:Int = 0
    var seconds:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupViewDidLoadMethod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationImage("nav_logo")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationTitleImageView.removeFromSuperview()
    }
    
    func setupViewDidLoadMethod() -> Void {
        self.setupBackBarButton()
        self.setupRightNavBarButton()
        self.view.backgroundColor = UIColor.colorWithHexString(ColorCode.appBackground.rawValue)
        self.viewPhoto.backgroundColor = UIColor.colorWithHexString(ColorCode.navigationBar.rawValue)
        self.viewEpisode.backgroundColor = UIColor.colorWithHexString(ColorCode.navigationBar.rawValue)
        self.viewCover.backgroundColor = UIColor.colorWithHexString(ColorCode.navigationBar.rawValue)
        self.buttonSubmit.backgroundColor = UIColor.colorWithHexString(ColorCode.buttonBackground.rawValue)
        self.buttonSubmit.layer.cornerRadius = self.buttonSubmit.bounds.height / 2
        self.showDatePicker()
        self.setupTextFieldAttribute(self.textFieldSeasonTitle, "Season Title")
        self.setupTextFieldAttribute(self.textFieldSeasonDescription, "Season Description")
        self.setupTextFieldAttribute(self.textFieldEpisodeTitle, "Episode Title")
        self.setupTextFieldAttribute(self.textFieldAirDate, "Air Date")
    }
    
//    Show date picker
    func showDatePicker() {
        //Formate Date
        self.datePicker.datePickerMode = .date
        self.datePicker.maximumDate = Date()
        
//        ToolBar done button & cancel button
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(selectDate(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: ConstantStrings.CANCEL_STRING, style: UIBarButtonItem.Style.done, target: self, action: #selector(removeDatePicker(_:)))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        self.textFieldAirDate.inputAccessoryView = toolbar
        // add datepicker to textField
        self.textFieldAirDate.inputView = self.datePicker
        
    }
    
    @objc func selectDate(_ sender : Any){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, yyyy"
        self.textFieldAirDate.text = formatter.string(from: self.datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    @objc func removeDatePicker(_ sender : Any){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    func showTimePicker() {
        //Formate Date
        self.timePicker.datePickerMode = .time
        self.timePicker.minimumDate = Date()
        
//        ToolBar done button & cancel button
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(selectTime(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: ConstantStrings.CANCEL_STRING, style: UIBarButtonItem.Style.done, target: self, action: #selector(removeTimePicker(_:)))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        self.textFieldAirDate.inputAccessoryView = toolbar
        // add datepicker to textField
        self.textFieldAirDate.inputView = self.timePicker
        
    }
    
    @objc func selectTime(_ sender : Any){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        self.textFieldAirDate.text = formatter.string(from: self.timePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    @objc func removeTimePicker(_ sender : Any){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
//    MARK:- Button Action
    @IBAction func buttonEditAction(_ sender: UIButton) {
        if sender.tag == 1 {
            self.textFieldSeasonTitle.becomeFirstResponder()
        }else if sender.tag == 2 {
            self.textFieldSeasonDescription.becomeFirstResponder()
        }else if sender.tag == 3 {
            self.textFieldEpisodeTitle.becomeFirstResponder()
        }else if sender.tag == 4 {
            self.textFieldAirDate.becomeFirstResponder()
        }
    }
    
    @IBAction func buttonSubmitEpisodeAction(_ sender: UIButton) {
        
    }
    
}
