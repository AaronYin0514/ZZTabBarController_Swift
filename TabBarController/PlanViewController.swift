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
        imageView.image = UIImage(named: "bg04")
        self.view.addSubview(imageView)
        let myBackgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        myBackgroundView.frame = self.view.frame
        self.view.addSubview(myBackgroundView)
        let tableView = UITableView(frame: CGRect(x: 0.0, y: 20.0, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 20.0))
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "MyTableViewCell", bundle: nil), forCellReuseIdentifier: "Id")
        self.view.addSubview(tableView)
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Id") as! MyTableViewCell
        cell.selectionStyle = .none
        cell.contentLabel.text = String(format: "设置Bage值%ld", indexPath.row)
        return cell
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.zz_tabBarItem.setBadgeValue(String((indexPath as NSIndexPath).row), animated: true)
//        self.zz_tabBarItem.badgeValue = String(indexPath.row)
    }

}
