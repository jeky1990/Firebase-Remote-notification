//
//  NotificationViewController.swift
//  UI Notification
//
//  Created by macbook on 10/30/18.
//  Copyright © 2018 macbook. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    @IBOutlet var Titlelabel: UILabel?
    @IBOutlet var Subtitlelabel : UILabel?
    
    @IBOutlet weak var eventImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
    
    func didReceive(_ notification: UNNotification)
    {
        
        bestAttemptContent = (notification.request.content.mutableCopy() as? UNMutableNotificationContent)
        
        
        if let bestAttemptContent = bestAttemptContent {
            
            Titlelabel!.text = bestAttemptContent.title
            Subtitlelabel!.text = bestAttemptContent.subtitle
            
            let content = notification.request.content
            if let attachment = content.attachments.first {
                if attachment.url.startAccessingSecurityScopedResource() {
                    eventImage.image = UIImage(contentsOfFile: attachment.url.path)
                    attachment.url.stopAccessingSecurityScopedResource()
                }
        }
        
    }

    }

}
