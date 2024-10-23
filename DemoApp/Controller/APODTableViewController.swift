//
//  APODModel.swift
//  DemoApp
//
//  Created by Apple on 23/10/2024.
//
import UIKit

class APODTableViewController: UITableViewController {
    
    // ViewModel instance
    private var viewModel: APODViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize ViewModel
        viewModel = APODViewModel()
        
        // Register the custom cell
        tableView.register(APODTableViewCell.self, forCellReuseIdentifier: "APODCell")
        
        // Bind ViewModel data fetch callback
        viewModel.onDataFetched = { [weak self] in
            self?.tableView.reloadData()
        }
        
        // Fetch initial data
        viewModel.fetchAPODs()
        
        // Setup row height
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

        // If hdurl is nil, set a placeholder image or nil to show no image
        if let imageURL = apod.url {
            // Start loading indicator
            cell.startLoading()
            
            // Check the cache first
            if let cachedImage = ImageCacheManager.shared.getCachedImage(for: imageURL) {
                // If the image is cached, use it directly and stop the loader
                cell.stopLoading(with: cachedImage)
            } else {
                // Fetch image asynchronously and update the cell if it's still visible
                let currentIndexPath = indexPath
                ImageCacheManager.shared.fetchImage(from: imageURL) { [weak self] image in
                    guard let self = self else { return }
                    
                    // Ensure the cell hasn't been reused
                    if let visibleIndexPath = self.tableView.indexPath(for: cell), visibleIndexPath == currentIndexPath {
                        // Stop the loading indicator and set the image
                        cell.stopLoading(with: image)
                    }
                }
            }
        } else {
            // If no image URL, show no image or a default placeholder and stop loading
            cell.stopLoading(with: nil)
        }
        
        // Load more data when reaching the end of the list
        if indexPath.row == viewModel.numberOfItems() - 1 {
            viewModel.fetchAPODs()
        }
        
        return cell
    }
}


