//
//  BannerCell.swift
//  Hammer-Systems-Test-Task
//
//  Created by Admin on 26.10.2022.
//

import Foundation
import UIKit

protocol BannerCellDataSource: AnyObject {
    var bannerImages: [UIImage] { get }
}

final class BannerCell: UITableViewCell {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    weak var dataSource: BannerCellDataSource?
    static let reuseCellIdentifier = "BannerCellID"
    
    private var selectedItem = 0
    private var itemSize: CGSize = .zero
    private var itemSpace: CGFloat = 30.0
    private var currentIndexPathPage = IndexPath(item: 0, section: 0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.isUserInteractionEnabled = true
        self.collectionView.isPagingEnabled = false
        self.collectionView.isScrollEnabled = true
        if let collectionViewCell = self.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) {
            collectionViewCell.alpha = 1.0
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: self.frame.width / 1.2,
                                         height: self.frame.height)
            self.collectionView.collectionViewLayout = flowLayout
        }
    }
}

extension BannerCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.numberOfBanners
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BannerCollectionViewItem.reuseCellIdentifier,
            for: indexPath) as? BannerCollectionViewItem,
              let image = self.dataSource?.bannerImages[indexPath.item] else {
                return UICollectionViewCell()
            }
        
        cell.configureWithImage(image,
                                andAlpha: indexPath == self.currentIndexPathPage ? 1.0 : 0.5)
        return cell
    }    
}

extension BannerCell: UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth = itemSize.width
        let targetXContentOffset = targetContentOffset.pointee.x
        let contentWidth = collectionView.contentSize.width
        var newPage: CGFloat = 0.0
        let collectionItemSize = self.itemSize.width
        if velocity.x == 0 {
            newPage = floor((targetXContentOffset - 0.5 * self.itemSize.width) /
                            collectionItemSize) + 1.0
        } else {
            newPage = CGFloat(velocity.x > 0 ?
                              self.currentIndexPathPage.item + 1 :
                                self.currentIndexPathPage.item - 1)
            if newPage < 0 {
                newPage = 0
            }
            if newPage > contentWidth / pageWidth {
                newPage = ceil(contentWidth / pageWidth) - 1.0
            }
        }

        let point = CGPoint(x: CGFloat(newPage * pageWidth), y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = point
        self.currentIndexPathPage = IndexPath(item: Int(newPage), section: 0)
        self.collectionView.reloadData()
    }
}

extension BannerCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.itemSize = CGSize(width: self.collectionView.frame.width - 70.0,
                               height: self.collectionView.frame.height)
        return self.itemSize
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: self.itemSpace)
    }
    
}
