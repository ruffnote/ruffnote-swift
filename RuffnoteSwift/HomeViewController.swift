//
//  HomeViewController.swift
//  RuffnoteSwift
//
//  Created by Tatsuya Tobioka on 2014/09/04.
//  Copyright (c) 2014年 Tatsuya Tobioka. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var titleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let textView = UITextView(frame: self.view.bounds)
        self.view.addSubview(textView)
    
        self.titleButton = UIButton.buttonWithType(.System) as UIButton
        self.titleButton?.addTarget(self, action: "titleButtonDidTap:", forControlEvents: .TouchUpInside)
        self.navigationItem.titleView = titleButton

        AppConfiguration.sharedConfiguration.setCurrentUser(nil)
        AppConfiguration.sharedConfiguration.setCurrentNote(nil)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if AppConfiguration.sharedConfiguration.userSignedIn() {
            self.titleButton?.setTitle(AppConfiguration.sharedConfiguration.currentNote()?.label, forState: .Normal)
        } else {
            let signInController = SignInViewController()
            let navController = UINavigationController(rootViewController: signInController)
            self.presentViewController(navController, animated: true, completion: nil)
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
