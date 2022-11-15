//
//  CategoryHeaderButton.swift
//  Hammer-Systems-Test-Task
//
//  Created by Admin on 27.10.2022.
//

import Foundation
import UIKit

protocol CategoryHeaderSegmentViewDelegate: AnyObject {
    func categoryHeaderSegmentViewDidTapOnButton(_ segmentView: CategoryHeaderSegmentView)
}

final class CategoryHeaderSegmentView: UICollectionViewCell {
    
    @IBOutlet private weak var mainButtonTitle: UIButton!
    
    weak var delegate: CategoryHeaderSegmentViewDelegate?
    var indexPath: IndexPath?
    private var segmentColor: UIColor = .blue
    static let reuseCellIdentifier = "CategoryHeaderSegmentViewID"
    static let nibName = "CategoryHeaderSegmentView"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectFuncCell(false)
    }
    
    @IBAction func mainButtonTitleAction(_ sender: Any) {
        self.selectFuncCell(true)
        self.delegate?.categoryHeaderSegmentViewDidTapOnButton(self)
    }
    
    func selectFuncCell(_ isSelection: Bool) {
        let backColor = isSelection ?
        self.segmentColor.withAlphaComponent(0.3) :
            .clear
        let textColor = isSelection ?
        self.segmentColor :
        self.segmentColor.withAlphaComponent(0.2)
        self.mainButtonTitle.backgroundColor = backColor
        self.mainButtonTitle.setTitleColor(textColor, for: .normal)
        self.mainButtonTitle.layer.cornerRadius = 0.5 * self.bounds.height
        self.mainButtonTitle.layer.borderWidth = 2.0
        self.mainButtonTitle.layer.borderColor = isSelection ? UIColor.clear.cgColor : textColor.cgColor
    }
    
    func configureWithTitle(_ title: String,
                            indexPath: IndexPath,
                            isSelected: Bool = false,
                            color: UIColor = .red) {
        self.segmentColor = color
        self.mainButtonTitle.setTitle(title,
                                      for: .normal)
        
        self.selectFuncCell(isSelected)
        self.indexPath = indexPath
    }
    
}
