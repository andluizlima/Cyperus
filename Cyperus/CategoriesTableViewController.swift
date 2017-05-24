//
//  CategoriesTableViewController.swift
//  AppLabMobile
//
//  Created by André Luiz Rodrigues on 23/05/17.
//  Copyright © 2017 André Luiz Rodrigues. All rights reserved.
//

import UIKit

class CategoriesTableViewController: UITableViewController {

    let categories: [String] = ["Adventure", "Thriller", "Romance", "Novel", "Comedy", "Biography"].sorted()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
        
        cell.categoryName.text = categories[indexPath.row]
        
        return cell
    }
}
