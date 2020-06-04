//
//  BookDetailViewController.swift
//  BooksCSV
//
//  Created by Omeir on 25/05/2020.
//  Copyright © 2020 Omeir. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {
    
    var book:Book!
    
    var sameAuthorBooks = [Book]()
    var similarRatingBooks = [Book]()

    fileprivate func setupFavButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "unfavourite"), style: .plain, target: self, action: #selector(toggleFavourite))
        if let _ = Book.getBook(by: book.bookId!) {
            navigationItem.rightBarButtonItem?.image = UIImage(named: "favourite")
        } else {
            navigationItem.rightBarButtonItem?.image = UIImage(named: "unfavourite")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Book Detail"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFavButton()
    }
    
    @objc func toggleFavourite(sender:UIBarButtonItem) {
        
        if sender.image == UIImage(named: "unfavourite") {
            book.writeToRealm()
        } else {
            Book.delete(bookId: book.bookId!)
        }
        
        sender.image = sender.image == UIImage(named: "unfavourite") ? UIImage(named: "favourite") : UIImage(named: "unfavourite")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "favouriteChanged"), object: nil)
        
    }

}

extension BookDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 8 {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCellId", for: indexPath)
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.numberOfLines = 0
        cell.isUserInteractionEnabled = false
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = book.title
        case 1:
            cell.textLabel?.text = book.authors
        case 2:
            cell.textLabel?.text = book.averageRating
        case 3:
            cell.textLabel?.text = book.languageCode?.uppercased()
        case 4:
            cell.textLabel?.text = book.numberOfPages
        case 5:
            cell.textLabel?.text = book.textReviewsCount
        case 6:
            cell.textLabel?.text = book.publisher
        case 7:
            cell.textLabel?.text = book.publicationDate
        case 8:
            cell.isUserInteractionEnabled = true
            if indexPath.row == 0 {
                cell.textLabel?.text = "Recommendation by same author"
            }
            if indexPath.row == 1 {
                cell.textLabel?.text = "Recommendation by similar ratings"
            }
            cell.textLabel?.textColor = UIColor.systemBlue
        default:
            break
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if sameAuthorBooks.isEmpty {
            return 8
        }
        return 9
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Book Title"
        case 1:
            return "Author"
        case 2:
            return "Ratings"
        case 3:
            return "Language"
        case 4:
            return "Pages"
        case 5:
            return "Review Count"
        case 6:
            return "Publisher"
        case 7:
            return "Publication Date"
        default:
            return "Recommendations"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favouritesViewController = self.storyboard?.instantiateViewController(identifier: "FavouritesViewController") as! FavouritesViewController
        favouritesViewController.isFavorite = false
        if indexPath.row == 0 {
            favouritesViewController.filteredBooksArray = sameAuthorBooks
            favouritesViewController.isSameAuthor = true
        }
        if indexPath.row == 1 {
           favouritesViewController.filteredBooksArray = similarRatingBooks
        }
        navigationController?.pushViewController(favouritesViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
