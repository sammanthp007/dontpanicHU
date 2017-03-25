//
//  SettingsViewController.swift
//  BreathEZ
//
//  Created by Tunscopi on 3/25/17.
//  Copyright © 2017 dontpanicHU. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var phoneNoField: UITextField!
  @IBOutlet weak var phoneNoInfoLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  
  var settingsDefaults = UserDefaults.standard
  var isSelected: Bool = false
  var practiceData: NSDictionary? = nil
  var selectedPhone: String = ""
  
  
  override func viewWillAppear(_ animated: Bool) {
    if let phoneNo = settingsDefaults.value(forKey: "phoneNo") as? String {
      self.phoneNoField.text = phoneNo
      self.phoneNoInfoLabel.isHidden = false
      self.phoneNoInfoLabel.text = "You may edit your Emergency contact no. below"
      
    } else {
      let color = UIColor.lightGray
      self.phoneNoField.attributedPlaceholder = NSAttributedString(string: "Please enter an emergency contact no.", attributes: [NSForegroundColorAttributeName: color])
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    
    self.phoneNoInfoLabel.isHidden = true
    self.phoneNoField.becomeFirstResponder()
    
    let color = UIColor.lightGray
    self.phoneNoField.attributedPlaceholder = NSAttributedString(string: "Please enter an emergency contact", attributes: [NSForegroundColorAttributeName: color])
    
    
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
    
    // add to tableView
    tableView.insertSubview(refreshControl, at: 0)
    
    // Display HUD
    MBProgressHUD.showAdded(to: self.view, animated: true)
    
    networkRequest()
    
  }
  
  
  func networkRequest() {
    // Doctor Info Network Request
    
    
    let apiKey = "c31447938384aaa66eb7107ab84dd8fd"
    let practiceType = "psychiatrist"
    let url = URL(string: "https://api.betterdoctor.com/2016-03-01/practices?name=\(practiceType)&location=37.773%2C-122.413%2C100&user_location=37.773%2C-122.413&skip=0&limit=10&user_key=\(apiKey)")
    let request = URLRequest(url: url!)
    let session = URLSession(
      configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main
    )
    
    let task: URLSessionDataTask = session.dataTask(with: request, completionHandler: { (dataOrNil, response, error) in
      if let data = dataOrNil {
        if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
          MBProgressHUD.hide(for: self.view, animated: true)
          self.practiceData = responseDictionary
          self.tableView.reloadData()
        }
      } else {
        print ("error: \(error?.localizedDescription)")
      }
    });
    
    task.resume()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return practiceData != nil ? (practiceData?.count)! : 0
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PracticeCell", for: indexPath) as! PracticeCell
    
    // my caveman de-serialization, apologies haha
    if let practiceArr = self.practiceData!["data"] as? NSArray {
      if let singlePractice =  practiceArr[indexPath.row] as? NSDictionary {
        let distance = singlePractice["distance"] as? Double
        cell.distAway.text = String(format: "%.1f mi", distance!)
        
        if let contactInfo = singlePractice["phones"] as? NSArray {
          if let contact = contactInfo[0] as? NSDictionary{
            self.selectedPhone = (contact["number"] as? String)!
          }
        }
        
        if let practiceInfo = singlePractice["doctors"] as? NSArray {
          if let practice = practiceInfo[0] as? NSDictionary {
            if let docProfile = practice["profile"] as? NSDictionary {
              let fname = docProfile["first_name"] as! String
              let lname = docProfile["last_name"] as! String
              
              cell.practiceNameLabel.text = "Dr. \(fname) \(lname)"
              cell.descriptionLabel.text = docProfile["bio"] as? String
              
              let imageUrl = NSURL(string: docProfile["image_url"]! as! String)
              cell.practiceImageView.setImageWith(imageUrl as! URL)
              
            }
          }
          
        }
      }
    }
    
    
    return cell
  }
  
  
  // checkmark effect
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath) {
      if !isSelected {
        cell.accessoryType = .checkmark
        cell.tintColor = UIColor .blue
        self.phoneNoField.text = self.selectedPhone
        isSelected = true
      } else {
        cell.accessoryType = .none
        self.phoneNoField.text = ""
        isSelected = false
      }
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  
  func refreshControlAction (refreshControl: UIRefreshControl) {
    networkRequest()
    refreshControl.endRefreshing()
  }
  
  
  @IBAction func onSave(_ sender: UIBarButtonItem) {
    settingsDefaults.set(phoneNoField.text, forKey: "phoneNo")
    self.performSegue(withIdentifier: "backToHomeSegue", sender: nil)
  }
  
}
