//
//  APODModel.swift
//  DemoApp
//
//  Created by Apple on 23/10/2024.
//
import UIKit

class APODTableViewController: UITableViewController {
    
    private var viewModel: APODViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = APODViewModel()
        
        tableView.register(APODTableViewCell.self, forCellReuseIdentifier: "APODCell")
        
        viewModel.onDataFetched = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.fetchAPODs()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
    }
    
    // MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "APODCell", for: indexPath) as? APODTableViewCell else {
            return UITableViewCell()
        }
        
        let apod = viewModel.apod(at: indexPath.row)
        cell.titleLabel.text = apod.title

        if let imageURL = apod.url {
            cell.startLoading()
            
            if let cachedImage = ImageCacheManager.shared.getCachedImage(for: imageURL) {
                cell.stopLoading(with: cachedImage)
            } else {
                ImageCacheManager.shared.fetchImage(from: imageURL) { [weak self] image in
                    guard let self = self else { return }
                    
                    if let visibleIndexPath = self.tableView.indexPath(for: cell), visibleIndexPath == indexPath {
                        cell.stopLoading(with: image)
                    }
                }
            }
        } else {
            cell.stopLoading(with: nil)
        }
        
        if indexPath.row >= viewModel.numberOfItems() - 3 && !viewModel.isFetching {
            viewModel.fetchAPODs()
        }
        
        return cell
    }
}


