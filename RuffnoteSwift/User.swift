//
//  User.swift
//  RuffnoteSwift
//
//  Created by Tatsuya Tobioka on 2014/09/09.
//  Copyright (c) 2014年 Tatsuya Tobioka. All rights reserved.
//

import Foundation

class User: NSCoder {
    var username: String;
    var accessToken: String;
    
    init(username: String, accessToken: String) {
        self.username = username
        self.accessToken = accessToken
    }
    
    init(coder aDecoder: NSCoder!) {
        self.username = aDecoder.decodeObjectForKey("username") as String
        self.accessToken = aDecoder.decodeObjectForKey("accessToken") as String
    }
    
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(self.username, forKey: "username")
        aCoder.encodeObject(self.accessToken, forKey: "accessToken")
    }
}
