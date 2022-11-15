//
//  ModulesCoordinator.swift
//  Hammer-Systems-Test-Task
//
//  Created by Admin on 15.11.2022.
//

import Foundation
import UIKit

final class ModulesCoordinator {
    
    private weak var tabBarController: UITabBarController?
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }
    
    func start() {
        showNewsScreen()
    }
    
    // MARK: - Private implementation
    private func showNewsScreen() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let newsViewController = mainStoryboard.instantiateViewController(
            withIdentifier: PizzaChooserController.reuseControllerIdentifier) as? PizzaChooserController,
              let firstNavigationController = self.tabBarController?.viewControllers?.first as? UINavigationController else {
                  return
              }
        
        let presenter = PizzaChooserPresenter()
        presenter.view = newsViewController
        newsViewController.output = presenter
        self.setupColor(.init(white: 0.85,
                              alpha: 1.0),
                        toNavigationBar: firstNavigationController.navigationBar)
        firstNavigationController.pushViewController(newsViewController, animated: false)
    }
    
    private func setupColor(_ color: UIColor,
                            toNavigationBar navigationBar: UINavigationBar) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = color
        appearance.shadowColor = .clear
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
}
