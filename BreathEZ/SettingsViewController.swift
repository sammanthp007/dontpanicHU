//
//  SettingsViewController.swift
//  BreathEZ
//
//  Created by Tunscopi on 3/25/17.
//  Copyright © 2017 dontpanicHU. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
  
  @IBOutlet weak var phoneNoField: UITextField!
  @IBOutlet weak var phoneNoInfoLabel: UILabel!
  
  var settingsDefaults = UserDefaults.standard
  
  
  override func viewWillAppear(_ animated: Bool) {
    if let phoneNo = settingsDefaults.value(forKey: "phoneNo") as? String {
      self.phoneNoField.text = phoneNo
      self.phoneNoInfoLabel.isHidden = false
      self.phoneNoInfoLabel.text = "You may edit your Emergency contact below"
      
    } else {
      let color = UIColor.lightGray
      self.phoneNoField.attributedPlaceholder = NSAttributedString(string: "Please enter an emergency contact", attributes: [NSForegroundColorAttributeName: color])
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.phoneNoInfoLabel.isHidden = true
    self.phoneNoField.becomeFirstResponder()
    
    let color = UIColor.lightGray
    self.phoneNoField.attributedPlaceholder = NSAttributedString(string: "Please enter an emergency contact", attributes: [NSForegroundColorAttributeName: color])
    
  }
  
  @IBAction func onSave(_ sender: UIBarButtonItem) {
    settingsDefaults.set(phoneNoField.text, forKey: "phoneNo")
    self.performSegue(withIdentifier: "backToHomeSegue", sender: nil)
  }
  
}
