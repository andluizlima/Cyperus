//
//  ChapterSelectionViewController.swift
//  AppLabMobile
//
//  Created by André Luiz Rodrigues on 24/04/17.
//  Copyright © 2017 André Luiz Rodrigues. All rights reserved.
//

import UIKit

class ChapterSelectionViewController: UIViewController {
    
    @IBOutlet weak var c110: UIStackView!
    @IBOutlet weak var c15: UIStackView!
    @IBOutlet weak var c610: UIStackView!
    
    @IBOutlet weak var bookTitle: UILabel!
    
    @IBOutlet weak var backChap: UIButton!
    @IBOutlet weak var forwardChap: UIButton!
    @IBOutlet weak var currentChap: UILabel!
    
    @IBOutlet weak var chaptersLabel: UILabel!

    @IBOutlet weak var chaptersField: UIStackView!
    
    var book: BookContent!
    var chapters: [[String]] = []
    var page = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookTitle.text = book.bookTitle
        loadChapterButtons()
        fillChapterButtons()
        chaptersField.sizeToFit()
        organizeChapters()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        organizeChapters()
    }
    
    func fillChapterButtons() {
        for i in (page * 10)...(10 +  page * 10) {
            if let button = self.view.viewWithTag(i + 1 - (page * 10)) as? UIButton{
                if i >= chapters.count{
                    button.setTitle("", for: UIControlState.normal)
                    button.isEnabled = false
                } else {
                    button.isEnabled = true
                    button.setTitle(chapters[i][0], for: UIControlState.normal)
                }
            }
        }
        var last1 = 10, last2 = 10
        if page * 10 + 10 > chapters.count {
            last1 = chapters.count - (page * 10)
        }
        if page * 10 + 20 > chapters.count {
            last2 = chapters.count - (page * 10)
        }
        
        if page == 0 {
            backChap.setTitle(" ", for: UIControlState.normal)
            backChap.isEnabled = false
        } else {
            backChap.isEnabled = true
            backChap.setTitle("\(page * 10 - 9)-\(page * 10)", for: UIControlState.normal)
        }
        if page * 10 + 10 >= chapters.count {
            forwardChap.isEnabled = false
            forwardChap.setTitle(" ", for: UIControlState.normal)
        } else {
            forwardChap.isEnabled = true
            forwardChap.setTitle("\(page * 10 + 11)-\(page * 10 + last2)", for: UIControlState.normal)
        }
        
        currentChap.text = "\(page * 10 + 1)-\(page * 10 + last1)"
    }
    
    func loadChapterButtons() {
        
        for i in 0...book.bookChapters.count - 1 {
            chapters.append([book.bookChapters[i], book.bookChaptersPaths[i]])
        }
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        organizeChapters()
    }
    
    @IBAction func lessChap(_ sender: Any) {
        page-=1
        fillChapterButtons()
    }
    
    @IBAction func moreChap(_ sender: Any) {
        page+=1
        fillChapterButtons()
    }
    
    @IBAction func chapterButton(sender: Any) {
        let button = sender as! UIButton
        
        performSegue(withIdentifier: "chapterSelected", sender: button)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chapterSelected"{
            let view = segue.destination as! SentenceListTableViewController
            let button = sender as! UIButton
            view.book = book
            
            var pathC = [Character](book.opfFile.absoluteString.characters)
            
            while pathC[pathC.count - 1] != "/" {
                pathC.removeLast()
            }
            
            let rootPath = URL(string: String(pathC))
            
            let path: URL = try! rootPath!.appendingPathComponent(chapters[button.tag - 1 + (10 * page)][1])
            view.chapterPath = path
            view.chapter = chapters[button.tag - 1 + (10 * page)][0]
        }
    }
    
    func organizeChapters(){
        switch UIDevice.current.orientation{
        case .portrait:
            c110.axis = .vertical
            break
        case .landscapeLeft:
            c110.axis = .horizontal
            break
        case .landscapeRight:
            c110.axis = .horizontal
            break
        default:
            c110.axis = .vertical
            break
        }
        c110.sizeToFit()
    }
}
