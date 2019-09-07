//
//  CreateAdViewController.swift
//  TestEComm
//
//  Created by Tushar Indi on 06/09/19.
//  Copyright © 2019 Tushar Indi. All rights reserved.
//

import Foundation
import UIKit
import Photos

class CreateAdViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,
                                UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var btnPhoto: UIButton!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    
    var pickerData: [String] = [String]()
    let imagePicker = AttachmentHandler()
    let dbManager = DatabaseManager();
    
    var isImageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for index in 1960...2019 {
            pickerData.append(String(index))
        }
//        print(pickerData)
        self.navigationItem.title = "Create Ad"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.btnSavePressed))
        picker.selectRow(pickerData.count - 1, inComponent: 0, animated: true)
    }
    
    @objc func btnSavePressed() {
//        print("Btn save pressed")
        if (!isImageSelected) {
            showAlert(withMessage: "Please select a photo")
        } else if (txtName.text?.count == 0) {
            showAlert(withMessage: "Please enter a name")
        } else if (txtPrice.text?.count == 0) {
            showAlert(withMessage: "Please enter a price")
        } else {
            dbManager.createAd(name: txtName.text!, year: pickerData[picker.selectedRow(inComponent: 0)], price: txtPrice.text!, image: imgPhoto.image!)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnSelecrPhotoPressed(_ sender: UIButton) {
        
        imagePicker.showAttachmentActionSheet(vc: self)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("Image loaded")
            imgPhoto.image = image
            isImageSelected = true
            btnPhoto.setTitle("Change Photo", for: UIControl.State.normal)
        } else{
            print("Something went wrong in  image")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func showAlert(withMessage message: String) {
        let alert = UIAlertController(title: "Invalid", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func textFieldEdited() {
        if (txtPrice.text!.count > 3) {
            txtPrice.text = formatPriceString(txtPrice.text!)
        }
    }
    
    func formatPriceString(_ price: String) -> String {
        var formattedString = ""
        var tempString = ""
//        print("\n\n\n")
        
        for i in 0...price.count - 1 {
            let char = String(price[price.index(price.startIndex, offsetBy: i)]);
            if (char != ",") {
                tempString += char
            }
        }
        for i in (0...tempString.count - 1).reversed() {
            let char = String(tempString[tempString.index(tempString.startIndex, offsetBy: i)]);
            let digitCount = tempString.count - 1 - i
//            print("i: ",i,"char: ", char, "digitCount: ", digitCount)
            if (digitCount == 3) {
                formattedString = "," + formattedString
            }
            if (digitCount >= 4 && digitCount % 2 != 0) {
                formattedString = "," + formattedString
            }
            formattedString = char + formattedString
        }
        
        return formattedString
    }
    
}
