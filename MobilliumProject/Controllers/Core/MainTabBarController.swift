//
//  MainTabBarController.swift
//  MobilliumProject
//
//  Created by Yarkın Gazibaba on 19.05.2022.

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: FavoritesViewController())
        
        vc1.title = "Launches"
        vc2.title = "Downloads"
        vc1.tabBarItem.image = UIImage(named: "unselected_rocket")
        vc2.tabBarItem.image = UIImage(systemName: "arrow.down.circle.fill")
        
        tabBar.tintColor = UIColor(named: "selected")
        UITabBar.appearance().unselectedItemTintColor = .gray        
        setViewControllers([vc1,vc2], animated: true)
    }
}
