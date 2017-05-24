//
//  ViewController.swift
//  AppLabMobile
//
//  Created by André Luiz Rodrigues on 17/04/17.
//  Copyright © 2017 André Luiz Rodrigues. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var right: UIButton!
    @IBOutlet weak var left: UIButton!
    let abbreviations = ["Mr.", "Mrs.", "Dr.", "Mx.", "Ms.", "Sr.", "Sra.", "Srta.", "Dra."]

    @IBOutlet weak var fontSizeTextLabel: UILabel!
    @IBOutlet weak var fontSizeSlider: UISlider!
    @IBOutlet weak var nextChapterButton: UIButton!
    @IBOutlet weak var readingSpeedTextLabel: UILabel!
    @IBOutlet weak var readingSpeedLabel: UILabel!
    @IBOutlet weak var chapter: UILabel!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet var background: UIView!
    @IBOutlet weak var displayWord: UILabel!
    var currentWord = 0
    @IBOutlet weak var readingSpeedSlider: UISlider!
    @IBOutlet weak var fontSizeLabel: UILabel!
    
    var wordsAcceleratingCountdown = 10.0
    var accelerating = false
    var ableToRead = false
    var currentText: String!
    
    var currentParagraph: Int!
    var book: BookContent!
    var words: [String] = []
    var time = 0.15
    var wordsPerMinute = 400.0
    
    var chapterParagraphs: [String]!
    var chapterName: String!
    
    var doubleClick = [false, false]
    var buttonAlpha = [0.0, 0.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if book.bookTitle != nil {
            bookTitle.text = book.bookTitle
        }
        nextChapterButton.isHidden = true
        currentWord = 0
        currentText = book.chapterSentences[currentParagraph]
        chapter.text = chapterName
        bookTitle.sizeToFit()
        chapter.sizeToFit()
        words = book.chapterSentences[currentParagraph].components(separatedBy: " ")
        fontSizeLabel.text = String(Int(fontSizeSlider.value))
        readingSpeedSlider.value = 400
        readingSpeedSlider.isHidden = true
        readingSpeedLabel.isHidden = true
        confirmOptionsButton.isHidden = true
        readingSpeedTextLabel.isHidden = true
        fontSizeSlider.isHidden = true
        fontSizeLabel.isHidden = true
        fontSizeTextLabel.isHidden = true
        right.sizeToFit()
        left.sizeToFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func read() {
        time = 60/wordsPerMinute
        if accelerating{
            time += wordsAcceleratingCountdown/100
            wordsAcceleratingCountdown -= 1
            if wordsAcceleratingCountdown == 0 {
                accelerating = false
            }
        }
        if words.count <= currentWord {
            currentWord = 0
            currentParagraph! += 1
            if currentParagraph >= book.chapterSentences.count{
                displayWord.text = ""
                nextChapterButton.isHidden = false
                ableToRead = false
            } else {
                if !ableToRead {
                    ableToRead = true
                }
                words = book.chapterSentences[currentParagraph].components(separatedBy: " ")
            }
        } else {
            if words[currentWord].characters.count > 9{
                time *= Double(words[currentWord].characters.count)/4
            }
            self.displayWord.text = self.words[currentWord]
            if (words[currentWord].contains(".") && !abbreviations.contains(words[currentWord])) ||
                words[currentWord].contains("?") || words[currentWord].contains("!") ||
                words[currentWord].contains(";") || words[currentWord].contains(":") {
                time *= 2.6
            } else if words[currentWord].contains(",") || words[currentWord].contains("\"") ||
                words[currentWord].contains("\'") {
                time *= 2
            }
            currentWord += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: {
            if self.ableToRead{
                self.read()
            }
        })
    }
    
    @IBOutlet weak var readingOptionsButton: UIButton!
    
    func changeValueForBooleans(){
        readingOptionsButton.isHidden = !readingOptionsButton.isHidden
        readingSpeedSlider.isHidden = !readingSpeedSlider.isHidden
        readingSpeedLabel.isHidden = !readingSpeedLabel.isHidden
        confirmOptionsButton.isHidden = !confirmOptionsButton.isHidden
        readingSpeedTextLabel.isHidden = !readingSpeedTextLabel.isHidden
        fontSizeSlider.isHidden = !fontSizeSlider.isHidden
        fontSizeLabel.isHidden = !fontSizeLabel.isHidden
        fontSizeTextLabel.isHidden = !fontSizeTextLabel.isHidden
        startStopButton.isHidden = !startStopButton.isHidden
        
    }
    
    @IBAction func readingOptions(_ sender: Any) {
        readingSpeedLabel.text = String(Int(readingSpeedSlider.value)) + " words per minute"
        ableToRead = false
        changeValueForBooleans()
    }
    
    @IBOutlet weak var confirmOptionsButton: UIButton!
    
    @IBAction func confirmOptions(_ sender: Any) {
        wordsPerMinute = Double(readingSpeedSlider.value)
        changeValueForBooleans()
    }
    
    @IBAction func fontSlider(_ sender: Any) {
        fontSizeLabel.text = String(Int(fontSizeSlider.value))
        displayWord.font = displayWord.font.withSize(CGFloat(Float(Int(fontSizeSlider.value))))
        
    }
    @IBAction func sliderAction(_ sender: Any) {
        readingSpeedLabel.text = String(Int(readingSpeedSlider.value)) + " words per minute"
        readingSpeedLabel.sizeToFit()
    }
    @IBOutlet weak var startStopButton: UIButton!

    @IBAction func startStop(_ sender: Any) {
        ableToRead = !ableToRead
        if ableToRead {
            wordsAcceleratingCountdown = 10.0
            accelerating = true
            read()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "returnToChapters"{
            let view = segue.destination as! ChapterSelectionViewController
            view.book = book
        }
    }
    
    func updateAlpha(dir: Int, button: UIButton){
        buttonAlpha[dir] -= 0.05
        button.alpha = CGFloat(Float(buttonAlpha[button.tag - 25]))
        if buttonAlpha[dir] > 0.0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.02, execute: {
                self.updateAlpha(dir: dir, button: button)
            })
        }
        else{
            button.alpha = CGFloat(Float(0.02))
        }
    }
    
    @IBAction func buttonClick(_ sender: Any) {
        let button = sender as! UIButton
        print(currentWord)
        print(currentParagraph)
        ableToRead = false
        
        
        if doubleClick.contains(true){
            currentWord = 0
            if doubleClick[0] {
                currentParagraph! -= 1
                if currentParagraph < 0 {
                    currentParagraph = 0
                } else {
                    words = book.chapterSentences[currentParagraph].components(separatedBy: " ")
                }
            } else {
                currentParagraph! += 1
                if currentParagraph >= book.chapterSentences.count {
                    displayWord.text = ""
                    nextChapterButton.isHidden = false
                } else {
                    words = book.chapterSentences[currentParagraph].components(separatedBy: " ")
                }
            }
        } else {
            if button.tag == 25 {
                currentWord -= 1
                if currentWord < 0 {
                    currentParagraph! -= 1
                    if currentParagraph < 0 {
                        currentWord = 0
                        currentParagraph = 0
                    } else {
                        words = book.chapterSentences[currentParagraph].components(separatedBy: " ")
                        currentWord = words.count - 1
                        if currentWord < 0 {
                            currentWord = 0
                        }
                    }
                }
            } else {
                currentWord += 1
                if currentWord >= words.count {
                    currentParagraph! += 1
                    if currentParagraph >= book.chapterSentences.count {
                        displayWord.text = ""
                        nextChapterButton.isHidden = false
                    } else {
                        currentWord = 0
                        words = book.chapterSentences[currentParagraph].components(separatedBy: " ")
                    }
                }
            }
            doubleClick[button.tag - 25] = true
        }
        
        if currentWord >= 0 && currentWord < words.count &&
            currentParagraph >= 0 && currentParagraph < book.chapterSentences.count {
            displayWord.text = words[currentWord]
        }
        

        buttonAlpha[button.tag - 25] = 0.6
        button.alpha = CGFloat(Float(buttonAlpha[button.tag - 25]))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.24, execute: {
            self.doubleClick[button.tag - 25] = false
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02, execute: {
            self.updateAlpha(dir: button.tag - 25, button: button)
        })
        
    }
    
}

