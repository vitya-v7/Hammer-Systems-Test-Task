//
//  ImageDownloadOperation.swift
//  Hammer-Systems-Test-Task
//
//  Created by Admin on 27.10.2022.
//

import Foundation
import UIKit

final class ImageDownloadOperation: Operation {

	let imagePath: String
	var image: UIImage?
    
	init(_ imagePath: String) {
		self.imagePath = imagePath
	}

	override func main() {

		if isCancelled {
			return
		}
		var imageData: Data?
        if let url = URL(string: self.imagePath) {
			imageData = try? Data(contentsOf: url)
		}
		if isCancelled {
			return
		}

		if let imageData = imageData, !imageData.isEmpty {
			image = UIImage(data: imageData)
		}
	}
}
