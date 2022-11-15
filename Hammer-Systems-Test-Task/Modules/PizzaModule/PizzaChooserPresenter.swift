//
//  PizzaChooserPresenter.swift
//  Hammer-Systems-Test-Task
//
//  Created by Admin on 24.10.2022.
//

import Foundation
import Reachability
import UIKit

final class PizzaChooserPresenter: PizzaChooserViewOutput, BannerCellDataSource {
    
    weak var view: PizzaChooserViewInput?
    var viewModels: [PizzaCellViewModel]?
    lazy var bannerImages: [UIImage] = {
        var images = [1, 2, 3, 4, 5].compactMap { number in
            return UIImage(named: "1\(number)")
        }
        return images
    }()
    
    var numberOfRowsInEachSection: Int = 10
    var numberOfElements: Int = 100
    private var newsAPIService = NewsAPIService()
    private var reachability: Reachability?
    
    func viewDidLoadDone() {
        self.view?.setCitiesOnButtonMenu(Constants.cities)
    }
    
    func viewWillAppearDone() {
        let viewController = self.view as? UIViewController
        guard let reachability = try? Reachability() else {
            AlertHelper.shared.showNoInternetAlertInController(viewController)
            return
        }
        
        self.reachability = reachability
        
        do {
            try reachability.startNotifier()
        } catch {
            AlertHelper.shared.showNoInternetAlertInController(viewController)
            return
        }
        
        self.reachability?.whenReachable = { [weak self] reachability in
            guard reachability.connection != .unavailable else {
                AlertHelper.shared.showNoInternetAlertInController(viewController)
                return
            }
            self?.view?.showTableLoadingIndicator(true)
            self?.newsAPIService.getNews(successCallback: { [weak self] (data: [NewsElementModel]?) -> Void in
                self?.view?.showTableLoadingIndicator(false)
                guard let strongSelf = self else {
                    return
                }
                strongSelf.viewModels = []
                guard let dataIn = data else {
                    self?.view?.showErrorAlert(withTitle: "Error",
                                               andDescription: "No data received")
                    return
                }
                for (num, model) in dataIn.enumerated() {
                    guard num < strongSelf.numberOfElements else {
                        break
                    }
                    let viewModel = PizzaCellViewModel(pizzaImage: UIImage(named: ""),
                                                       pizzaImgURL: model.url,
                                                       pizzaTitle: model.title,
                                                       pizzaDescription: model.description,
                                                       pizzaBuyButtonText: "1$")
                    strongSelf.viewModels?.append(viewModel)
                }
                strongSelf.view?.reloadTableView()
            }, errorCallback: { [weak self] error in
                self?.view?.showErrorAlert(withTitle: "Error",
                                           andDescription: error.localizedDescription)
            })
        }
        
        self.reachability?.whenUnreachable = { [weak self] reachability in
            guard reachability.connection == .unavailable else {
                return
            }
            AlertHelper.shared.showNoInternetAlertInController(viewController)
        }
    }
    
}
