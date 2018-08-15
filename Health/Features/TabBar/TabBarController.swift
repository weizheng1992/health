//
//  TabBarController.swift
//  Health
//
//  Created by Weichen Jiang on 8/3/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewController(TodayViewController(), title: JKString("tabbar.today"), image: "TabBar-Today", selectedImage: "TabBar-Today")
        addChildViewController(NewsViewController(), title: JKString("tabbar.news"), image: "TabBar-News", selectedImage: "TabBar-News")
        addChildViewController(ServicesViewController(), title: JKString("tabbar.services"), image: "TabBar-Services", selectedImage: "TabBar-Services")
        addChildViewController(MeViewController(), title: JKString("tabbar.me"), image: "TabBar-Me", selectedImage: "TabBar-Me")
    }
    
    // MARK: Helper
    
    private func addChildViewController(_ viewController: UIViewController, title: String, image imageName: String, selectedImage selectedImageName: String) {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = UIImage(named: imageName)
        navigationController.tabBarItem.selectedImage = UIImage(named: selectedImageName)?.withRenderingMode(.alwaysOriginal)
        addChildViewController(navigationController)
    }
    
}
