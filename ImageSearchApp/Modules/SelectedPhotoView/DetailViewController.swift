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
        self.configure()
    }
    
    func configure() {
        guard let url = URL(string: imageURl ?? "") else { return }
        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImg"))
    }

}
