//
//  SettingViewController.swift
//  001TabBarController
//
//  Created by Aaron on 16/8/20.
//  Copyright © 2016年 Aaron. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(frame: self.view.frame)
        imageView.image = UIImage(named: "bg03")
        self.view.addSubview(imageView)
        self.title = "设置"
        self.view.backgroundColor = UIColor.cyan
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 170, y: 300, width: 50, height: 50)
        btn.backgroundColor = UIColor.orange
        btn.setTitle("Next", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.cornerRadius = 25.0
        btn.addTarget(self, action: #selector(SettingViewController.action), for: .touchUpInside)
        self.view.addSubview(btn)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.zz_tabBarController?.setTabBarHidden(false, animated: true)
    }

    @objc func action() -> Void {
        let nextController = NextViewController()
        self.navigationController?.pushViewController(nextController, animated: true)
    }

}
