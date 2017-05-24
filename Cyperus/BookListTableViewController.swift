//
//  BookListTableViewController.swift
//  AppLabMobile
//
//  Created by André Luiz Rodrigues on 26/04/17.
//  Copyright © 2017 André Luiz Rodrigues. All rights reserved.
//

import UIKit

class BookListTableViewController: UITableViewController {
    
    var books: [BookContent] = []
    var epubs: [URL]!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        let a = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        print(a)
        listFiles()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! MainCell
        
        cell.bookTitle.text = books[indexPath.row].bookTitle
        cell.bookAuthor.text = books[indexPath.row].bookAuthor
        
        return cell
    }

    func listFiles(){
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            
            epubs = directoryContents.filter{ $0.pathExtension == "epub" }
            
            for book in epubs {
                books.append(BookContent(ebook: book))
                books.last?.loadPaths()
                books.last?.loadTitleAndChapters()
            }
            
        } catch {
            print("Deu ruim")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bookSelected" {
            
            let current = tableView.indexPathForSelectedRow?.row
            let view = segue.destination as! ChapterSelectionViewController
            let book = BookContent(ebook: epubs[current!])
            book.loadPaths()
            book.loadTitleAndChapters()
            view.book = book
        }
    }

}
