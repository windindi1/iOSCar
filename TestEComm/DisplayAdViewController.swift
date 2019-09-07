//
//  DisplayAdViewController.swift
//  TestEComm
//
//  Created by Tushar Indi on 06/09/19.
//  Copyright © 2019 Tushar Indi. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DisplayAdViewController: UIViewController {
    
    @IBOutlet weak var imgPhoto : UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblSeller: UILabel!
    
    var carDetails : NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Details"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Contact", style: .plain, target: self, action: #selector(self.btnContactPressed))
        
        lblName.text = carDetails.value(forKey: "name") as? String
        lblYear.text = carDetails.value(forKey: "year") as? String
        lblPrice.text = "₹ " + (carDetails.value(forKey: "price") as! String)
        lblSeller.text = carDetails.value(forKey: "username") as? String
        
        let filePath = getFilePath(forFileName: (carDetails.value(forKey: "id") as! UUID).uuidString)
        let image = UIImage(contentsOfFile: filePath)
        
        imgPhoto.image = image
    }
    
    @objc func btnContactPressed() {
        self.performSegue(withIdentifier: "detailToContact", sender: self)
    }
    
    func getFilePath(forFileName name: String) -> String {
        let fileManager = FileManager.default
        let documentsURL =  fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let filePath = documentsURL?.appendingPathComponent("\(String(name)).png")
        
        return filePath!.path
    }
}
