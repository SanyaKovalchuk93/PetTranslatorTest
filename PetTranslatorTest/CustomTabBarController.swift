//
//  CustomTabBar.swift
//  PetTranslatorTest
//
//  Created by Alexandr Kovalchuk on 13.02.2025.
//

import UIKit

class CustomTabBarController: UITabBarController{

    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        setTabBarAppearance()
    }
    
    private func generateTabBar() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

            let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! ViewController
            let settingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsViewController

            viewControllers = [
                generateVC(viewController: homeVC, title: "Translator", image: UIImage(named: "messages-icon")),
                generateVC(viewController: settingsVC, title: "Clicker", image: UIImage(named: "settings-icon"))
            ]
    }
    
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
    
    private func setTabBarAppearance() {
       
        let positionOnY: CGFloat = 16
        let width = 216
        let height = 82
        
        let centerX = (Int(tabBar.bounds.width) - width) / 2
        
        let roundLayer = CAShapeLayer()
        
        let bezierPath = UIBezierPath(
            roundedRect: CGRect(
                x: CGFloat(centerX),
                y: tabBar.bounds.minY - positionOnY,
                width: CGFloat(width),
                height: CGFloat(height)
            ),
            cornerRadius: 20
        )
        
        roundLayer.path = bezierPath.cgPath
        
        tabBar.layer.insertSublayer(roundLayer, at: 0)
        
        tabBar.itemWidth = CGFloat(width / 3)
        tabBar.barTintColor = .black
        tabBar.itemPositioning = .centered
        
        roundLayer.fillColor = UIColor.white.cgColor
        
        
    }
    
}
