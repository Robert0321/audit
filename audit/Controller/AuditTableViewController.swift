//
//  AuditTableViewController.swift
//  audit
//
//  Created by LI,JYUN-SIAN on 27/5/23.
//

import UIKit

class AuditTableViewController: UITableViewController {
    
    var selectPhoto = false
    var items = [Item]() {
        didSet {
            Item.saveToFile(items: items)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = Item.readItemsFromFile() {
            self.items = items
        }
    }

    // MARK: - Table view data source
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AuditCell", for: indexPath) as? AuditTableViewCell else { return AuditTableViewCell()}
        
        if !items.isEmpty {
            cell.siteLabel.text = items[indexPath.row].site
            cell.dateLabel.text = items[indexPath.row].date
            cell.teamLabel.text = items[indexPath.row].team ?? ""
            if items[indexPath.row].ischeck {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            if let siteimage = items[indexPath.row].imageName {
                let imageUrl = Item.documentsDirectory.appendingPathComponent(siteimage).appendingPathExtension("jpg")
                let image = UIImage(contentsOfFile: imageUrl.path)
                cell.updateImage.image = image
            }
        }
        
        return cell
    }

  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? WriteTableViewController {
            if let row = tableView.indexPathForSelectedRow?.row {
                controller.item = items[row]
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .right)
        tableView.reloadData()
    }
    
    
    @IBAction func save(_ segue: UIStoryboardSegue) {
        
        if let sourceController = segue.source as? WriteTableViewController, let item = sourceController.item {
            
            if let indexPath = tableView.indexPathForSelectedRow {
                items[indexPath.row] = item
            } else {
                items.insert(item, at: 0)
                let indexPath = IndexPath(row: 0, section: 0)
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            tableView.reloadData()
            Item.saveToFile(items: items)
        }
    }
}
