//
//  LoadingIndicator.swift
//  ImageSearchApp
//
//  Created by Karan Jaiswal on 25/02/24.
//

import Foundation
import UIKit

class LoadingIndicator {
    static let shared = LoadingIndicator()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .white
        indicator.startAnimating()
        return indicator
    }()
    
    private init() {
        guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        keyWindow.addSubview(overlayView)
        overlayView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            overlayView.leadingAnchor.constraint(equalTo: keyWindow.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: keyWindow.trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: keyWindow.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: keyWindow.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor)
        ])
        
        overlayView.isHidden = true
    }
    
    func show() {
        DispatchQueue.main.async { [weak self] in
            self?.overlayView.isHidden = false
        }
    }
    
    func hide() {
        DispatchQueue.main.async { [weak self] in
            self?.overlayView.isHidden = true
        }
    }
}
