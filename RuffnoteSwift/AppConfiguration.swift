//
//  AppConfiguration.swift
//  RuffnoteSwift
//
//  Created by Tatsuya Tobioka on 2014/09/09.
//  Copyright (c) 2014年 Tatsuya Tobioka. All rights reserved.
//

import UIKit

public class AppConfiguration: NSObject {
    private struct Defaults {
        static let currentUserKey = "AppConfiguration.Defaults.currentUserKey"
    }

    public class var sharedConfiguration: AppConfiguration {
    struct Singleton {
        static let sharedAppConfiguration = AppConfiguration()
        }
        
        return Singleton.sharedAppConfiguration
    }
    
    func currentUser() -> User! {
        if let data = NSUserDefaults.standardUserDefaults().dataForKey(Defaults.currentUserKey) {
            return NSKeyedUnarchiver.unarchiveObjectWithData(data) as User
        } else {
            return nil
        }
    }
    
    func setCurrentUser(currentUser: User?) {
        if let user = currentUser {
            let data = NSKeyedArchiver.archivedDataWithRootObject(user)
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: Defaults.currentUserKey)
        } else {
            NSUserDefaults.standardUserDefaults().removeObjectForKey(Defaults.currentUserKey)
        }
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func userSignedIn() -> Bool {
        //println("user \(currentUser().username)")
        return currentUser() != nil
    }
}
