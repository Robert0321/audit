//
//  WriteTableViewController.swift
//  audit
//
//  Created by LI,JYUN-SIAN on 27/5/23.
//

import UIKit

class WriteTableViewController: UITableViewController, UINavigationControllerDelegate {
    //宣告屬性item，告入這頁，從前一頁傳過來
    var item: Item?
    //宣告目前無照片
    var selectPhoto = false

    @IBOutlet weak var noYesSwitch: UISwitch!
    @IBOutlet weak var updateImage: UIImageView!
    @IBOutlet weak var siteTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var teamTextField: UITextView!
    @IBOutlet weak var commentsTextField: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentsTextField.layer.borderWidth = 0.3
//        commentsTextField.layer.opacity = 0.5
        commentsTextField.layer.cornerRadius = 8.0
        teamTextField.layer.borderWidth = 0.3
//        teamTextField.layer.opacity = 0.5
        teamTextField.layer.cornerRadius = 8.0
        updateUI()
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
    }
    
    func updateUI() {
        if let item = item {
            siteTextField.text = item.site
            noYesSwitch.isOn = item.ischeck
            if let imageName = item.imageName {
                let imageUrl = Item.documentsDirectory.appendingPathComponent(imageName).appendingPathExtension("jpg")
                let image = UIImage(contentsOfFile: imageUrl.path)
                updateImage.image = image
            }
            //
            if item.date != nil {
                dateTextField.text = String(item.date!)
            }
            commentsTextField.text = item.Comments ?? ""
            teamTextField.text = item.team ?? ""
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let source = segue.source as? WriteTableViewController {
            let site = source.siteTextField.text!
            let noYes = source.noYesSwitch.isOn
            let comments = source.commentsTextField.text ?? ""
            let date = source.dateTextField.text ?? ""
            var imageName: String?
            let team = source.teamTextField.text ?? ""
            
            if selectPhoto {
                if let item = item {
                    imageName = item.imageName
                }
                if imageName == nil {
                    imageName = UUID().uuidString
                }
                let imageData = updateImage.image?.jpegData(compressionQuality: 0.9)
                let imageUrl = Item.documentsDirectory.appendingPathComponent(imageName!).appendingPathExtension("jpg")
                try? imageData?.write(to: imageUrl)
                selectPhoto = false
            } else {
                if let item = item {
                    imageName = item.imageName
                }
            }
            
            item = Item(imageName: imageName, ischeck: noYes, site: site, date: date, team: team, Comments: comments)
        }
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if siteTextField.text?.isEmpty == true {
            let controller = UIAlertController(title: "please type...", message: nil, preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK", style: .default))
            present(controller, animated: true)
            return false
        } else {
            return true
        }
    }
    
    @IBAction func addImage(_ sender: Any) {
        
        let controller = UIImagePickerController()
        controller.delegate = self
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Photo", style: .default, handler: { action in
            controller.sourceType = .photoLibrary
            self.present(controller, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            controller.sourceType = .camera
            self.present(controller, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}

extension WriteTableViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        updateImage.image = image
        selectPhoto = true
        dismiss(animated: true)
    }
}


