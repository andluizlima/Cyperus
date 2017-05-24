//
//  SentenceListTableViewController.swift
//  AppLabMobile
//
//  Created by André Luiz Rodrigues on 28/04/17.
//  Copyright © 2017 André Luiz Rodrigues. All rights reserved.
//

import UIKit

class SentenceListTableViewController: UITableViewController {
    @IBOutlet weak var bookAndChapter: UILabel!
    
    var book: BookContent!
    var chapterPath: URL!
    var chapter: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        bookAndChapter.text = "\n" + chapter + "\n"
        bookAndChapter.sizeToFit()
        book.loadChapterText(path: chapterPath)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return book.chapterSentences.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "firstSentence", for: indexPath) as! FirstSentenceCellTableViewCell

        cell.sentenceTextLabel.text = book.chapterSentences[indexPath.row]

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToRead" {
            let current = tableView.indexPathForSelectedRow?.row
            let view = segue.destination as! ViewController
            view.book = book
            view.chapterName = chapter
            view.currentParagraph = current
        }
    }
}
