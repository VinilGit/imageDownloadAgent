//
//  imageDownloadOperation.swift
//  exapmpleApp
//
//  Created by Sergey Alexeev on 01/12/14.
//  Copyright (c) 2014 testuser. All rights reserved.
//

import UIKit

typealias operationHandler = (image: UIImage, NSError) -> Void

class imageDownloadOperation: NSObject {
    
    var handler:operationHandler?
    var request:NSURLRequest
    
    init(request:NSURLRequest, handler:operationHandler) {
        self.request = request
        self.handler = handler
    }
    
    func perform () {
        NSURLConnection.sendAsynchronousRequest(request,
            queue: NSOperationQueue.mainQueue(),
            completionHandler:{response, data, error in
                if (self.handler != nil) {
                    self.handler!(image: UIImage(data: data)!, error)
                }
        })
    }
}
