# ZZTabBarController
![image](https://raw.githubusercontent.com/AaronYin0514/ZZTabBarController_Swift/master/TabBarController/Product/ZZTabBarController.png)
功能强大的TabBarController，能够满足绝大多数对TabBarController的设计需求，功能特色

* 扩展了Badge功能，设置Badge值动画
* 仿QQ Badge效果，可拖动消除
* 设置自定义按钮，代理中实现点击方法
* 设置TabBarItem背景
* 自定义分割线



## 使用
仿系统UITabBarController，使用与系统方法一样

```obj-c
var viewControllers: [UIViewController] = []
// MARK: - Home
let homeViewController: HomeViewController = HomeViewController()
homeViewController.zz_tabBarItem.image = UIImage(named: "tabbarUnselectedIcon1")
homeViewController.zz_tabBarItem.selectedImage = UIImage(named: "tabbarSelectedIcon1")
homeViewController.zz_tabBarItem.selectedTitleAttributes = [NSForegroundColorAttributeName: UIColor(red: 1.0, green: 121.0 / 255.0, blue: 168.0 / 255.0, alpha: 1.0)]
viewControllers.append(homeViewController)
// MARK: - Map
let mapViewController: MapViewController = MapViewController()
mapViewController.zz_tabBarItem.title = "Map"
mapViewController.zz_tabBarItem.image = UIImage(named: "tabbarUnselectedIcon2")
mapViewController.zz_tabBarItem.selectedImage = UIImage(named: "tabbarSelectedIcon2")
mapViewController.zz_tabBarItem.selectedTitleAttributes = [NSForegroundColorAttributeName: UIColor(red: 1.0, green: 121.0 / 255.0, blue: 168.0 / 255.0, alpha: 1.0)]
viewControllers.append(mapViewController)   
// MARK: - Plan
let planViewController: PlanViewController = PlanViewController()
planViewController.zz_tabBarItem.title = "Plan"
planViewController.zz_tabBarItem.image = UIImage(named: "tabbarUnselectedIcon3")
planViewController.zz_tabBarItem.selectedImage = UIImage(named: "tabbarSelectedIcon3")
planViewController.zz_tabBarItem.selectedTitleAttributes = [NSForegroundColorAttributeName: UIColor(red: 1.0, green: 121.0 / 255.0, blue: 168.0 / 255.0, alpha: 1.0)]
planViewController.zz_tabBarItem.badgeValue = "10"
viewControllers.append(planViewController)   
// MARK: - Setting
let settingViewController: SettingViewController = SettingViewController()
settingViewController.zz_tabBarItem.title = "Setting"
settingViewController.zz_tabBarItem.image = UIImage(named: "tabbarUnselectedIcon4")
settingViewController.zz_tabBarItem.selectedImage = UIImage(named: "tabbarSelectedIcon4")
settingViewController.zz_tabBarItem.selectedTitleAttributes = [NSForegroundColorAttributeName: UIColor(red: 1.0, green: 121.0 / 255.0, blue: 168.0 / 255.0, alpha: 1.0)]
let settingNavigation: UINavigationController = UINavigationController(rootViewController: settingViewController)
viewControllers.append(settingNavigation)  
// MARK: - TabBarController
let tabBarViewController: ZZTabBarController = ZZTabBarController()
tabBarViewController.delegate = self    
tabBarViewController.viewControllers = viewControllers
```
## 案例
** 1. 动画 **

```obj-c
// MARK: 设置badge值动画
self.zz_tabBarItem.setBadgeValue(String((indexPath as NSIndexPath).row), animated: true)
// MARK: TabBar隐藏动画
self.zz_tabBarController?.setTabBarHidden(true, animated: true)
// MARK: 开启badge拖动动画
tabBarViewController.badgeAnimation = true
// MARK: badge拖动消除代理
func tabBarController(_ tabBarController: ZZTabBarController, badgeClearAtIndex index: Int) {
        print("清空badge : \(index)")
}
```

![image](https://raw.githubusercontent.com/AaronYin0514/ZZTabBarController_Swift/master/TabBarController/Product/badge1.gif)

** 2. 自定义按钮 **

```obj-c
// MARK: Custom Item
let customItem: ZZTabBarItem = ZZTabBarItem()
customItem.itemHeight = 59.0
customItem.itemType = .action
customItem.image = UIImage(named: "home_circle")
// MARK: 设置自定义按钮
tabBarViewController.setupViewControllers(viewControllers, customItem: (customItem, 2))
```

![image](https://raw.githubusercontent.com/AaronYin0514/ZZTabBarController_Swift/master/TabBarController/Product/badge2.gif)

** 3. 黑色主题风格 **

```obj-c
// MARK: 设置item背景
homeViewController.zz_tabBarItem.selectedBackgroundImage = UIImage(named: "tabbar_selected")
// MARK: 设置TabBar背景
let bgView = UIView()
bgView.backgroundColor = UIColor.darkGray
tabBarViewController.tabBar.backgroundView = bgView
```

![image](https://raw.githubusercontent.com/AaronYin0514/ZZTabBarController_Swift/master/TabBarController/Product/badge3.png)

** 4. 自定义分割线 **

```obj-c
// MARK: 显示分割线
tabBarViewController.showSeparationLine = true
// MARK: 设置分割线图片
tabBarViewController.tabBar.separationLineImage = UIImage(named: "unipay_bgarrow")
```

![image](https://raw.githubusercontent.com/AaronYin0514/ZZTabBarController_Swift/master/TabBarController/Product/badge4.png)