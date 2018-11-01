//
//  ViewController.swift
//  FireBasedPushNotification
//
//  Created by macbook on 10/29/18.
//  Copyright © 2018 macbook. All rights reserved.
//

import UIKit
import UserNotifications

class FirstViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let content = UNMutableNotificationContent()
        content.title = "Good Afternoon"
        content.subtitle = "Have a cup of Tea"
        content.categoryIdentifier = "likecat"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "local", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    func SetCategories()
    {
        let LikeAction = UNNotificationAction(identifier: "Like", title: "Like", options: [])
        let localcat = UNNotificationCategory(identifier: "likecat", actions: [LikeAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([localcat])
    }
    
    
    
}


