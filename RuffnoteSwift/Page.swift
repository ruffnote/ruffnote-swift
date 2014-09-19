//
//  Page.swift
//  RuffnoteSwift
//
//  Created by Tatsuya Tobioka on 2014/09/12.
//  Copyright (c) 2014年 Tatsuya Tobioka. All rights reserved.
//

import UIKit

class Page: NSObject, NSCoding {
    var title: String
    var content: String
    var note: Note
    
    init(title: String, content: String, note: Note) {
        self.title = title
        self.content = content
        self.note = note
    }
    
    required init(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObjectForKey("title") as String
        self.content = aDecoder.decodeObjectForKey("content") as String
        self.note = aDecoder.decodeObjectForKey("note") as Note
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.title, forKey: "title")
        aCoder.encodeObject(self.content, forKey: "content")
        aCoder.encodeObject(self.note, forKey: "note")
    }
}
