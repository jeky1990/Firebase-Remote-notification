//
//  NotificationService.swift
//  ServiceExtension
//
//  Created by macbook on 10/30/18.
//  Copyright © 2018 macbook. All rights reserved.
//

import UserNotifications


class NotificationService: UNNotificationServiceExtension {

    var contentHandler : ((UNNotificationContent) -> Void)?
    var content : UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        
        
        self.contentHandler = contentHandler
        self.content = request.content.mutableCopy() as? UNMutableNotificationContent
        
        if let bca = self.content
        {
            func Save(_identifire: String, data: Data, option : [AnyKeyPath:Any]) -> UNNotificationAttachment?
            {
                let directory = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(ProcessInfo.processInfo.globallyUniqueString, isDirectory: true)
                
                do
                {
                    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
                    let fileURL = directory.appendingPathComponent(_identifire)
                    try data.write(to: fileURL)
                    return try UNNotificationAttachment.init(identifier: _identifire, url: fileURL, options: option)
                    
                }catch{
                    
                }
                return nil
            }
            
            func ExitGracefully(_reason:String = "")
            {
                let bca = request.content.mutableCopy() as? UNMutableNotificationContent
                bca?.title =  _reason
                
                contentHandler(bca!)
            }
            
            DispatchQueue.main.async {
                
                guard (request.content.mutableCopy() as? UNMutableNotificationContent) != nil
                else
                {
                    return ExitGracefully()
                }
                
                let UserInfo : [AnyHashable:Any] = request.content.userInfo
                
                guard let attachmentURL = UserInfo["media-url"] as? String
                else
                {
                    return ExitGracefully()
                }
                
                guard let imagedata = try? Data(contentsOf: URL(string: attachmentURL)!)
                else
                {
                    return ExitGracefully()
                }
                
                guard let attachment = Save(_identifire: "imgage.png", data: imagedata, option: [:])
                else
                {
                    return ExitGracefully()
                }
                
                self.content?.attachments = [attachment]
                contentHandler(self.content?.copy() as! UNMutableNotificationContent)
            }
        }
    
    }
    
    override func serviceExtensionTimeWillExpire()
    {
        if let contenthandler = contentHandler , let bca = self.content
        {
            contenthandler(bca)
        }
    }

}
