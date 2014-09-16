//
//  NewNoteViewController.swift
//  RuffnoteSwift
//
//  Created by Tatsuya Tobioka on 2014/09/16.
//  Copyright (c) 2014年 Tatsuya Tobioka. All rights reserved.
//

import UIKit

class NewNoteViewController: FXFormViewController {

    override init() {
        super.init()
        
        self.title = NSLocalizedString("New note", comment: "")
        self.formController.form = NoteForm()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isPrivateDidTap(cell: FXFormFieldCellProtocol) {
        let form = self.formController.form as NoteForm;
        form.isPrivate = !form.isPrivate
    }
    
    func submitDidTap() {
        let form = self.formController.form as NoteForm;
        
        if form.title != nil {
            println("\(form.title) \(form.isPrivate)")
        }
    }
}
