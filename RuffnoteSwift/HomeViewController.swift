//
//  HomeViewController.swift
//  RuffnoteSwift
//
//  Created by Tatsuya Tobioka on 2014/09/04.
//  Copyright (c) 2014年 Tatsuya Tobioka. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let textView = UITextView(frame: self.view.bounds)
        self.view.addSubview(textView)

        AppConfiguration.sharedConfiguration.setCurrentUser(nil)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if AppConfiguration.sharedConfiguration.userSignedIn() {
            SVProgressHUD.show()
            /*
            RuffnoteAPIClient.sharedClient.me(
                accessToken: AppConfiguration.sharedConfiguration.currentUser().accessToken,
                success: { (response: [String : AnyObject]) in
                    println(response)
                    SVProgressHUD.dismiss()
                },
                failure: { (message: String) in
                    println(message)
                    SVProgressHUD.dismiss()
            })
            */
            RuffnoteAPIClient.sharedClient.notes(
                accessToken: AppConfiguration.sharedConfiguration.currentUser().accessToken,
                success: { (notes: [Note]) in
                    println(notes.map { (n) in n.label })
                    SVProgressHUD.dismiss()
                },
                failure: { (message: String) in
                    println(message)
                    SVProgressHUD.dismiss()
            })
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
