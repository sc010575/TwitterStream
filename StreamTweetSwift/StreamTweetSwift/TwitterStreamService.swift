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
    var managedObjectContext:NSManagedObjectContext
    
    init( text:String, numberOfRecords:Int, delegate:TwitterSreamServiceDelegate)
    {
        self.delegate = delegate
        self.text = text
        self.numberOfRecords = numberOfRecords
        //Use the main persistentStoreCoordinator
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let storeCoOrdinator:NSPersistentStoreCoordinator = appDelegate.getStoreCoOrdinator()

        
        self.managedObjectContext = NSManagedObjectContext(storeCoordinator: storeCoOrdinator)
        
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
            
            println("Dictionary :\(userDict)")
            
            let imageUrl =  userDict["profile_banner_url"] as? String
            let creationDate = userDict["created_at"] as? String
            let name = userDict["name"] as! String
            let url =  userDict["url"] as? String
            let description = userDict["description"] as? String
            
            var twittDict:NSDictionary = ["text":text, "name":name]
            delegate?.twitterFeedAvailable(twittDict)
            self.counter++
            
            
            
            //Save Data
            
            self.saveTwitterRecord(self.managedObjectContext,name: name,imageUrl: imageUrl,createdOn: creationDate!,description: description,tweetURL: url)
            
            if self.counter >= self.numberOfRecords{
                delegate?.twitterFeedLoadFinished()
                connection.cancel()
                self.counter = 0
            }
        }
    }
    
        func saveTwitterRecord(context:NSManagedObjectContext, name:String, imageUrl:String?,createdOn:String, description:String?, tweetURL:String?)
        {
            self.managedObjectContext.updateOnBackgroundThread({ (updateContext:NSManagedObjectContext!) -> Void in

                var tweetdetails = NSEntityDescription.insertNewObjectForEntityForName("TweetDetails", inManagedObjectContext: updateContext) as? TweetDetails
                

                
              //  var tweetdetails = TweetDetails.createInContext(updateContext) as! TweetDetails
                
                tweetdetails?.name = name
                tweetdetails?.tweetDescription = description
                
         //       var dateFormatter = NSDateFormatter()
         //       dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
                
         //       var date = dateFormatter.dateFromString(createdOn)
                tweetdetails?.createdAt = createdOn
                tweetdetails?.twittURL = tweetURL
                tweetdetails?.imageURL = imageUrl

                }, completion: {
                    NSLog("Save Data success")
            })
            
    }

}


