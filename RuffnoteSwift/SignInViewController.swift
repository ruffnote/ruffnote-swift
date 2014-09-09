//
//  SignInViewController.swift
//  RuffnoteSwift
//
//  Created by Tatsuya Tobioka on 2014/09/09.
//  Copyright (c) 2014年 Tatsuya Tobioka. All rights reserved.
//

import UIKit

class SignInViewController: FXFormViewController {

    override init() {
        super.init()

        self.title = NSLocalizedString("Sign in", comment: "")
        self.formController.form = SignInForm()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func signInDidTap() {
        let form = self.formController.form as SignInForm;
        println("\(form.login):\(form.password)")
    }
}
