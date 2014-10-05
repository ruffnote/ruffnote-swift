//
//  AppConfiguration.swift
//  RuffnoteSwift
//
//  Created by Tatsuya Tobioka on 2014/09/09.
//  Copyright (c) 2014年 Tatsuya Tobioka. All rights reserved.
//

import Foundation

public class AppConfiguration: NSObject {
    private struct Defaults {
        static let currentUserKey = "AppConfiguration.Defaults.currentUserKey"
        static let currentNoteKey = "AppConfiguration.Defaults.currentNoteKey"
        static let currentIssueKey = "AppConfiguration.Defaults.currentIssueKey"
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
        return currentUser() != nil
    }

    func currentNote() -> Note? {
        if let data = NSUserDefaults.standardUserDefaults().dataForKey(Defaults.currentNoteKey) {
            return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Note
        } else {
            return nil
        }
    }
    
    func setCurrentNote(currentNote: Note?) {
        if let note = currentNote {
            let data = NSKeyedArchiver.archivedDataWithRootObject(note)
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: Defaults.currentNoteKey)
        } else {
            NSUserDefaults.standardUserDefaults().removeObjectForKey(Defaults.currentNoteKey)
        }
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func setCurrentIssue(currentIssue: Issue?) {
        if let issue = currentIssue {
            let data = NSKeyedArchiver.archivedDataWithRootObject(issue)
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: Defaults.currentIssueKey)
        } else {
            NSUserDefaults.standardUserDefaults().removeObjectForKey(Defaults.currentIssueKey)
        }
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}
