//
//  MapViewController.swift
//  001TabBarController
//
//  Created by Aaron on 16/8/20.
//  Copyright © 2016年 Aaron. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    fileprivate var lastPostionY: CGFloat = 0.0
    
    fileprivate var arr: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arr = [
            "stay hungry , stay foolish .",
            "活着就是为了改变世界，难道还有其他原因吗？",
            "你的时间是有限的，所以不要浪费时间活在别人的生命中。",
            "伟大的艺术品不必追随潮流，他本身就能引领潮流。",
            "只有疯狂到认为自己能改变世界的人，才能真正的改变世界.",
            "专注和简单一直是我的秘诀之一。简单可能比复杂更难做到：你必须努力理清思路，从而使其变得简单。但最终这是值得的，因为一旦你做到了，便可以创造奇迹。",
            "在你生命的最初30年中，你养成习惯；在你生命的最后30年中，你的习惯决定了你。",
            "你如果出色地完成了某件事，那你应该再做一些其他的精彩事儿。不要在前一件事上徘徊太久，想想接下来该做什么。",
            "你想用卖糖水来度过余生，还是想要一个机会来改变世界？",
            "时间宝贵，不要虚掷光阴过他人的生活，不要让周围的聒噪言论蒙蔽你内心的声音",
            "我坚信，区分成功与不成功，一半的因素就是纯粹的毅力差别。",
            "我愿意用我所有的科技去换取和苏格拉底相处的一个下午。",
            "时间是有限的，所以不要把时间浪费在走别人的路上。",
            "You only live once. Make it count.",
            "不要让别人的意见淹没了你内心的声音。"
        ]
        let imageView = UIImageView(frame: self.view.frame)
        imageView.image = UIImage(named: "bg02")
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
        return arr!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Id") as! MyTableViewCell
        cell.selectionStyle = .none
        cell.contentLabel.text = arr?[indexPath.row]
        return cell
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    // MARK: - UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastPostionY = scrollView.contentOffset.y
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if lastPostionY > scrollView.contentOffset.y {
            // up
            self.up()
        } else {
            // down
            self.down()
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
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
