//
//  NextViewController.swift
//  TabBarController
//
//  Created by Aaron on 16/9/17.
//  Copyright © 2016年 Aaron. All rights reserved.
//

import UIKit

class NextViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(frame: self.view.frame)
        imageView.image = UIImage(named: "bg01")
        self.view.addSubview(imageView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.zz_tabBarController?.setTabBarHidden(true, animated: true)
    }
}
