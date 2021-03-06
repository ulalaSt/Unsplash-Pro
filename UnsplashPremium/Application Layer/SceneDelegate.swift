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
        
        let homeVC = HomePageViewController(viewModel: HomePageViewModel(photosService: PhotosServiceImplementation()))
        let searchVC = SearchViewController(viewModel: SearchRecommendationViewModel(resultsService: RecommendationServiceImplementation()))
        let postVC = PostViewController(viewModel: PostViewModel(photosService: PhotosServiceImplementation()))
        let profileLoginVC = LoginProfileViewController(viewModel: LoginProfileViewModel(privateService: PrivateUserServiceImplementation()))
        
        if EndPoint.currentUserAccessToken != nil {
            let loginViewController = ProfileViewController(viewModel: ProfileViewModel(privateService: PrivateUserServiceImplementation(), detailService: UserDetailServiceImplementation()))
            profileLoginVC.addPageView(of: loginViewController)
        }
        homeVC.tabBarItem.image = UIImage(systemName: "photo.fill")
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        postVC.tabBarItem.image = UIImage(systemName: "plus.square.fill")
        profileLoginVC.tabBarItem.image = UIImage(systemName: "person.circle.fill")

        let homeNavC = UINavigationController(rootViewController: homeVC)
        let searchNavC = UINavigationController(rootViewController: searchVC)
        let postNavC = UINavigationController(rootViewController: postVC)
        let profileLoginNavC = UINavigationController(rootViewController: profileLoginVC)

        let tabBarC = UITabBarController()
        tabBarC.viewControllers = [homeNavC,searchNavC,postNavC,profileLoginNavC]

        UITabBar.appearance().barTintColor = UIColor(named: "UnsplashBackgroundColor")
        tabBarC.selectedIndex = 0
        tabBarC.tabBar.unselectedItemTintColor = .gray
        tabBarC.tabBar.tintColor = .white
        window?.rootViewController = tabBarC
        window?.makeKeyAndVisible()

    }
}
