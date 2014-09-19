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
    
    var queueItem: UIBarButtonItem!
    
    let iconSize: CGFloat = 20.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()

        // Left
        let barsIcon = FAKFontAwesome.barsIconWithSize(self.iconSize)
        let barsImage = barsIcon.imageWithSize(CGSize(width: self.iconSize, height: self.iconSize))
        let menuItem = UIBarButtonItem(image: barsImage, style: .Plain, target: self, action: "menuItemDidTap:")
        self.navigationItem.leftBarButtonItem = menuItem

        // Right
        let checkIcon = FAKFontAwesome.checkIconWithSize(self.iconSize)
        let checkImage = checkIcon.imageWithSize(CGSize(width: self.iconSize, height: self.iconSize))
        let saveItem = UIBarButtonItem(image: checkImage, style: .Plain, target: self, action: "saveItemDidTap:")
        //self.navigationItem.rightBarButtonItem = saveItem
        
        self.queueItem = UIBarButtonItem(title: "\(PageQueue.defaultQueue.count)", style: .Plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItems = [saveItem, self.queueItem]
        
        // Title
        self.titleButton = UIButton.buttonWithType(.System) as UIButton
        self.titleButton?.addTarget(self, action: "titleButtonDidTap:", forControlEvents: .TouchUpInside)
        self.navigationItem.titleView = titleButton
        
        // TextView
        self.textView = UITextView(frame: self.view.bounds)
        self.view.addSubview(self.textView)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "handleKeyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "handleKeyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: "handlePageQueueDidUpdateNotification:", name: PageQueueDidUpdateNotification, object: nil)
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
        
        PageQueue.defaultQueue.synchronize()
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

        var lines = self.textView.text.componentsSeparatedByString("\n")
        let title = lines.removeAtIndex(0).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())

        let note = AppConfiguration.sharedConfiguration.currentNote()!
        let joiner = note.format == "html" ? "<br>" : "\n"
        let content = joiner.join(lines).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())

        let page = Page(title: title, content: content, note: note)
        PageQueue.defaultQueue.add(page)
        self.textView.text = ""
        PageQueue.defaultQueue.synchronize()
    }
    
    func menuItemDidTap(sender: AnyObject) {
        let alertController = UIAlertController(
            title: NSLocalizedString("Menu", comment: ""),
            message: nil,
            preferredStyle: .ActionSheet)
        alertController.addAction(UIAlertAction(
            title: NSLocalizedString("Settings", comment: ""),
            style: .Default,
            handler: { action in
                let settingsContrller = SettingsViewController()
                let navController = UINavigationController(rootViewController: settingsContrller)
                self.presentViewController(navController, animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(
            title: NSLocalizedString("Clear", comment: ""),
            style: .Default,
            handler: { action in
                self.textView.text = ""
        }))
        alertController.addAction(UIAlertAction(
            title: NSLocalizedString("Cancel", comment: ""),
            style: .Cancel,
            handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
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
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: view.window)
        
        let height = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(keyboardViewEndFrame)
        
        UIView.animateWithDuration(animationDuration, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
                self.textView.frame.size.height = height
            }, completion: nil)

        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
    
    // MARK: PageQueue
    
    func handlePageQueueDidUpdateNotification(notification: NSNotification) {
        self.queueItem.title = "\(PageQueue.defaultQueue.count)"
    }
}
