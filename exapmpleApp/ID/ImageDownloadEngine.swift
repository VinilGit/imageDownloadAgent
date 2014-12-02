//
//  ImageDownloadEngine.swift
//  exapmpleApp
//
//  Created by Sergey Alexeev on 01/12/14.
//  Copyright (c) 2014 testuser. All rights reserved.
//

import UIKit

class ImageDownloadEngine: NSObject {
    
    public var useCache:Bool = true
    
    private var imageOperationQueue: [ ImageDownloadOperation ] = []
    private var images: [ NSURL:UIImage ] = [:]
    private var currentOperationCount = 0
    private var maxOperationCount = 5

    
    internal func downloadImage(url: NSURL, handler:operationHandler?) {
        let imageRequest: NSURLRequest = NSURLRequest(URL: url)

        if (useCache) {
            if let cachedImage = images[url] {
                if (handler != nil) {
                    handler!(image: cachedImage, error: nil)
                    return
                }
            }
        }
        
        let completition:operationHandler = { (image: UIImage?, error:NSError?) -> Void in
            if let newError = error {
                println(newError)
            }
            if (self.useCache && image != nil) { // cache image
                self.images[url] = image!
                println(self.images.count)
            }
            
            self.pushNewOperation()
            
            if (handler != nil) {
                handler!(image: image, error: error)
            }
        }
        
        let operation = ImageDownloadOperation(request: imageRequest, completition)
        
        dispatch_async(dispatch_get_main_queue()) {
            self.currentOperationCount += 1
        }
        if (currentOperationCount < maxOperationCount) {
            operation.perform()
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                self.imageOperationQueue.append(operation)
                println("Queue count: \(self.imageOperationQueue.count)")
            }
        }
    }
    
    private func pushNewOperation() {
        dispatch_async(dispatch_get_main_queue()) {
            self.currentOperationCount--
            if let operation = self.imageOperationQueue.last {
                self.imageOperationQueue.removeLast()
                operation.perform()
                println("Queue count: \(self.imageOperationQueue.count)")
            }
        }
        
    }
    
}
