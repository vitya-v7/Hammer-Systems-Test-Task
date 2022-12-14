//
//  CategoryHeader.swift
//  Hammer-Systems-Test-Task
//
//  Created by Admin on 27.10.2022.
//

import Foundation
import UIKit

protocol CategoryHeaderViewDelegate: AnyObject {
    func categoryHeaderView(_ headerView: CategoryHeader,
                            didTapOnButtonWithIndex index: Int)
}

final class CategoryHeader: UITableViewHeaderFooterView {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    weak var delegate: CategoryHeaderViewDelegate?
    private(set) var selectedItem = 0
    static var reuseIdentifier = "CategoryHeaderID"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView.register(UINib(nibName: CategoryHeaderSegmentView.nibName,
                                           bundle: Bundle.main),
                                     forCellWithReuseIdentifier: CategoryHeaderSegmentView.reuseCellIdentifier)
        self.collectionView.allowsSelection = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: self.bounds.width / 4.0,
                                         height: self.bounds.height / 2.0)
            self.collectionView.collectionViewLayout = flowLayout
        }
    }
}

extension CategoryHeader: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        8
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryHeaderSegmentView.reuseCellIdentifier,
            for: indexPath) as? CategoryHeaderSegmentView else {
                return UICollectionViewCell()
            }
        cell.configureWithTitle("\(indexPath.item)",
                                indexPath: indexPath,
                                isSelected: indexPath.item == selectedItem,
                                color: .systemPink)
        
        cell.delegate = self
        return cell
    }
    
    func setSelectedItemIndexPath(_ indexPath: IndexPath) {
        
        self.selectedItem = indexPath.item
        self.collectionView.scrollToItem(at: indexPath,
                                         at: .centeredHorizontally,
                                         animated: true)
        self.collectionView.reloadData()
    }
    
}

extension CategoryHeader: CategoryHeaderSegmentViewDelegate {
    func categoryHeaderSegmentViewDidTapOnButton(_ segmentView: CategoryHeaderSegmentView) {
        guard let selectedIndexPath = segmentView.indexPath else {
            return
        }
        self.setSelectedItemIndexPath(selectedIndexPath)
        self.delegate?.categoryHeaderView(self,
                                          didTapOnButtonWithIndex: self.selectedItem)
    }
}
