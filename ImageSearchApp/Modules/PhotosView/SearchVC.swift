//
//  ViewController.swift
//  ImageSearchApp
//
//  Created by Karan Jaiswal on 24/02/24.
//

import UIKit

class SearchVC: UIViewController, SearchViewModelDelegate {
    
    // MARK: - IB Outlets
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var nothingToShowView: UIView!
    
    // MARK: - Stored Properties
    var viewModel: SearchViewModelProtocol!
    var gridCount: Int = 2
    var searchWorkItem: DispatchWorkItem?
    var searchedText: String?
    var zoomingCellIndexPath: IndexPath? = nil
    
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
        nothingToShowView.isHidden = false
        viewModel.onDataFetchFailed = { [weak self] error in
            DispatchQueue.main.async {
                self?.imagesCollectionView.reloadData()
                self?.showAlert(message: error)
            }
        }
    }
    
    func didUpdateImageUrl() {
        nothingToShowView.isHidden = (searchedText?.count ?? 0 > 0)
        self.imagesCollectionView.reloadData()
    }
    
    func collectionViewSetup() {
        imagesCollectionView.dataSource = self
        imagesCollectionView.delegate = self
        let nib = UINib(nibName: AppConstants.CellIdentifiers.photoCollectionCell.baseString(), bundle: nil)
        imagesCollectionView.register(nib, forCellWithReuseIdentifier: AppConstants.CellIdentifiers.photoCollectionCell.baseString())
        imagesCollectionView.register(FooterLoaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: AppConstants.CellIdentifiers.footerLoaderView.baseString())
    }
    
    func navigationItemSetup() {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = AppConstants.AppStrings.seacrhBarPlaceholder.baseString()
        navigationItem.titleView = searchBar
        
        let rightButton = UIBarButtonItem(image: UIImage(systemName: AppImages.rightItemImage.baseString()), style: .plain, target: self, action: #selector(rightButtonTapped))
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItems = [rightButton]  }
    
    func showActionSheet() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: AppConstants.AppStrings.gridWithTwoColoumns.baseString(), style: .default) {_ in
            self.editGridCount(option: 2)
        }
        
        let action2 = UIAlertAction(title: AppConstants.AppStrings.gridWithThreeColoumns.baseString(), style: .default) {_ in
            self.editGridCount(option: 3)
        }
        
        let action3 = UIAlertAction(title: AppConstants.AppStrings.gridWithFourColoumns.baseString(), style: .default) {_ in
            self.editGridCount(option: 4)
        }
        
        let cancelAction = UIAlertAction(title: AppConstants.AppStrings.cancel.baseString(), style: .cancel) { _ in
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
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "No Images Found", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - ViewController Extension for Collection View Delegate
extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageUrl.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConstants.CellIdentifiers.photoCollectionCell.baseString(), for: indexPath) as! PhotoCollectionCell
        cell.configure(with: viewModel.imageUrl[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        UIView.animate(withDuration: 0.2, animations: {
            cell.transform = CGAffineTransform(scaleX: 3, y: 3)
            collectionView.bringSubviewToFront(cell)
        }) { _ in
            let sb = UIStoryboard(name: AppConstants.StoryboardName.main.baseString(), bundle: nil)
            if let vc = sb.instantiateViewController(withIdentifier: AppConstants.CellIdentifiers.detailViewController.baseString()) as? DetailViewController {
                vc.imageURl = self.viewModel.imageUrl[indexPath.item]
                self.navigationController?.pushViewController(vc, animated: false)
                cell.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item ==  self.viewModel.imageUrl.count - 1 {
            self.viewModel.fetchImages(searchText: searchedText ?? AppConstants.AppStrings.empty.baseString())
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
            let footerView = imagesCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: AppConstants.CellIdentifiers.footerLoaderView.baseString(), for: indexPath)
            return footerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        var height: CGFloat = 0
        if searchedText?.isEmpty ?? true && viewModel.imageUrl.isEmpty {
            height = 0
        } else {
            height = 150
        }
        return CGSize(width: collectionView.bounds.width, height: height)
    }
    
    
    
}

// MARK: - ViewController Extension for Search Bar Delegate
extension SearchVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchWorkItem?.cancel()
        searchedText = searchText
        
        let newSearch = DispatchWorkItem { [weak self] in
            self?.nothingToShowView.isHidden = true
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
@objc extension SearchVC {
    func rightButtonTapped() {
        showActionSheet()
    }
}
