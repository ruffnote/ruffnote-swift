//
//  NoteForm.swift
//  RuffnoteSwift
//
//  Created by Tatsuya Tobioka on 2014/09/16.
//  Copyright (c) 2014年 Tatsuya Tobioka. All rights reserved.
//

import UIKit

class NoteForm: NSObject, FXForm {
    var title: String!
    var isPrivate: Bool! = false
    
    func fields() -> [AnyObject]! {
        return ["title", "isPrivate"]
    }
    
    func titleField() -> AnyObject! {
        return ["type" : "text"]
    }
    
    func isPrivateField() -> AnyObject! {
        return [
            "type" : "boolean",
            "action" : "isPrivateDidTap:"
        ]
    }
    
    func extraFields() -> [AnyObject]! {
        return [
            [
                "title" : NSLocalizedString("Submit", comment: ""),
                "header" : "",
                "action" : "submitDidTap"
            ]
        ]
    }
}
