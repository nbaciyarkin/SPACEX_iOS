//
//  MainTabBarController.swift
//  MobilliumProject
//
//  Created by Yarkın Gazibaba on 19.05.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    



    override func viewDidLoad() {
        super.viewDidLoad()

        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: UpcomingViewController())
        let vc3 = UINavigationController(rootViewController: FavoritesViewController())
        
        vc1.tabBarItem.image = UIImage(named: "unselected_rocket")
        vc2.tabBarItem.image = UIImage(named: "unselected_favorites")
        vc3.tabBarItem.image = UIImage(named: "unselected_upcoming")
        
        
        tabBar.tintColor = UIColor(named: "selected")
        
        UITabBar.appearance().unselectedItemTintColor = .gray
        
        
        setViewControllers([vc1,vc2,vc3], animated: true)


    }
    


}
