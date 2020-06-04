//
//  BarChartViewController.swift
//  CountryApp
//
//  Created by Omeir on 26/05/2020.
//  Copyright © 2020 Omeir. All rights reserved.
//

import UIKit
import Charts

enum HighRecommendationType {
    case books, authors
}

class BarViewController: UIViewController {
    
    @IBOutlet weak var chartView:BarChartView!
    @IBOutlet weak var yAxisLabel: UILabel!
    var navBarTitle:String?
    var highRatedBooksForGraphs = [String]()
    var ratingsForGraphs = [String]()
    var recommendationType:HighRecommendationType!
    
    fileprivate func setupChartView(_ topHighRatedBooks: Array<Book>.SubSequence) {
        
        if recommendationType == .books {
            for i in stride(from: 0, to: 199, by: 20) {
                self.highRatedBooksForGraphs.append(topHighRatedBooks[i].title ?? "")
                self.ratingsForGraphs.append(topHighRatedBooks[i].averageRating ?? "")
                yAxisLabel.text = "Book Ratings"
            }
        } else if recommendationType == .authors {
            for i in stride(from: 0, to: 199, by: 20) {
                self.highRatedBooksForGraphs.append(topHighRatedBooks[i].authors ?? "")
                self.ratingsForGraphs.append(topHighRatedBooks[i].ratingsCount ?? "")
                yAxisLabel.text = "Review Count"
            }
        }
        
        
        var dataEntries: [BarChartDataEntry] = []
        
        self.ratingsForGraphs.enumerated().forEach { (item,element) in
            let dd = BarChartDataEntry(x: Double(item) + 1, y: Double(element) ?? 0)
            dataEntries.append(dd)
        }
        
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: nil)
        
        chartDataSet.colors = ChartColorTemplates.colorful()
        let chartData = BarChartData(dataSet: chartDataSet)
        self.chartView.data = chartData
        self.chartView.xAxis.labelPosition = .bottomInside
        self.chartView.animate(xAxisDuration: 1, yAxisDuration: 1)
        self.addLegends()
    }
    
    var allBooks = [Book]()
    var highRatedBooks = [Book]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = navBarTitle
        
        
        allBooks = ViewController.getAllBooks()
        yAxisLabel.transform = CGAffineTransform(rotationAngle: (-1 * .pi/2)).translatedBy(x: 0, y: -20)
        if recommendationType == .books {
            highRatedBooks = allBooks.sorted(by: { Double($0.averageRating ?? "0") ?? 0 > Double($1.averageRating ?? "0") ?? 0 })
        } else {
            highRatedBooks = allBooks.sorted(by: { Double($0.textReviewsCount ?? "0") ?? 0 > Double($1.textReviewsCount ?? "0") ?? 0 })
        }
        
        let topHighRatedBooks = highRatedBooks[0...199]
        
        
        setupChartView(topHighRatedBooks)
    }
    
    
    func addLegends() {
        var labels = [UILabel]()
        highRatedBooksForGraphs.enumerated().forEach { (index,book) in
            let label = UILabel()
            label.text = "#\(index + 1) \(book)"
            label.font = UIFont.boldSystemFont(ofSize: 14)
            label.numberOfLines = 0
            labels.append(label)
            label.textColor = ChartColorTemplates.colorful()[index % 5]
        }
        
        let stackView = UIStackView(arrangedSubviews: labels)
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5).isActive = true
    }
    
}
