//
//  PlanViewController.swift
//  001TabBarController
//
//  Created by Aaron on 16/8/20.
//  Copyright © 2016年 Aaron. All rights reserved.
//

import UIKit

class PlanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.zz_tabBarItem.setBadgeValue(String(indexPath.row), animated: true)
//        self.zz_tabBarItem.badgeValue = String(indexPath.row)
    }

}
