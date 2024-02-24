//
//  PhotoCollectionCell.swift
//  ImageSearchApp
//
//  Created by Karan Jaiswal on 24/02/24.
//

import UIKit
import SDWebImage

class PhotoCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with imageUrl: String?) {
        guard let url = URL(string: imageUrl ?? "") else { return }
        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImg"))
    }

}
