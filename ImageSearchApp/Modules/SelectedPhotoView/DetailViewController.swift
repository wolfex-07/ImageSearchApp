//
//  DetailViewController.swift
//  ImageSearchApp
//
//  Created by Karan Jaiswal on 24/02/24.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imageURl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.imageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Call the zoom animation after a delay of 0.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now()) {
//            self.zoomImage()
        }
    }
    
    
    
    func configure() {
        guard let urlString = imageURl, let url = URL(string: urlString) else { return }
        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: AppImages.photosPlaceholder.baseString()))
    }
    
    func zoomOutImage() {
        UIView.animate(withDuration: 0.5) {
            self.imageView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }
    }

}

