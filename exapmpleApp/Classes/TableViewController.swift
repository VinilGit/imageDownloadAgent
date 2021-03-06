 //
//  TableViewController.swift
//  exapmpleApp
//
//  Created by testuser on 11/29/14.
//  Copyright (c) 2014 testuser. All rights reserved.
//

import UIKit


class TableViewController: UITableViewController {
    
    let imageEngine = ImageDownloadEngine()
    let model = DribbleModel()
    
    private let minShotsDownloaded = 100;

    override func viewDidLoad() {
        super.viewDidLoad()

        imageEngine.maxParallelOperationCount = 1
        
        self.clearsSelectionOnViewWillAppear = false
        
        var tblView =  UIView(frame: CGRectZero)
        self.tableView.tableFooterView = tblView
        self.tableView.backgroundColor = UIColor.clearColor()
        
        self._loadNextPage()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Provate
    
    private func _loadNextPage() {
        model.getNextPage({[unowned self] in
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        })
    }
    
    private func _getNewShotsIfNeedToAfterIndex(index: Int)
    {
        if ((self.model.shotList.count - index) < minShotsDownloaded) {
            self._loadNextPage()
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("Show \(model.shotList.count) cells")
        return model.shotList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("reusedCell", forIndexPath: indexPath) as TableViewCell
        
        let index = indexPath.row;
        let shot = model.shotList[index]
        cell.shotId = shot.id
        cell.idLabel.text = shot.id != nil ? String(shot.id!) : ""
        cell.imageView.image = nil
        self.imageEngine.downloadImage(shot.imageUrl, handler: { (image, error) -> Void in
            if (error != nil) {
                println()
            } else if let newImage = image {
                if (cell.shotId != nil && shot.id != nil && cell.shotId == shot.id) {
                    cell.imageView.image = newImage;
                    cell.idLabel.text = ""
                    cell.setNeedsLayout()
                    println("Image set for cell \(cell.shotId) \n\(shot.imageUrl)")
                } else {
                    var newCell:TableViewCell? = self.tableView.cellForRowAtIndexPath(indexPath) as? TableViewCell
                    println("Oops \(newCell)")
                }
            }
        })
        
        self._getNewShotsIfNeedToAfterIndex(index)
        
        return cell
    }
    
    
    override func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        return 150
    }

}
