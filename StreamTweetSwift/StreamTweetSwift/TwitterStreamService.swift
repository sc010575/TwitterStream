//
//  TwitterStreamService.swift
//  StreamTweetSwift
//
//  Created by Suman Chatterjee on 02/06/2015.
//  Copyright (c) 2015 Suman Chatterjee. All rights reserved.
//

import UIKit
import Social
import Accounts


class TwitterStreamService: NSObject {
    
    var delegate:TwitterSreamServiceDelegate?
    var text:String
    var numberOfRecords:NSInteger
    var counter:Int = 0
    
    init( text:String, numberOfRecords:Int, delegate:TwitterSreamServiceDelegate)
    {
        self.delegate = delegate
        self.text = text
        self.numberOfRecords = numberOfRecords
        super.init()
        
        self.getTwitterStream(self.text)
        
    }
    
    func getTwitterStream(text:String)
    {
        let account = ACAccountStore()
        let accountType = account.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        let accounts = account.accountsWithAccountType(accountType)
        //        if(accounts != nil)
        //        {
        //            if accounts.count == 0
        //            {
        //                //error
        //                //  if  self.delegate!.respondsToSelector("noTwitterAccountSetUp"){
        //                delegate?.noTwitterAccountSetUp!()
        //                return
        //            }
        //        }
        account.requestAccessToAccountsWithType(accountType, options: nil) { (granted:Bool, error:NSError!) -> Void in
            if granted{
                let twitterAccounts = account.accountsWithAccountType(accountType)
                
                if (twitterAccounts != nil) {
                    if twitterAccounts.count == 0 {
                        println("There are no Twitter accounts configured. You can add or create a Twitter account in Settings.")
                        self.delegate?.noTwitterAccountSetUp!()
                        
                    }
                    else {
                        let twitterAccount = twitterAccounts[0] as! ACAccount
                        let urlPath:String = "https://stream.twitter.com/1.1/statuses/filter.json"
                        let requestURL = NSURL(string: urlPath)!
                        let param = ["track" : text]
                        let postRequest = SLRequest(forServiceType:
                            SLServiceTypeTwitter,
                            requestMethod: SLRequestMethod.POST,
                            URL: requestURL,
                            parameters: param)
                        
                        postRequest.account = twitterAccount
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            let aConnection = NSURLConnection(request: postRequest.preparedURLRequest(), delegate: self)
                            aConnection?.start()
                            
                        })
                        
                    }
                    
                }
                
            }
        }
    }
    
    
    //NSURLConnection delegate method
    func connection(connection: NSURLConnection!, didFailWithError error: NSError!) {
        println("Failed with error:\(error.localizedDescription)")
    }
    
    //NSURLConnection delegate method
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        //New request so we need to clear the data object
        // self.data = NSMutableData()
    }
    
    //NSURLConnection delegate method
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        //Append incoming data
        
        //Dubug Purpose Only
        
        let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
        println("Got Data string with :\(dataString)")
        
        var error = NSError?()
        if let object = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as? NSDictionary{
            let text = object["text"] as! String
            
            let userDict =  object["user"] as! NSDictionary
            let name = userDict["name"] as! String
            var twittDict:NSDictionary = ["text":text, "name":name]
            delegate?.twitterFeedAvailable(twittDict)
            self.counter++
            
            if self.counter >= self.numberOfRecords{
                delegate?.twitterFeedLoadFinished()
                connection.cancel()
                self.counter = 0
            }
        }
        
        
    }
    
    
}


