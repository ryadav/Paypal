//
//  APODViewModel.swift
//  DemoApp
//
//  Created by Apple on 23/10/2024.
//

import Foundation
import UIKit

class APODViewModel {
    
    // MARK: - Properties
    private var apodService: APODService
    private var apodList: [APODModel] = []
    var currentPage: Int = 1
    var isFetching: Bool = false
    var onDataFetched: (() -> Void)?
    
    // MARK: - Initializer
    init(service: APODService = APODService()) {
        self.apodService = service
    }
    
    // MARK: - Fetch APODs (NASA Pictures)
    func fetchAPODs() {
        guard !isFetching else { return }
        isFetching = true
        
        let startDate = calculateDate(daysAgo: currentPage * 10)
        let endDate = calculateDate(daysAgo: (currentPage - 1) * 10)
        
        apodService.fetchPictures(startDate: startDate, endDate: endDate) { [weak self] apods in
            guard let self = self, let apods = apods else { return }
            
            self.apodList.append(contentsOf: apods.reversed())
            self.currentPage += 1
            self.isFetching = false
            
            DispatchQueue.main.async {
                self.onDataFetched?()
            }
        }
    }
    
    // MARK: - Calculate Date
    private func calculateDate(daysAgo: Int) -> String {
        let date = Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date())!
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    // MARK: - Data Binding Helpers
    func numberOfItems() -> Int {
        return apodList.count
    }
    
    func apod(at index: Int) -> APODModel {
        return apodList[index]
    }
}
