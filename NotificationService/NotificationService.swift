//
//  NotificationService.swift
//  NotificationService
//
//  Created by macbook on 10/29/18.
//  Copyright © 2018 macbook. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        guard let bestAttemptContent = bestAttemptContent

            let apsData = bestAttemptContent.userInfo["aps"] as? [String: Any]
            print(apsData)
            let attachmentURLAsString = apsData["attachment"] as? String
        
            let attachmentURL = URL(string: attachmentURLAsString) else {
                return
        }

        downloadImageFrom(url: attachmentURL) { (attachment) in
            if attachment != nil {
                bestAttemptContent.attachments = [attachment!]
                contentHandler(bestAttemptContent)
            }
        }
        
//        let uRL = Bundle.main.path(forResource: "gm", ofType: "jpg")
//        let attachment = UNNotificationAttachment(identifier: "image", url: uRL!, options: nil)
//        bestAttemptContent?.attachments = [attachment]
//        contentHandler(attachment)
    }
    
    override func serviceExtensionTimeWillExpire() {
        
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}

extension NotificationService {
    
    private func downloadImageFrom(url: URL, with completionHandler: @escaping (UNNotificationAttachment?) -> Void)
    {
        let task = URLSession.shared.downloadTask(with: url) { (downloadedUrl, response, error) in
            
            guard let downloadedUrl = downloadedUrl else {
                completionHandler(nil)
                return
            }
            
            var urlPath = URL(fileURLWithPath: NSTemporaryDirectory())
            
            let uniqueURLEnding = ProcessInfo.processInfo.globallyUniqueString + ".jpg"
            urlPath = urlPath.appendingPathComponent(uniqueURLEnding)
            
            try? FileManager.default.moveItem(at: downloadedUrl, to: urlPath)
            
            do {
                let attachment = try UNNotificationAttachment(identifier: "picture", url: urlPath, options: nil)
                completionHandler(attachment)
            }
            catch {
                completionHandler(nil)
            }
        }
        task.resume()
    }
}
