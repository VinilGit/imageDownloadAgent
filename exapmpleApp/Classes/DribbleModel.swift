//
//  DribbleModel.swift
//  exapmpleApp
//
//  Created by testuser on 11/29/14.
//  Copyright (c) 2014 testuser. All rights reserved.
//

import UIKit

class DribbleModel: NSObject {
    
    var shotList: [Shot] = []
    
    private var currentPage = 0
    lazy private var data = NSMutableData()
    
    func getNextPage(completition:()-> Void) {
        let urlString = "http://api.dribbble.com/shots/popular";
        var url: NSURL = NSURL(string: urlString)!
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            
            if error != nil {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            if err != nil {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
            }
            
            let json = JSON(object: jsonResult)
            let count: Int? = json["shots"].arrayValue?.count
            println("found \(count!) challenges")
            
            var resutlArray: [Shot] = [];
            if let ct = count {
                for index in 0...ct-1 {
                    let shot = Shot()
                    let stringImageUrl = json["shots"][index]["image_url"].stringValue
                    if (stringImageUrl != nil) {
                        shot.imageUrl = NSURL(string: stringImageUrl!)!
                        shot.id = json["shots"][index]["id"].integerValue;
                        resutlArray.append(shot)
                    }
                }
            }
            self.shotList += resutlArray;
            completition()
        })
        task.resume()
    }

}
