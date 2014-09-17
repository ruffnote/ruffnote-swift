//
//  HomeViewController.swift
//  RuffnoteSwift
//
//  Created by Tatsuya Tobioka on 2014/09/04.
//  Copyright (c) 2014年 Tatsuya Tobioka. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var textView: UITextView!
    var titleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let saveItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveItemDidTap:")
        self.navigationItem.rightBarButtonItem = saveItem

        let settingsItem = UIBarButtonItem(title: NSLocalizedString("Settings", comment: ""), style: .Plain, target: self, action: "settingsItemDidTap:")
        self.navigationItem.leftBarButtonItem = settingsItem
        
        self.textView = UITextView(frame: self.view.bounds)
        self.view.addSubview(self.textView)
    
        self.titleButton = UIButton.buttonWithType(.System) as UIButton
        self.titleButton?.addTarget(self, action: "titleButtonDidTap:", forControlEvents: .TouchUpInside)
        self.navigationItem.titleView = titleButton
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "handleKeyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "handleKeyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if AppConfiguration.sharedConfiguration.userSignedIn() {
            self.titleButton?.setTitle(AppConfiguration.sharedConfiguration.currentNote()?.label, forState: .Normal)
        } else {
            let signInController = SignInViewController()
            let navController = UINavigationController(rootViewController: signInController)
            self.presentViewController(navController, animated: true, completion: nil)
        }
        
        self.textView.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func titleButtonDidTap(sender: AnyObject) {
        let selectContrller = SelectNoteViewController()
        let navController = UINavigationController(rootViewController: selectContrller)
        self.presentViewController(navController, animated: true, completion: nil)
    }
    
    func saveItemDidTap(sender: AnyObject) {
        if self.textView.text.isEmpty {
            return
        }

        SVProgressHUD.show()

        var lines = self.textView.text.componentsSeparatedByString("\n")
        let title = lines.removeAtIndex(0).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())

        let note = AppConfiguration.sharedConfiguration.currentNote()!
        let joiner = note.format == "html" ? "<br>" : "\n"
        let content = joiner.join(lines).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())

        let page = Page(title: title, content: content, note: note)
        RuffnoteAPIClient.sharedClient.createPage(
            accessToken: AppConfiguration.sharedConfiguration.currentUser().accessToken,
            page: page,
            success: {
                self.textView.text = ""
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
    
    func settingsItemDidTap(sender: AnyObject) {
        let settingsContrller = SettingsViewController()
        let navController = UINavigationController(rootViewController: settingsContrller)
        self.presentViewController(navController, animated: true, completion: nil)
    }

    // MARK: Keyboard
    
    func handleKeyboardWillShowNotification(notification: NSNotification) {
        keyboardWillChangeFrameWithNotification(notification, showsKeyboard: true)
    }
    
    func handleKeyboardWillHideNotification(notification: NSNotification) {
        keyboardWillChangeFrameWithNotification(notification, showsKeyboard: false)
        
    }
    
    func keyboardWillChangeFrameWithNotification(notification: NSNotification, showsKeyboard: Bool) {
        let userInfo = notification.userInfo!
        
        let animationDuration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as NSNumber).doubleValue
        
        let keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as NSValue).CGRectValue()
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        let keyboardViewBeginFrame = view.convertRect(keyboardScreenBeginFrame, fromView: view.window)
        let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: view.window)
        
        let originDelta = keyboardViewEndFrame.origin.y - keyboardViewBeginFrame.origin.y

        UIView.animateWithDuration(animationDuration, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
                self.textView.frame.size.height += originDelta
            }, completion: nil)

        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
}
