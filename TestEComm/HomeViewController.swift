//
//  HomeViewController.swift
//  TestEComm
//
//  Created by Tushar Indi on 06/09/19.
//  Copyright © 2019 Tushar Indi. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView : UITableView!
    
    let databaseManager = DatabaseManager()
    
    var tableData : [NSManagedObject] = []
    var selectedData : NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Ads"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(self.btnCreatePressed))
        
        tableData = databaseManager.getAds();
        tableView.reloadData();
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "homeToDetail") {
            let destinationVC = segue.destination as! DisplayAdViewController
            destinationVC.carDetails = selectedData
        }
    }
    
    @objc func btnCreatePressed() {
        print("Create pressed")
        self.performSegue(withIdentifier: "homeToCreate", sender: self)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adListing", for: indexPath) as! TableCell
        
        let ad = tableData[indexPath.row]
        let filePath = getFilePath(forFileName: (ad.value(forKey: "id") as! UUID).uuidString)
        let image = UIImage(contentsOfFile: filePath)
//        print(image, filePath)
        cell.lblName.text = ad.value(forKey: "name") as? String
        cell.lblPrice.text = "₹ " + (ad.value(forKey: "price") as! String) + "/-"
        cell.lblYear.text = "Model Year: " + (ad.value(forKey: "year") as! String)
        cell.imgPhoto.image = image
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedData = tableData[indexPath.row]
        self.performSegue(withIdentifier: "homeToDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func getFilePath(forFileName name: String) -> String {
        let fileManager = FileManager.default
        let documentsURL =  fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let filePath = documentsURL?.appendingPathComponent("\(String(name)).png")
        
        return filePath!.path
    }
}

class TableCell : UITableViewCell {
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblYear: UILabel!
}
