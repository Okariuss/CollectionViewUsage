//
//  TabBarViewController.swift
//  CollectionViewUsage
//
//  Created by Okan Orkun on 24.03.2024.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setTabs()
    }
    
}

private extension TabBarViewController {
    private func setTabs() {
        let collectionVC = generateTab(on: CollectionViewController(), image: UIImage(systemName: "1.square")!, selectedImage: UIImage(systemName: "1.square.fill")!)
        
        let advanceCollectionVC = generateTab(on: AdvanceCollectionViewController(), image: UIImage(systemName: "2.square")!, selectedImage: UIImage(systemName: "2.square.fill")!)
        
        let waterfallCollectionVC = generateTab(on: WaterfallCollectionViewController(), image: UIImage(systemName: "3.square")!, selectedImage: UIImage(systemName: "3.square.fill")!)
        
        setViewControllers([collectionVC, advanceCollectionVC, waterfallCollectionVC], animated: true)
    }
    
    private func generateTab(on view: UIViewController, image: UIImage, selectedImage: UIImage) -> UINavigationController {
        let nav = UINavigationController(rootViewController: view)
        nav.tabBarItem = UITabBarItem(title: "", image: image, selectedImage: selectedImage)
        return nav
    }
}
