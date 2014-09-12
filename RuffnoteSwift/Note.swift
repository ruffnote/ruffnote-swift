//
//  Note.swift
//  RuffnoteSwift
//
//  Created by Tatsuya Tobioka on 2014/09/12.
//  Copyright (c) 2014年 Tatsuya Tobioka. All rights reserved.
//

import UIKit

class Note: NSObject, NSCoding {
    var title: String
    var name: String
    var isPrivate: Bool
    var format: String
    var team: Team
    var label: String {
        return "\(team.name) - \(title)"
    }
    var path: String {
        return "\(team.name)/\(name)"
    }
    
    init(attributes: NSDictionary) {
        self.title = attributes["title"] as String
        self.name = attributes["name"] as String
        self.isPrivate = attributes["is_private"] as Bool
        self.format = attributes["format"] as String
        self.team = Team(name: attributes["team"]!["name"] as String)
    }

    required init(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObjectForKey("title") as String
        self.name = aDecoder.decodeObjectForKey("name") as String
        self.isPrivate = aDecoder.decodeBoolForKey("isPrivate") as Bool
        self.format = aDecoder.decodeObjectForKey("format") as String
        self.team = aDecoder.decodeObjectForKey("team") as Team
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.title, forKey: "title")
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeBool(self.isPrivate, forKey: "isPrivate")
        aCoder.encodeObject(self.format, forKey: "format")
        aCoder.encodeObject(self.team, forKey: "team")
    }
}
