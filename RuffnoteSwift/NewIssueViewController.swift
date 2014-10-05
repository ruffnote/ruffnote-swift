//
//  NewIssueViewController.swift
//  RuffnoteSwift
//
//  Created by nishiko on 2014/10/05.
//  Copyright (c) 2014年 Tatsuya Tobioka. All rights reserved.
//

/*
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
            let note = Note(attributes: [
                "title" : form.title,
                "is_private" : form.isPrivate,
                "format" : "html",
                "name" : "",
                "team" : [
                    "name" : AppConfiguration.sharedConfiguration.currentUser().username
                ]
                ])
            SVProgressHUD.show()
            RuffnoteAPIClient.sharedClient.createNote(
                accessToken: AppConfiguration.sharedConfiguration.currentUser().accessToken,
                note: note,
                success: { (note: Note) in
                    AppConfiguration.sharedConfiguration.setCurrentNote(note)
                    self.close()
                    SVProgressHUD.dismiss()
                },
                failure: { (message: String) in
                    let alertController = UIAlertController(
                        title: NSLocalizedString("Error", comment: ""),
                        message: message,
                        preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(
                        title: NSLocalizedString("OK", comment: ""),
                        style: .Default,
                        handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                    SVProgressHUD.dismiss()
            })
        }
    }
    
    func close() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}

*/