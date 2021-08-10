//
//  AppDelegate.swift
//  Counters
//
//

import UIKit
import Counter
import NewCounter
import CounterList

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var appCoordinator: AppCoordinator?

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
        
        Counter.DiComponents.bind()
        NewCounter.DIComponents.bind()
        CounterList.DIComponents.bind()
        return true
    }
}
