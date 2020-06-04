//
//  RatingsViewController.swift
//  BooksCSV
//
//  Created by Omeir on 25/05/2020.
//  Copyright © 2020 Omeir. All rights reserved.
//

import UIKit

class RatingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var options = ["High Rated Books" , "High Rated Authors"]
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Ratings"
    }

}

extension RatingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ratingCellId", for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let barChartViewController = self.storyboard?.instantiateViewController(identifier: "BarViewController") as! BarViewController
        barChartViewController.navBarTitle = options[indexPath.row]
        barChartViewController.recommendationType = indexPath.row == 0 ? .books : .authors
        navigationController?.pushViewController(barChartViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
