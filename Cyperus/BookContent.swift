//
//  BookContent.swift
//  AppLabMobile
//
//  Created by André Luiz Rodrigues on 21/04/17.
//  Copyright © 2017 André Luiz Rodrigues. All rights reserved.
//

import UIKit
import Zip

class BookContent: NSObject {
    var bookTitle: String!
    var bookChapters: [String] = []
    var bookChaptersPaths: [String] = []
    var bookAuthor: String!
    var chapterSentences: [String]!
    
    var rootFolder: URL!
    var containerFile: URL!
    var opfFile: URL!
    var tocFile: URL!
    var ebook: URL!
    
    var tocFilePath: String!
    var opfFilePath: String!
    
    // Loads the main files
    init(ebook: URL) {
        
        rootFolder = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        self.ebook = ebook
    }
    
    func loadPaths(){
        do {
            
            Zip.addCustomFileExtension("epub")
            
            try Zip.unzipFile(ebook, destination: rootFolder.appendingPathComponent("Current"), overwrite: true, password: nil, progress: nil)
            
            ebook = rootFolder.appendingPathComponent("Current/")
            containerFile = ebook.appendingPathComponent("META-INF/container").appendingPathExtension("xml")
            
            do {
                var content = try String(contentsOf: containerFile)
                var lines = content.components(separatedBy: "<")
                var line = 0
                while !lines[line].contains("rootfile") || lines[line].contains("rootfiles>")   {
                    line+=1
                }
                var itens = lines[line].components(separatedBy: " ")
                line = 0
                while !itens[line].contains(".opf") {
                    line+=1
                }
                opfFilePath = itens[line]
                var pathA = [Character](opfFilePath.characters)
                while pathA[0] != "\"" {
                    pathA.remove(at: 0)
                }
                pathA.remove(at: 0)
                pathA.remove(at: pathA.count-1)
                opfFilePath = ""
                opfFilePath = String(pathA)
                
                do {
                    opfFile = ebook.appendingPathComponent(opfFilePath)
                    content = try String(contentsOf: opfFile)
                    lines = content.components(separatedBy: "<")
                    line = 0
                    while line < lines.count{
                        if lines[line].contains("dc:creator") && !lines[line].contains("/dc:creator"){
                            let name = lines[line].components(separatedBy: ">")
                            if bookAuthor == nil{
                                bookAuthor = name[1]
                            } else {
                                bookAuthor.append(" & " + name[1])
                            }
                        }
                        line += 1
                    }
                    line = 0
                    while !lines[line].contains(".ncx")   {
                        line+=1
                    }
                    itens = lines[line].components(separatedBy: " ")
                    line = 0
                    while !itens[line].contains(".ncx") {
                        line+=1
                    }
                    tocFilePath = itens[line]
                    pathA = [Character](tocFilePath.characters)
                    while pathA[0] != "\"" {
                        pathA.remove(at: 0)
                    }
                    pathA.remove(at: 0)
                    pathA.remove(at: pathA.count-1)
                    tocFilePath = ""
                    tocFilePath = String(pathA)
                    
                    var opfFolder = [Character](opfFilePath.characters)
                    
                    while opfFolder.count > 0 && opfFolder[opfFolder.count - 1] != "/" {
                        opfFolder.remove(at: opfFolder.count - 1)
                    }
                    
                    tocFilePath = String(opfFolder) + tocFilePath
                    tocFile = ebook.appendingPathComponent(tocFilePath)
                    
                } catch {
                    print("Tretou")
                }
                
            } catch {
                print("Zicou 2")
            }
        } catch {
            print("Zicou 1")
        }
    }
    
    
    func loadTitleAndChapters(){
            if tocFilePath != nil{
                let localArq = try! ebook.appendingPathComponent(tocFilePath)
                do {
                    let data = try String(contentsOf: localArq)
                    let elements = data.components(separatedBy: "<")
                    var i = 0
                    while i < elements.count {
                        if elements[i].contains("docTitle>") && !elements[i].contains("/") {
                            while i<elements.count && !elements[i].contains("text>") {
                                i += 1
                            }
                            bookTitle = elements[i].replacingOccurrences(of: "text>", with: "")
                            let endIndex = bookTitle.index(bookTitle.endIndex, offsetBy: 0)
                            bookTitle = bookTitle.substring(to: endIndex)
                        } else if elements[i].contains("navLabel>") && !elements[i].contains("/")  {
                            while i<elements.count && !elements[i].contains("text>") {
                                i += 1
                            }
                            bookChapters.append(elements[i].replacingOccurrences(of: "text>", with: ""))
                            let endIndex = bookChapters[bookChapters.count-1].index(bookChapters[bookChapters.count-1].endIndex, offsetBy: 0)
                            bookChapters[bookChapters.count-1] = bookChapters[bookChapters.count-1].substring(to: endIndex)
                        } else if elements[i].contains("content src=\"") {
                            
                            bookChaptersPaths.append(elements[i].replacingOccurrences(of: "content src=\"", with: ""))
                            
                            bookChaptersPaths[bookChaptersPaths.count-1] = bookChaptersPaths[bookChaptersPaths.count-1].replacingOccurrences(of: "\"/>", with: "")
                            
                            var path = bookChaptersPaths[bookChaptersPaths.count - 1].components(separatedBy: "html")
                            path[0].append("html")
                            bookChaptersPaths[bookChaptersPaths.count-1] = path[0]
                        }
                        i += 1
                    }
                } catch {
                    print("Deu xibu")
                }
            }
    }
    
    func loadChapterText(path: URL) {
        
        do {
            let fullText = try String(contentsOf: path)
            var elements = fullText.components(separatedBy: "</head>")
            elements[1] = elements[1].replacingOccurrences(of: "(?i)</?\\b[^<]*>", with: "", options: .regularExpression, range: nil)
            let aux = elements[1].components(separatedBy: "\n")
            chapterSentences = []
            for sentence in aux{
                if !sentence.isEmpty && !(sentence.replacingOccurrences(of: " ", with: "") == "") {
                    chapterSentences.append(sentence)
                }
            }
        } catch {
            print("Deu xibu")
        }
    }
    
    func loadBasic() {
        loadPaths()
        loadTitleAndChapters()
    }
}
