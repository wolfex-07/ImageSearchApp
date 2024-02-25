//
//  PhotoCollectionCell.swift
//  ImageSearchApp
//
//  Created by Karan Jaiswal on 24/02/24.
//

import UIKit
import SDWebImage

class PhotoCollectionCell: UICollectionViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - App lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Custom Methods
    
    func configure(with imageUrl: String?) {
        guard let url = URL(string: imageUrl ?? AppConstants.AppStrings.empty.baseString()) else { return }
        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: AppImages.photosPlaceholder.baseString()))
    }

}
