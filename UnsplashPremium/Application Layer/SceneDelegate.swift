//
//  SceneDelegate.swift
//  UnsplashPremium
//
//  Created by user on 25.04.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let homeVC = HomePageViewController(viewModel: HomeViewModel(photosService: PhotosServiceImplementation()))
        let searchVC = SearchResultViewController(nibName: nil, bundle: nil)
        let postVC = PostViewController(nibName: nil, bundle: nil)
        let profileVC = ProfileViewController(nibName: nil, bundle: nil)
                
        homeVC.tabBarItem.image = UIImage(systemName: "photo.fill")
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        postVC.tabBarItem.image = UIImage(systemName: "plus.square.fill")
        profileVC.tabBarItem.image = UIImage(systemName: "person.circle.fill")
        
        let homeNavC = UINavigationController(rootViewController: homeVC)
        let searchNavC = UINavigationController(rootViewController: searchVC)
        let postNavC = UINavigationController(rootViewController: postVC)
        let profileNavC = UINavigationController(rootViewController: profileVC)
        
        let tabBarC = UITabBarController()
        tabBarC.viewControllers = [homeNavC,searchNavC,postNavC,profileNavC]
        tabBarC.selectedIndex = 0
        tabBarC.tabBar.backgroundColor = .black
        tabBarC.tabBar.unselectedItemTintColor = .gray
        tabBarC.tabBar.tintColor = .white
        window?.rootViewController = tabBarC
        window?.makeKeyAndVisible()

    }
}
