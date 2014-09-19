//
//  PageQueue.swift
//  RuffnoteSwift
//
//  Created by Tatsuya Tobioka on 2014/09/19.
//  Copyright (c) 2014年 Tatsuya Tobioka. All rights reserved.
//

import Foundation

let PageQueueDidUpdateNotification = "PageQueueDidUpdateNotification"

public class PageQueue: NSObject {
    
    let serializeKey = "PageQueue.serializeKey"
    
    var pages = NSMutableArray()
    var synchronizing = false
    var count: Int {
        return self.pages.count
    }
    
    public class var defaultQueue: PageQueue {
        struct Singleton {
            static let defaultQueue = PageQueue()
        }
        
        return Singleton.defaultQueue
    }
    
    override init() {
        if let data = NSUserDefaults.standardUserDefaults().dataForKey(self.serializeKey) {
            if let pages = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? NSMutableArray {
                self.pages = pages
            }
        }
    }

    func add(page: Page) {
        self.pages.addObject(page)
        self.update()
    }
    
    func synchronize() {
        if (self.synchronizing) {
            return
        }
        self.synchronizing = true
        
        if let page = self.pages.firstObject as? Page {
            RuffnoteAPIClient.sharedClient.createPage(
                accessToken: AppConfiguration.sharedConfiguration.currentUser().accessToken,
                page: page,
                success: {
                    self.pages.removeObject(page)
                    self.synchronizing = false
                    
                    self.update()
            
                    self.synchronize()
                },
                failure: { (message: String) in
                    self.synchronizing = false
                    self.synchronize()
                }
            )
        } else {
            self.synchronizing = false
        }
    }
    
    func update() {
        NSNotificationCenter.defaultCenter().postNotificationName(PageQueueDidUpdateNotification, object: nil)
        let data = NSKeyedArchiver.archivedDataWithRootObject(self.pages)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: self.serializeKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}
