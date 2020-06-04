//
//  ViewController.swift
//  BooksCSV
//
//  Created by Omeir on 22/05/2020.
//  Copyright © 2020 Omeir. All rights reserved.
//

import UIKit
import Combine
import RealmSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    private var cancelable: AnyCancellable?
    var ss = Set<AnyCancellable>()
    var masterBooksArray = [Book]()
    var filteredBooksArray = [Book]()
    static var allBooks = [Book]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let csvData = readDataFromCSV(fileName: "books", fileType: "csv")
        var rows = csv(data: csvData ?? "")
        setupTableData(&rows)
        let publisher = NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchController.searchBar.searchTextField)
        publisher
            .map {
            ($0.object as! UISearchTextField).text ?? ""
        }
            .debounce(for: .milliseconds(2), scheduler: RunLoop.main)
            .sink { (str) in
                print(str)
                if str.isEmpty {
                    self.filteredBooksArray = self.masterBooksArray
                } else {
                    self.filteredBooksArray = self.masterBooksArray.filter({($0.title?.lowercased().contains(str.lowercased()) ?? false) || ($0.authors?.lowercased().contains(str.lowercased()) ?? false)})
                }
                self.tableView.reloadData()
        }.store(in: &ss)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sort By Title", style: .plain, target: self, action: #selector(sortBooksByTitle))
    }
    
    static func getAllBooks() -> [Book] {
        allBooks
    }
    
    @objc func sortBooksByTitle() {
        DispatchQueue.global().async {
            self.masterBooksArray.sort(by: {$0.title?.lowercased() ?? "" < $1.title?.lowercased() ?? ""})
            self.filteredBooksArray = self.masterBooksArray
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    
    fileprivate func setupTableData(_ rows: inout [[String]]) {
        rows.removeFirst()
        rows.removeLast()
        rows.forEach { (row) in
            let book = Book(bookId: row[0], title: row[1], authors: row[2], averageRating: row[3], isbn: row[4], languageCode: row[6], numberOfPages: row[7], ratingsCount: row[8], textReviewsCount: row[9], publicationDate: row[10], publisher: row[11])
            masterBooksArray.append(book)
        }
        filteredBooksArray = masterBooksArray
        ViewController.allBooks = masterBooksArray
        tableView.reloadData()
    }
    
    func readDataFromCSV(fileName:String, fileType: String)-> String!{
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
            else {
                return nil
        }
        do {
            var contents = try String(contentsOfFile: filepath, encoding: .utf8)
            contents = cleanRows(file: contents)
            return contents
        } catch {
            print("File Read Error for file \(filepath)")
            return nil
        }
    }
    
    func cleanRows(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
    }
    
    func csv(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ",")
            result.append(columns)
        }
        return result
    }


}

extension ViewController : UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredBooksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        cell.textLabel?.text = filteredBooksArray[indexPath.row].title
        cell.detailTextLabel?.text = filteredBooksArray[indexPath.row].authors
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookDetailVC = self.storyboard?.instantiateViewController(identifier: "BookDetailViewController") as! BookDetailViewController
        let selectedBook = filteredBooksArray[indexPath.row]
        bookDetailVC.book = selectedBook
        bookDetailVC.similarRatingBooks = masterBooksArray.filter({$0.averageRating == selectedBook.averageRating})
        bookDetailVC.sameAuthorBooks = masterBooksArray.filter({$0.authors == selectedBook.authors})
        navigationController?.pushViewController(bookDetailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.filteredBooksArray = self.masterBooksArray
        tableView.reloadData()
    }
    
}
