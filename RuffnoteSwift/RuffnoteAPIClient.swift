//
//  RuffnoteAPIClient.swift
//  RuffnoteSwift
//
//  Created by Tatsuya Tobioka on 2014/09/10.
//  Copyright (c) 2014年 Tatsuya Tobioka. All rights reserved.
//

import Foundation
import Accounts

public class RuffnoteAPIClient: NSObject {
    
    let site = "https://ruffnote.com"
    let version = "/api/v1"

    public class var sharedClient: RuffnoteAPIClient {
        struct Singleton {
            static let sharedClient = RuffnoteAPIClient()
        }
        
        return Singleton.sharedClient
    }

    func signIn(#login: String, password: String, success: String -> (), failure: String -> ()) {
        let manager = AFHTTPRequestOperationManager()
        var params = [
            "grant_type" : "password",
            "login" : login,
            "password" : password,
            "client_id" : AppSecret.OAuth.clientId,
            "client_secret" : AppSecret.OAuth.clientSecret
        ]
        
        manager.POST(
            "\(site)/oauth/token",
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                let response = responseObject as [String : AnyObject]
                let accessToken = responseObject["access_token"] as String
                self.notes(
                    accessToken: accessToken,
                    success: { (notes: [Note]) in
                        AppConfiguration.sharedConfiguration.setCurrentNote(notes.first)
                        success(accessToken)
                    },
                    failure: failure)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                failure(error.localizedDescription)
        })
    }
    
    func signInWithFacebook(#success: String -> (), failure: String -> ()) {
        
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierFacebook)
        
        let options = [
            ACFacebookAppIdKey : AppSecret.OAuth.facebookAppId,
            ACFacebookAudienceKey : ACFacebookAudienceOnlyMe,
            ACFacebookPermissionsKey : ["email"]
        ]
        
        accountStore.requestAccessToAccountsWithType(
            accountType,
            options: options) { (granted: Bool, error: NSError!) in
                dispatch_async(dispatch_get_main_queue(), {
                    if granted {
                        self.permitWithFacebook(success: success, failure: failure)
                    } else {
                        if error.code == Int(ACErrorAccountNotFound.value) {
                            failure(NSLocalizedString("Please set Facebook account on Settings app.", comment: ""));
                        } else {
                            failure(error.localizedDescription)
                        }
                    }
                })
        }
    }
    
    func permitWithFacebook(#success: String -> (), failure: String -> ()) {
        
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierFacebook)
        
        let options = [
            ACFacebookAppIdKey : AppSecret.OAuth.facebookAppId,
            ACFacebookAudienceKey : ACFacebookAudienceOnlyMe,
            ACFacebookPermissionsKey : ["email", "user_groups", "user_friends"]
        ]
        
        accountStore.requestAccessToAccountsWithType(
            accountType,
            options: options) { (granted: Bool, error: NSError!) in
                dispatch_async(dispatch_get_main_queue(), {
                    
                    if !granted {
                        failure(error.localizedDescription)
                        return
                    }
                    
                    let accounts = accountStore.accountsWithAccountType(accountType)
                    let account = accounts.last as ACAccount
                    let credential = account.credential
                    let token = credential.oauthToken
                    
                    self.verifyAccount(token: token, success: success, failure: failure)
                })
        }
    }
    
    func verifyAccount(#token: String, success: String -> (), failure: String -> ()) {
        let manager = AFHTTPRequestOperationManager()
        var params = [
            "access_token" : token,
            "access_token_secret" : "",
            "client_id" : AppSecret.OAuth.clientId,
            "provider" : "facebook"
        ]
        
        manager.POST(
            "\(site)\(version)/verify_account",
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                let response = responseObject as [String : AnyObject]
                let accessToken = responseObject["token"] as String
                self.notes(
                    accessToken: accessToken,
                    success: { (notes: [Note]) in
                        AppConfiguration.sharedConfiguration.setCurrentNote(notes.first)
                        success(accessToken)
                    },
                    failure: failure)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                failure(error.localizedDescription)
        })
    }
    
    func me(#accessToken: String, success: [String : AnyObject] -> (), failure: String -> ()) {
        let manager = authorizedManager(accessToken)
        manager.GET(
            "\(site)\(version)/me",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                success(responseObject as [String : AnyObject])
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                failure(error.localizedDescription)
        })
    }

    func notes(#accessToken: String, success: [Note] -> (), failure: String -> ()) {
        let manager = authorizedManager(accessToken)
        manager.GET(
            "\(site)\(version)/notes",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                var notes = [Note]()
                for attributes : NSDictionary in responseObject as Array {
                    notes.append(Note(attributes: attributes))
                }
                success(notes)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                failure(error.localizedDescription)
        })
    }

    func createPage(#accessToken: String, page: Page, success: () -> (), failure: String -> ()) {
        let manager = authorizedManager(accessToken)
        var params = [
            "page" : [
                "title" : page.title,
                "content" : page.content
            ]
        ]
        
        manager.POST(
            "\(site)\(version)/\(page.note.path)/pages",
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                success()
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                failure(error.localizedDescription)
        })
    }

    func createNote(#accessToken: String, note: Note, success: Note -> (), failure: String -> ()) {
        let manager = authorizedManager(accessToken)
        var params = [
            "note" : [
                "title" : note.title,
                "is_private" : note.isPrivate,
                "format" : note.format,
                "team" : note.team.name
            ]
        ]
        
        manager.POST(
            "\(site)\(version)/notes",
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                let note = Note(attributes: responseObject as NSDictionary)
                success(note)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                failure(error.localizedDescription)
        })
    }
    
    private func authorizedManager(accessToken: String) -> AFHTTPRequestOperationManager{
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return manager
    }
}
