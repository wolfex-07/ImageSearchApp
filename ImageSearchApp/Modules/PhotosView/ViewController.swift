//
//  ViewController.swift
//  ImageSearchApp
//
//  Created by Karan Jaiswal on 24/02/24.
//

import UIKit

class ViewController: UIViewController, SearchViewModelDelegate {
    
    // MARK: - IB Outlets
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    // MARK: - Stored Properties
    var viewModel: SearchViewModelProtocol!
    var gridCount: Int = 2
    var searchWorkItem: DispatchWorkItem?
    var searchedText: String?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SearchViewModel()
        initialSetup()
    }
    
    // MARK: - Custom Methods
    func initialSetup() {
        navigationItemSetup()
        collectionViewSetup()
        viewModel.delegate = self
    }
    
    func didUpdateImageUrl() {
        self.imagesCollectionView.reloadData()
    }
    
    func collectionViewSetup() {
        imagesCollectionView.dataSource = self
        imagesCollectionView.delegate = self
        let nib = UINib(nibName: "PhotoCollectionCell", bundle: nil)
        imagesCollectionView.register(nib, forCellWithReuseIdentifier: "PhotoCollectionCell")
        imagesCollectionView.register(FooterLoaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterLoaderView")
    }
    
    func navigationItemSetup() {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search anything here..."
        navigationItem.titleView = searchBar
        
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(rightButtonTapped))
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItems = [rightButton]  }
    
    func showActionSheet() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Grid - 2", style: .default) {_ in
            self.editGridCount(option: 2)
        }
        
        let action2 = UIAlertAction(title: "Grid - 3", style: .default) {_ in
            self.editGridCount(option: 3)
        }
        
        let action3 = UIAlertAction(title: "Grid - 4", style: .default) {_ in
            self.editGridCount(option: 4)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
        }
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func editGridCount(option: Int) {
        gridCount = option
        imagesCollectionView.reloadData()
    }
}

// MARK: - ViewController Extension for Collection View Delegate
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageUrl.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionCell", for: indexPath) as! PhotoCollectionCell
        cell.configure(with: viewModel.imageUrl[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        vc?.imageURl = self.viewModel.imageUrl[indexPath.item]
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("willDisplay ",indexPath.item)
        if indexPath.item ==  self.viewModel.imageUrl.count - 1 {
            self.viewModel.fetchImages(searchText: searchedText ?? "")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (imagesCollectionView.bounds.width - CGFloat((gridCount * 10) - 10)) / CGFloat(gridCount)
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footerView = imagesCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterLoaderView", for: indexPath)
            return footerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: self.viewModel.imageUrl.isEmpty ? 0 : 150)
    }
    
}

// MARK: - ViewController Extension for Search Bar Delegate
extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchWorkItem?.cancel()
        searchedText = searchText
        let newSearch = DispatchWorkItem { [weak self] in
            self?.viewModel.resetImageData()
            self?.viewModel.fetchImages(searchText: searchText)
        }
        searchWorkItem = newSearch
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: newSearch)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - ViewController Extension for @objc methods
@objc extension ViewController {
    func rightButtonTapped() {
        showActionSheet()
    }
}
