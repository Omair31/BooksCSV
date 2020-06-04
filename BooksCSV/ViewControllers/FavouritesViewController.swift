//
//  FavouritesViewController.swift
//  CountryApp
//
//  Created by Omeir on 25/05/2020.
//  Copyright © 2020 Omeir. All rights reserved.
//

import UIKit

class FavouritesViewController: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    
    var filteredBooksArray = [Book]()
    var isFavorite = true
    var isSameAuthor = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFavorite {
            NotificationCenter.default.addObserver(self, selector: #selector(handleFavoriteChanged), name: Notification.Name(rawValue: "favouriteChanged"), object: nil)
        } else {
            navigationItem.title = ""
        }
        setupTableData()
        // Do any additional setup after loading the view.
    }
    
    @objc func handleFavoriteChanged() {
        setupTableData()
    }
    
    func setupTableData() {
        if isFavorite {
            filteredBooksArray = Book.getAll()
        }
        tableView.reloadData()
    }

}


extension FavouritesViewController : UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredBooksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesCellId", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        cell.textLabel?.text = filteredBooksArray[indexPath.row].title
        cell.detailTextLabel?.text = filteredBooksArray[indexPath.row].authors
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookDetailVC = self.storyboard?.instantiateViewController(identifier: "BookDetailViewController") as! BookDetailViewController
        bookDetailVC.book = filteredBooksArray[indexPath.row]
        navigationController?.pushViewController(bookDetailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !isFavorite {
            if isSameAuthor {
                return ("Books by " + (filteredBooksArray.first?.authors ?? ""))
            } else {
                return ("Books with ratings ~ " + (filteredBooksArray.first?.averageRating ?? ""))
            }
        } else {
            return nil
        }
    }
}
