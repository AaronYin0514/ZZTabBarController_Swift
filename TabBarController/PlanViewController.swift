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
        let imageView = UIImageView(frame: self.view.frame)
        imageView.image = UIImage(named: "bg03")
        self.view.addSubview(imageView)
        let tableView = UITableView(frame: self.view.bounds)
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NSClassFromString("UITableViewCell"), forCellReuseIdentifier: "Id")
        self.view.addSubview(tableView)
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 35
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Id")
        cell?.textLabel?.text = "第\((indexPath as NSIndexPath).row)行"
        return cell!
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.zz_tabBarItem.setBadgeValue(String((indexPath as NSIndexPath).row), animated: true)
//        self.zz_tabBarItem.badgeValue = String(indexPath.row)
    }

}
