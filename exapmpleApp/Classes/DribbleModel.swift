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
    var maxShots = 300
    var currentPage: Int { get { return _nextPage > 0 ? _nextPage-1 : 0 }}

    private var _nextPage: Int = 1
    private var _task: NSURLSessionDataTask?

    lazy private var data = NSMutableData()
    
    func getNextPage(completition:()-> Void) {
        if (_task != nil || shotList.count > maxShots) {
           return
        }
        let urlString = "http://api.dribbble.com/shots/popular?page=\(self._nextPage)";
        var url: NSURL = NSURL(string: urlString)!
        
        let session = NSURLSession.sharedSession()
        _task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if error != nil {
                println(error.localizedDescription)
            }
            
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            if err != nil {
                println("JSON Error \(err!.localizedDescription)")
            }
            
            let json = JSON(object: jsonResult)
            let count: Int? = json["shots"].arrayValue?.count
            println("found \(count!) entities")
            
            var resutlArray: [Shot] = [];
            if let ct = count {
                for index in 0...ct-1 {
                    let shot = Shot()
                    let stringImageUrl = json["shots"][index]["image_url"].stringValue
                    if (stringImageUrl != nil) {
                        shot.imageUrl = NSURL(string: stringImageUrl!)!
                        shot.id = json["shots"][index]["id"].integerValue;
                        resutlArray.append(shot)
//                        println("Add shot with id \(shot.id)")
                    }
                }
            }
            self.shotList += resutlArray;
            self._nextPage++;
            println("Total \(self.shotList.count) entities")
            self._task = nil
            completition()
        })
        _task!.resume()
    }

}
