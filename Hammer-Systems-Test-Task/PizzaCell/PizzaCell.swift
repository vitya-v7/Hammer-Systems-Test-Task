//
//  PizzaCell.swift
//  Hammer-Systems-Test-Task
//
//  Created by Admin on 22.10.2022.
//

import Foundation
import UIKit
import Reachability

final class PizzaCell: UITableViewCell {
    
    @IBOutlet private weak var pizzaImage: UIImageView!
    @IBOutlet private weak var pizzaTitle: UILabel!
    @IBOutlet private weak var pizzaDescription: UILabel!
    @IBOutlet private weak var pizzaBuyButton: UIButton!
    @IBOutlet private weak var pizzaImageLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var textLoadingIndicator: UIActivityIndicatorView!
    
    static let reuseCellIdentifier = "PizzaCellID"
    static let nibName = "PizzaCell"
    private var viewModel: PizzaCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.pizzaBuyButton.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 14.0 : 7.0
        self.pizzaBuyButton.layer.borderWidth = 2.0
        self.pizzaBuyButton.layer.borderColor = UIColor.red.cgColor
        self.textLoadingIndicator.isHidden = false
        self.pizzaImageLoadingIndicator.isHidden = false
        self.textLoadingIndicator.startAnimating()
        self.pizzaImageLoadingIndicator.startAnimating()
    }
    
    func confugureWithViewModel(_ viewModel: PizzaCellViewModel,
                                indexPath: IndexPath) {
        self.textLoadingIndicator.isHidden = true
        self.pizzaImageLoadingIndicator.isHidden = false
        self.pizzaImageLoadingIndicator.startAnimating()
        self.pizzaImage.image = viewModel.pizzaImage
        self.pizzaTitle.text = viewModel.pizzaTitle
        self.pizzaDescription.text = viewModel.pizzaDescription
        self.pizzaBuyButton.setTitle(viewModel.pizzaBuyButtonText,
                                for: .normal)
        self.viewModel = viewModel
        guard let stringURL = viewModel.pizzaImgURL else { return }
        let urlImage = URL.init(string: stringURL)
        OperationImageAPIService.shared.imageURL = urlImage
        
        guard let reachability = try? Reachability(),
              reachability.connection != .unavailable else {
                  return
              }
        OperationImageAPIService.shared.startDownload(imagePath: viewModel.pizzaImgURL,
                                                      indexPath: indexPath,
                                                      successCallback: { [weak self] (image: UIImage?, imagePath: String) in
            guard let strongSelf = self else {
                return
            }
            
            var loadedImage: UIImage? = image
            if self?.viewModel?.pizzaImgURL != imagePath {
                loadedImage = nil
            }
            
            DispatchQueue.main.async {
                strongSelf.pizzaImage.image = loadedImage
                self?.pizzaImageLoadingIndicator.isHidden = loadedImage != nil
            }
        })
    }
}
