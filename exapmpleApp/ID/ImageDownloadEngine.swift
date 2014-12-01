//
//  ImageDownloadEngine.swift
//  exapmpleApp
//
//  Created by Sergey Alexeev on 01/12/14.
//  Copyright (c) 2014 testuser. All rights reserved.
//

import UIKit

class ImageDownloadEngine: NSObject {
    
    
    func downloadImage(url: NSURL, handler: (operationHandler)) {
        
        
        
        var imageRequest: NSURLRequest = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(imageRequest,
            queue: NSOperationQueue.mainQueue(),
            completionHandler:{response, data, error in
                handler(image: UIImage(data: data)!, error)
        })
    }
    
}
