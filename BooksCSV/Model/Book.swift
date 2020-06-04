//
//  Book.swift
//  BooksCSV
//
//  Created by Omeir on 25/05/2020.
//  Copyright © 2020 Omeir. All rights reserved.
//

import Foundation
import RealmSwift

let myRealm = try! Realm()

class Book: Object {
    @objc dynamic var bookId:String?
    @objc dynamic var title:String?
    @objc dynamic var authors:String?
    @objc dynamic var averageRating:String?
    @objc dynamic var isbn:String?
    @objc dynamic var languageCode:String?
    @objc dynamic var numberOfPages:String?
    @objc dynamic var ratingsCount:String?
    @objc dynamic var textReviewsCount:String?
    @objc dynamic var publicationDate:String?
    @objc dynamic var publisher:String?
    @objc dynamic var isFavorited: Bool = false
    /*Optional(["bookID", "title", "authors", "average_rating", "isbn", "isbn13", "language_code", "num_pages", "ratings_count", "text_reviews_count", "publication_date", "publisher"])*/
    init(bookId:String, title:String, authors:String, averageRating:String, isbn:String , languageCode:String, numberOfPages:String, ratingsCount:String, textReviewsCount:String, publicationDate:String, publisher:String) {
        self.bookId = bookId
        self.title = title
        self.authors = authors
        self.averageRating = averageRating
        self.isbn = isbn
        self.languageCode = languageCode
        self.numberOfPages = numberOfPages
        self.ratingsCount = ratingsCount
        self.textReviewsCount = textReviewsCount
        self.publicationDate = publicationDate
        self.publisher = publisher
    }
    
    func writeToRealm(){
        try! myRealm.write {
            self.isFavorited = true
            myRealm.add(self)
        }
    }
    
    static func getAll() -> [Book] {
        let books = Array(myRealm.objects(Book.self)).filter({$0.isFavorited})
        return books
    }
    
    static func getBook(by bookId:String) -> Book? {
        guard let book = myRealm.objects(Book.self).filter({$0.bookId == bookId && $0.isFavorited}).first else {return nil}
        return book
    }
    
    static func delete(bookId:String) {
        try! myRealm.write {
            if let bookToDelete = Book.getBook(by: bookId) {
                bookToDelete.isFavorited = false
            }
        }
    }
    
    public required init() {
        super.init()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
