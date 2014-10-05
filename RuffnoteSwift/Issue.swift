//
//  Issue.swift
//  RuffnoteSwift
//
//  Created by nishiko on 2014/10/01.
//  Copyright (c) 2014年 Tatsuya Tobioka. All rights reserved.
//

import UIKit

class Issue: NSObject, NSCoding {
    var title: String
    //var description: String
    var isDone: Bool
    //var note: Note
    
    /*
    var label: String {
        return "\(note.name) - \(title)"
    }
    */
    
    var label: String {
        return "\(title)"
    }
    
    /*
    var path: String {
        return "\(note.team.name)/\(note.name)/\(name)"
    }
    */
    
    init(attributes: NSDictionary) {
        self.title = attributes["title"] as String
        //self.description = attributes["description"] as String
        self.isDone = attributes["is_done"] as Bool
        //self.note = Note(name: attributes["note"]!["name"] as String)
    }
    
    required init(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObjectForKey("title") as String
        //self.description = aDecoder.decodeObjectForKey("description") as String
        self.isDone = aDecoder.decodeBoolForKey("isDone") as Bool
        //self.note = aDecoder.decodeObjectForKey("note") as Team
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.title, forKey: "title")
        //aCoder.encodeObject(self.name, forKey: "description")
        aCoder.encodeBool(self.isDone, forKey: "isDone")
        //aCoder.encodeObject(self.note, forKey: "note")
    }
}