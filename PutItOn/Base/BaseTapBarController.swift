//
//  BaseTapBarController.swift
//  PutItOn
//
//  Created by 박현준 on 2023/03/31.
//

import UIKit

class BaseTabBarController: UITabBarController {
    //MARK: - Properties
    
    //MARK: - Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            
            let vc1 = UINavigationController(rootViewController: VideoViewController())
            let vc2 = UINavigationController(rootViewController: HomeViewController())
            
            vc1.tabBarItem.image = UIImage(systemName: "play.rectangle")
            vc2.tabBarItem.image = UIImage(systemName: "house")
            
            vc1.tabBarItem.selectedImage = UIImage(systemName: "play.rectangle_fill")
            vc2.tabBarItem.selectedImage = UIImage(systemName: "house_fill")
            
            vc1.title = "실시간"
            vc2.title = "홈"
            
            tabBar.tintColor = UIColor.mainColor
            tabBar.unselectedItemTintColor = .unselectedTabbarColor
            tabBar.backgroundColor = UIColor.white
            
            self.navigationController?.navigationBar.isHidden = true
            
            setViewControllers([vc1, vc2], animated: true)
            
            
        }
    }

