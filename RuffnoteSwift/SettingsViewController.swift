//
//  SettingsViewController.swift
//  RuffnoteSwift
//
//  Created by Tatsuya Tobioka on 2014/09/17.
//  Copyright (c) 2014年 Tatsuya Tobioka. All rights reserved.
//

import UIKit

class SettingsViewController: FXFormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = NSLocalizedString("Settings", comment: "")
        self.formController.form = SettingsForm()
        
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancelItemDidTap:")
        self.navigationItem.leftBarButtonItem = cancelItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func signOutDidTap() {
        AppConfiguration.sharedConfiguration.setCurrentUser(nil)
        AppConfiguration.sharedConfiguration.setCurrentNote(nil)
        self.close()
    }
    
    func licensesDidTap() {
        let path = NSBundle.mainBundle().pathForResource("Pods-acknowledgements", ofType: "plist")
        let acknowledgementsController = VTAcknowledgementsViewController(acknowledgementsPlistPath: path)
        self.navigationController?.pushViewController(acknowledgementsController, animated: true)
    }
    
    func cancelItemDidTap(sender: AnyObject!) {
        self.close()
    }
    
    func close() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
