//
//  ViewController.swift
//  Marshplay OMDB Client
//
//  Created by dominator on 07/01/20.
//  Copyright © 2020 dominator. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var loaderBottomContraint: NSLayoutConstraint!
    private lazy var datasource = makeDataSource()
    private lazy var viewModel = SearchViewModel()
    var loaderView: UIAlertController?
    let searchController = UISearchController(searchResultsController: nil)
    
    enum SegueIdentifiers: String{
        case toDetail
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Start to listen changes in viewmodel
        startObserving()
        setUI()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        setUI()
//    }
    
    func startObserving(){
        viewModel.didChangeStatus { status in
            switch status{
            case .loading:
                self.emptyCollection()
            case .error(let msg):
                self.emptyCollection()
                self.movieCollectionView.setEmptyStateMessage(msg)
            case .loaded(let results):
                self.movieCollectionView.restoreEmptyState()
                self.update(results)
            }
        }
    }
    
    func setUI(){
        //setting data source to diffable data source
        movieCollectionView.dataSource = datasource
        
        // MARK: Collection's layout
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        //to get the width of the device
        let width: CGFloat
        switch UIDevice.current.orientation {
        case .portrait,.portraitUpsideDown:
            width = UIScreen.main.bounds.width
        default:
            width = UIScreen.main.bounds.height
        }
        
        // 71 is calculated by adding all the constraint added in cell
        layout.itemSize = CGSize(width: width/2 - 15 , height: (width/2 - 15) + 71 )
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        movieCollectionView!.collectionViewLayout = layout
        movieCollectionView.delegate = self
        
        // MARK: Search field setup
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        //Setting default message
        movieCollectionView.setEmptyStateMessage("Search your favourite movie!")
        
        UIView.performWithoutAnimation {
            self.hidePageLoader()
        }
    }
    
    func update(_ records: [Record]){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Record>()
        if records.isEmpty{
            snapshot.deleteAllItems()
        }else{
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(records)
        }
        datasource.apply(snapshot)
    }
    
    func emptyCollection(_ setEmptyState: Bool = false){
        update([])
        if setEmptyState{
            movieCollectionView.setEmptyStateMessage("Search your favourite movie!")
        }
    }
    
    func showPageLoader(){
        loaderBottomContraint.constant = 50
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func hidePageLoader(){
        loaderBottomContraint.constant = -50
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.toDetail.rawValue{
            guard  let detailVC = segue.destination as? DetailViewController else { return }
            guard let record = sender as? Record else { return }
            detailVC.record = record
        }
    }
}

// MARK: Collection's Datasource
private extension SearchViewController{
    enum Section: CaseIterable{
        case main
    }
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Record> {
        return UICollectionViewDiffableDataSource(
            collectionView: movieCollectionView!,
            cellProvider: { collectionView, indexpath, record in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.reuseIdentifier, for: indexpath) as! MovieCollectionViewCell
                cell.titleLabel.text = record.title
                cell.yearLabel.text = record.ago
                cell.typeLabel.text = record.type
                cell.contentView.layer.cornerRadius = 5
                cell.contentView.layer.masksToBounds = true
                cell.posterImageView.downloadImageFrom(link: record.poster, contentMode: .scaleToFill)
                return cell
        })
    }
}

//MARK : Search handling
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else{return}
        //empty the collection when searchfield is empty
        if text.isEmpty{
            self.viewModel.reset()
            self.emptyCollection(true)
        }
    }
}


extension SearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else{return}
        if !text.isEmpty{
            if text != viewModel.searchText{
                viewModel.refresh(text: searchController.searchBar.text)
            }
        }else{
            self.emptyCollection(true)
        }
    }
}

extension SearchViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch viewModel.status {
        case .loaded(let results):
            let record = results[indexPath.row]
            self.performSegue(withIdentifier: SegueIdentifiers.toDetail.rawValue, sender: record)
        default:
            break
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch viewModel.status {
        case .loaded(let results):
            if indexPath.row == results.count - 1 && !viewModel.isLast{
                //loading next page of response
                showPageLoader()
                viewModel.getNextPage(){
                    DispatchQueue.main.async { self.hidePageLoader() }
                }
            }
        default:
            break
        }
    }
}
