//
//  TweetDetails.swift
//  StreamTweetSwift
//
//  Created by Suman Chatterjee on 08/06/2015.
//  Copyright (c) 2015 Suman Chatterjee. All rights reserved.
//

import Foundation
import CoreData

class TweetDetails: NSManagedObject {

    @NSManaged var imageURL: String?
    @NSManaged var createdAt: String?
    @NSManaged var tweetDescription: String?
    @NSManaged var twittURL: String?
    @NSManaged var name: String?

}
