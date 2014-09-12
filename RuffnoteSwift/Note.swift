//
//  Note.swift
//  RuffnoteSwift
//
//  Created by Tatsuya Tobioka on 2014/09/12.
//  Copyright (c) 2014年 Tatsuya Tobioka. All rights reserved.
//

import UIKit

class Note: NSObject {
    var title: String
    var name: String
    var isPrivate: Bool
    var team: Team
    var label: String {
        return "\(team.name) - \(title)"
    }
    init(attributes: NSDictionary) {
        self.title = attributes["title"] as String
        self.name = attributes["name"] as String
        self.isPrivate = attributes["is_private"] as Bool
        self.team = Team(name: attributes["team"]!["name"] as String)
    }
}
