 //
//  TableViewController.swift
//  exapmpleApp
//
//  Created by testuser on 11/29/14.
//  Copyright (c) 2014 testuser. All rights reserved.
//

import UIKit


class TableViewController: UITableViewController {
    
    let model = DribbleModel();
    private let minShotsDownloaded = 100;

    override func viewDidLoad() {
        super.viewDidLoad()

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
        let cell = tableView.dequeueReusableCellWithIdentifier("reusedCell", forIndexPath: indexPath) as TableViewCell
        
        let index = indexPath.row;
        let shot = model.shotList[index]
        cell.idLabel.text = String(shot.id!)
        
        self._getNewShotsIfNeedToAfterIndex(index)
        
        return cell
    }
    
    
    override func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        return 150
    }

}
