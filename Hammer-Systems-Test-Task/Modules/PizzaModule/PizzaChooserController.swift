//
//  PizzaChooserController.swift
//  Hammer-Systems-Test-Task
//
//  Created by Admin on 22.10.2022.
//

import UIKit

protocol PizzaChooserViewInput: AnyObject {
    func reloadTableView()
    func setCitiesOnButtonMenu(_ citiesNames: [String])
    func showErrorAlert(withTitle title: String,
                        andDescription description: String)
    func showTableLoadingIndicator(_ show: Bool)
}

protocol PizzaChooserViewOutput {
    var viewModels: [PizzaCellViewModel]? { get }
    var numberOfRowsInEachSection: Int { get }
    var numberOfElements: Int { get }
    func viewDidLoadDone()
    func viewWillAppearDone()
    func countOfElements() -> Int
}

final class PizzaChooserController: UIViewController, PizzaChooserViewInput {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var cityButton: UIButton!
    @IBOutlet private weak var tableLoadingIndicator: UIActivityIndicatorView!
    
    var output: PizzaChooserViewOutput?
    static let reuseControllerIdentifier = "PizzaChooserControllerID"
    private var scrollBySegmentButton = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.tableView.register(UINib(nibName: PizzaCell.nibName,
                                      bundle: Bundle.main),
                                forCellReuseIdentifier: PizzaCell.reuseCellIdentifier)
        self.tableView.register(UINib(nibName: "CategoryHeader",
                                      bundle: Bundle.main),
                                forHeaderFooterViewReuseIdentifier: CategoryHeader.reuseIdentifier)
        self.output?.viewDidLoadDone()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.output?.viewWillAppearDone()
    }
    
    func showTableLoadingIndicator(_ show: Bool) {
        DispatchQueue.main.async {
            self.tableLoadingIndicator.isHidden = !show
        }
    }
    
    func setCitiesOnButtonMenu(_ citiesNames: [String]) {
        let citiesActions = citiesNames.map { cityName in
            UIAction(title: cityName,
                     image: nil,
                     handler: cityChosen)
        }
        
        let saveMenu = UIMenu(children: citiesActions)
        cityButton.menu = saveMenu
        cityButton.showsMenuAsPrimaryAction = true
        cityButton.isContextMenuInteractionEnabled = true
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showErrorAlert(withTitle title: String,
                        andDescription description: String) {
        AlertHelper.shared.showAlert(inController: self,
                                     withTitle: title,
                                     message: description)
    }

    @objc
    func cityChosen(_ action: UIAction) {
        self.cityButton.setTitle(action.title,
                                 for: .normal)
    }
    
}

extension PizzaChooserController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: BannerCell.reuseCellIdentifier,
                for: indexPath) as? BannerCell else {
                    return UITableViewCell()
                }
            cell.dataSource = self.output as? BannerCellDataSource
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PizzaCell.reuseCellIdentifier,
            for: indexPath) as? PizzaCell,
              let viewModels = self.output?.viewModels else {
                  return UITableViewCell()
              }
        cell.confugureWithViewModel(viewModels[indexPath.item],
                                    indexPath: indexPath)
        if indexPath == IndexPath(item: 0, section: 1) {
            cell.layer.cornerRadius = 10
            cell.layer.maskedCorners = [.layerMaxXMinYCorner,
                                        .layerMinXMinYCorner]
            cell.layer.masksToBounds = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return indexPath == IndexPath(item: 0, section: 0) ? self.view.bounds.height / 6.0
            : self.view.bounds.height / 5.0
        }
        return indexPath == IndexPath(item: 0, section: 0) ? self.view.bounds.height / 7.0
        : self.view.bounds.height / 5.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 1,
              let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CategoryHeader.reuseIdentifier) as? CategoryHeader else {
                  return nil
              }
        headerView.delegate = self
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return UIDevice.current.userInterfaceIdiom == .pad ? 120.0 : 80.0
        default:
            return 0
        }
    }
}

extension PizzaChooserController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 1 else {
            return 1
        }
        guard let viewModels = self.output?.viewModels else {
            return 0
        }
        
        return viewModels.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        guard self.output?.viewModels != nil else {
            return 1
        }
        return 2
    }
    
}

extension PizzaChooserController: CategoryHeaderViewDelegate {
    func categoryHeaderView(_ headerView: CategoryHeader,
                            didTapOnButtonWithIndex index: Int) {
        guard let output = self.output else {
            return
        }
        DispatchQueue.main.async {
            self.scrollBySegmentButton = true
            self.tableView.scrollToRow(at: IndexPath(item: index * output.numberOfRowsInEachSection,
                                                     section: 1),
                                       at: index == 0 ? .bottom : .top, animated: false)
            self.reloadTableView()
        }
    }
}

extension PizzaChooserController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let output = self.output,
              self.scrollBySegmentButton == false,
              let headerView = self.tableView.headerView(forSection: 1) as? CategoryHeader,
              let minVisibleIndexPath = self.tableView.indexPathsForVisibleRows?.min() else {
                  self.scrollBySegmentButton = false
                  return
              }
        var minVisibleItem = (minVisibleIndexPath.item + 1) / output.numberOfRowsInEachSection
        let height = scrollView.frame.size.height
        let contentYOffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYOffset
        if distanceFromBottom < height - 0.1 {
            minVisibleItem += 1
        }
        if minVisibleItem != headerView.selectedItem {
            headerView.setSelectedItemIndexPath(IndexPath(item: minVisibleItem, section: 0))
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.reloadTableView()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.reloadTableView()
        }
    }
}
