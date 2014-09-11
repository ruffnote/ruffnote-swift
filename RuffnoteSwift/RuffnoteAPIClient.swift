//
//  RuffnoteAPIClient.swift
//  RuffnoteSwift
//
//  Created by Tatsuya Tobioka on 2014/09/10.
//  Copyright (c) 2014年 Tatsuya Tobioka. All rights reserved.
//

import Foundation

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
                success(responseObject["access_token"] as String)
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
    
    private func authorizedManager(accessToken: String) -> AFHTTPRequestOperationManager{
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return manager
    }
}
