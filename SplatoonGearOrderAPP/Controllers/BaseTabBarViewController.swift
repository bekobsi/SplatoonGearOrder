//
//  BaseTabBarController.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2020/09/01.
//  Copyright © 2020 原直也. All rights reserved.
//

import UIKit

class BaseTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers?.enumerated().forEach({ (index, viewController) in
            switch index{
            case 0:
                setTabbarInfo(viewController, selectedImageName: "map-icon-selected" , unselectedImageName: "map-icon-unselected", title: "スケジュール")
            case 1:
                setTabbarInfo(viewController, selectedImageName: "shoes-icon-selected", unselectedImageName: "shoes-icon-unselected", title: "GesoTown")
            default:
                break
            }
        })
    }
    private func setTabbarInfo(_ viewController: UIViewController, selectedImageName:String, unselectedImageName:String, title: String){
        viewController.tabBarItem.selectedImage = UIImage(named: selectedImageName)?.resize(size: .init(width: 20, height: 20))?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem.image = UIImage(named: unselectedImageName)?.resize(size: .init(width: 20, height: 20))?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem.title = title
    }
}
