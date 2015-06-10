//
//  TwitterDetailViewController.swift
//  StreamTweetSwift
//
//  Created by Suman Chatterjee on 09/06/2015.
//  Copyright (c) 2015 Suman Chatterjee. All rights reserved.
//

import UIKit

class TwitterDetailViewController: UIViewController {
    
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var tweetDetailsTitle: UILabel!
    @IBOutlet weak var tweetImage: UIImageView!
    @IBOutlet weak var busyIndecator:UIActivityIndicatorView!

    var name:String = String()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        let managedObjectContext = NSManagedObjectContext(storeCoordinator: (UIApplication.sharedApplication().delegate as! AppDelegate).getStoreCoOrdinator())
        let predicate = NSPredicate(format: "name == %@", name)
        let fetchRequest = NSFetchRequest(entityName: "TweetDetails")
        fetchRequest.predicate = predicate
        
        if let tweetDetails =  managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as? [TweetDetails]{
            let tweet = tweetDetails[0] as TweetDetails?
            self.descriptionTextView.text = tweetDetails[0].tweetDescription
            self.tweetTextView.text = tweetDetails[0].tweet
            self.tweetDetailsTitle.text = NSString(format: "By %@, %@", name,tweetDetails[0].createdAt!) as String
            
            
            //Download the image
            if let imageUrl = tweetDetails[0].imageURL{
                
                self.busyIndecator.tintColor = UIColor .grayColor()
                self.busyIndecator.startAnimating()

                //Create URL
                
                //let config = NSURLSessionConfiguration.sharedSession()
                let session = NSURLSession.sharedSession()
                
                let url:NSURL = NSURL(string: imageUrl)!
                let request:NSURLRequest = NSURLRequest(URL: url)
                let downloadTask = session.downloadTaskWithRequest(request, completionHandler: { (location, responseData, error) -> Void in
                
                    if((error) == nil)
                    {
                        dispatch_async(dispatch_get_main_queue(),{
                            
                        self.tweetImage.image = UIImage(data: NSData(contentsOfURL: location)!)
                        self.busyIndecator.stopAnimating()
                        })
                    }

                })
                    
                downloadTask.resume()
                
            }
            
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
