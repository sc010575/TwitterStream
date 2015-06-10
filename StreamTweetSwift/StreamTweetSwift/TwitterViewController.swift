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
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        twittTableView.delegate = self
        twittTableView.dataSource = self
        self.busyIndecator.tintColor = UIColor .grayColor()
        self.twittSearchBar.delegate = self
        self.twittSearchBar.placeholder = "Search for Tweets"
        self.twittSearchBar.tintColor = UIColor.blueColor()
    //    self.twittSearchBar.setValue("Search", forKey: "cancelButton")
        
        

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
        searchBar.showsCancelButton = true
        let uiButton = self.twittSearchBar.valueForKey("cancelButton") as! UIButton
        uiButton.setTitle("Done", forState: UIControlState.Normal)

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
        if (!textSearch.isEmpty){
        
        if (self.twitterStreamService != nil)
        {
            twitterStreamService = nil
        }
        self.twittSearchBar.resignFirstResponder()
        twitterStreamService  = TwitterStreamService(text:textSearch , numberOfRecords: 10, delegate: self)
        self.busyIndecator.startAnimating()
        }
        else{
            self.showErroMessage("Please enter a search string", messageTitle: "Error")

        }
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
        self.showErroMessage("Some error", messageTitle: "Error")

        
    }
    
    func noTwitterAccountSetUp(){
        println("Here is a Protocal")
        
        self.busyIndecator.stopAnimating()
        self.showErroMessage("Please ge to the settings and set up a Twitter account", messageTitle:"Twitter" )
        
    }
    
    func showErroMessage(text : String, messageTitle: String)
    {
        dispatch_async(dispatch_get_main_queue(), {
            let alert = UIAlertController(title: messageTitle, message: text, preferredStyle: .Alert)
            // Create the action.
            let cancelAction = UIAlertAction(title: "Ok", style: .Cancel) { action in
            }
            
            // Add the action.
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
        })

    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "twittDetailsIdentifire"{
            if let tweetDescriptionViewController = segue.destinationViewController as? TwitterDetailViewController{
                let index = self.twittTableView.indexPathForSelectedRow()?.row
                let twittDict = dataSource[index!] as [String : String]
                let name = twittDict["name"]! as String
                tweetDescriptionViewController.name = name
            }
            
            
        }
    }


}

