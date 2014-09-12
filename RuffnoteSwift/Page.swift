//
//  Page.swift
//  RuffnoteSwift
//
//  Created by Tatsuya Tobioka on 2014/09/12.
//  Copyright (c) 2014年 Tatsuya Tobioka. All rights reserved.
//

import UIKit

class Page: NSObject {
    var title: String
    var content: String
    var note: Note
    
    init(title: String, content: String, note: Note) {
        self.title = title
        self.content = content
        self.note = note
    }
}
