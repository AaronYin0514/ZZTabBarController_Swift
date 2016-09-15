# ZZTabBarController

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
** 1. 仿系统UITabBarController **

![image](https://raw.githubusercontent.com/AaronYin0514/ZZTabBarController_Swift/master/TabBarController/Product/TabBar1.png)

** 2. 自定义按钮 **

![image](https://raw.githubusercontent.com/AaronYin0514/ZZTabBarController_Swift/master/TabBarController/Product/TabBar2.png)

** 3. 黑色主题风格 **

![image](https://raw.githubusercontent.com/AaronYin0514/ZZTabBarController_Swift/master/TabBarController/Product/heise.png)
