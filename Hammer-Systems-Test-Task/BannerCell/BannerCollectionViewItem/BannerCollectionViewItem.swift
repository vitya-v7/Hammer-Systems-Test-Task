//
//  BannerCollectionViewItem.swift
//  Hammer-Systems-Test-Task
//
//  Created by Admin on 22.10.2022.
//

import Foundation
import UIKit

final class BannerCollectionViewItem: UICollectionViewCell {
    
    @IBOutlet private weak var imgView: UIImageView!
    
    static let reuseCellIdentifier = "BannerCollectionViewItemID"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgView.layer.cornerRadius = 10.0
    }
    
    func configureWithImage(_ image: UIImage, andAlpha alpha: CGFloat) {
        self.imgView.image = image
        self.imgView.alpha = alpha
    }
}
