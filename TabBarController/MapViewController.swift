//
//  MapViewController.swift
//  001TabBarController
//
//  Created by Aaron on 16/8/20.
//  Copyright © 2016年 Aaron. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    private var lastPostionY: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tableView = UITableView(frame: self.view.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(NSClassFromString("UITableViewCell"), forCellReuseIdentifier: "Id")
        self.view.addSubview(tableView)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 35
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Id")
        cell?.textLabel?.text = "第\(indexPath.row)行"
        return cell!
    }
    // MARK: - UITableViewDelegate
    
    // MARK: - UIScrollViewDelegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        lastPostionY = scrollView.contentOffset.y
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if lastPostionY > scrollView.contentOffset.y {
            // up
            self.up()
        } else {
            // down
            self.down()
        }
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
//        print("scrollViewWillBeginDecelerating")
//        print("scrollView contentOffset y : \(scrollView.contentOffset.y)")
    }
    // MARK: - Action
    func up() -> Void {
        if self.zz_tabBarController?.tabBarHidden == true {
            self.zz_tabBarController?.setTabBarHidden(false, animated: true)
        }
    }
    
    func down() -> Void {
        if self.zz_tabBarController?.tabBarHidden == false {
            self.zz_tabBarController?.setTabBarHidden(true, animated: true)
        }
    }
    
}
