//
//  AppDelegate.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2020/09/01.
//  Copyright © 2020 原直也. All rights reserved.
//

import NCMB
import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // ********** APIキーの設定 **********
    let applicationkey = "fc0409eb0a48129c0b208e41ca3031cb7bc0c479e0017251d1d380bb632e96be"
    let clientkey = "98550e415db2d8f5378464fa5927f897cbbb4c04faf414d8475de28ae669fd57"
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NCMB.initialize(applicationKey: applicationkey, clientKey: clientkey)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = BaseTabBarViewController()
        window?.makeKeyAndVisible()

        //        プッシュ通知の初期設定
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if error != nil {
                return
            }
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }

        //        TabBarのカラー変更
        UITabBarItem.appearance().setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 9, weight: .bold), .foregroundColor: UIColor(red: 230 / 255, green: 50 / 255, blue: 50 / 255, alpha: 1)], for: .normal)

        return true
    }

    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //        端末情報を扱うNCMBInstallationのインスタンスを生成
        let installation = NCMBInstallation.currentInstallation

        //                Device tokenを設定
        installation.setDeviceTokenFromData(data: deviceToken)
        //        　　　　　　端末情報をデータストアに登録
        installation.saveInBackground { result in
            switch result {
            case .success:
                //                端末情報の登録に成功した時の処理
                print("端末情報の登録に成功しました", result)
            case let .failure(error):
                print("端末情報の登録に失敗しました", error)
            }
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
