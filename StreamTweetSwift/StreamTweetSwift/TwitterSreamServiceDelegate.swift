//
//  TwitterSreamServiceDelegate.swift
//  StreamTweetSwift
//
//  Created by Suman Chatterjee on 02/06/2015.
//  Copyright (c) 2015 Suman Chatterjee. All rights reserved.
//

import Foundation

@objc protocol TwitterSreamServiceDelegate
{
    func twitterFeedAvailable(twitterData:NSDictionary)
    
    //Pure Swift dict
    //    func twitterFeedAvailable(twitterData:[String:String])

    func twitterFeedLoadFinished()
    func twitterStreamServiceError()
    optional func noTwitterAccountSetUp()
    
}
