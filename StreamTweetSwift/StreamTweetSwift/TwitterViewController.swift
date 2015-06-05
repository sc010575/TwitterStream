//
//  ViewController.swift
//  StreamTweetSwift
//
//  Created by Suman Chatterjee on 01/06/2015.
//  Copyright (c) 2015 Suman Chatterjee. All rights reserved.
//

import UIKit

class TwitterViewController:UIViewController,UITableViewDataSource,UITableViewDelegate,TwitterSreamServiceDelegate,UISearchDisplayDelegate,UISearchBarDelegate
{
    
    @IBOutlet weak var twittTableView: UITableView!
    @IBOutlet weak var busyIndecator:UIActivityIndicatorView!
    @IBOutlet weak var twittSearchBar:UISearchBar!

    var dataSource: [[String:String]] = []
    var searchActive : Bool = false
    var twitterStreamService :TwitterStreamService!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        twittTableView.delegate = self
        twittTableView.dataSource = self
         self.busyIndecator.tintColor = UIColor .grayColor()
        self.twittSearchBar.delegate = self
        self.twittSearchBar.placeholder = "Search for Tweets"
        self.twittSearchBar.tintColor = UIColor.blueColor()
        

    }
    
       
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifire = "TwitterViewCell" // NSStringFromClass(TwitterViewCell.self).componentsSeparatedByString(".").last!
        
        
        let cell  = tableView.dequeueReusableCellWithIdentifier(cellIdentifire) as! TwitterViewCell
        let twittDict = dataSource[indexPath.row] as [String : String]
        
        let twittText = twittDict["text"]! as String
        let name = twittDict["name"]! as String
        
        
        cell.configureCellWithText(twittText, name: name)
        return cell
    }
    
    // MARK: UISearchBarDelegate
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        self.setupTwitterServiceWithText(searchBar.text)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        self.setupTwitterServiceWithText(searchBar.text)
        
    }
    
    func setupTwitterServiceWithText(textSearch: String)
    {
        if (self.twitterStreamService != nil)
        {
            twitterStreamService = nil
        }
        
        twitterStreamService  = TwitterStreamService(text:textSearch , numberOfRecords: 10, delegate: self)
        self.busyIndecator.startAnimating()
    }
    
    
    // MARK: TwitterSreamServiceDelegate
    
    func twitterFeedAvailable(twitterData:NSDictionary) {
        println("Here is a feedAvailable")
        self.dataSource.append(twitterData as! [String : String])
        if self.dataSource.count != 0
        {
            dispatch_async(dispatch_get_main_queue(), {
                self.twittTableView.reloadData()
            })
        }
        
    }
    
    func twitterFeedLoadFinished() {
        println("Here is a Finished")
        self.busyIndecator.stopAnimating()
        
        
    }
    func twitterStreamServiceError() {
        println("Here is a Protocal")
        self.busyIndecator.stopAnimating()
        
    }
    
    func noTwitterAccountSetUp(){
        println("Here is a Protocal")
        
        
        dispatch_async(dispatch_get_main_queue(), {
            self.busyIndecator.stopAnimating()
            
            let alert = UIAlertController(title: "Twitter", message: "Please ge to the settings and set up a Twitter account", preferredStyle: .Alert)
            // Create the action.
            let cancelAction = UIAlertAction(title: "Ok", style: .Cancel) { action in
                NSLog("The simple alert's cancel action occured.")
            }
            
            // Add the action.
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
        })
    }
}

