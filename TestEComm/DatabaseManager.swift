//
//  DatabaseManager.swift
//  TestEComm
//
//  Created by Tushar Indi on 05/09/19.
//  Copyright © 2019 Tushar Indi. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DatabaseManager {
    
    func verifyLogin(_ username:String, _ password:String) -> String {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
       
        request.predicate = NSPredicate(format: "username = %@", username)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if (result.count > 0) {
                let data = result[0] as! NSManagedObject;
                let databasePassword = data.value(forKey: "password") as! String;
                if (databasePassword == password) {
                    return "success"
                } else {
                    return "Incorrect Password"
                }
            } else {
                return "User '" + username + "' not found"
            }
        } catch {
            return "Failed"
        }
    }
    
    func getLaunchStatus() -> Dictionary<String,String> {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LaunchStatus")
        
        request.predicate = NSPredicate(format: "id = 1")
        request.returnsObjectsAsFaults = false
        var status = ["loginStatus" : "loggedOut"]
        do {
            let result = try context.fetch(request)
            if (result.count > 0) {
                let data = result[0] as! NSManagedObject
                let isLoggedIn = data.value(forKey: "isLoggedIn") as! Bool
                if (isLoggedIn) {
                    status["loginStatus"] = "loggedIn";
                    status["username"] = data.value(forKey: "username") as? String
                }
            } else {
                setupFirstLaunch(appDelegate, context)
            }
        } catch {
            print("Setting Launch status failed")
        }
        return status
    }
    
    private func setupFirstLaunch(_ appDelegate: AppDelegate,_ context: NSManagedObjectContext) {
        
        //Create dummy user
        var entity = NSEntityDescription.entity(forEntityName: "Users", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue("test@aigen.tech", forKey: "username")
        newUser.setValue("AigenTech", forKey: "password")
        
        //Create dummy ad
        entity = NSEntityDescription.entity(forEntityName: "Ads", in: context)
        var newAd = NSManagedObject(entity: entity!, insertInto: context)
        
        var id = UUID()
        
        var image = UIImage.init(named: "Car-1")
        var imageLocation = self.saveImage(image!, withFileName: id.uuidString)
        
        newAd.setValue("WagonR", forKey: "name")
        newAd.setValue("2012", forKey: "year")
        newAd.setValue("3,00,000", forKey: "price")
        newAd.setValue("Aigen Tech", forKey: "username")
        newAd.setValue(imageLocation, forKey: "image")
        newAd.setValue(id, forKey: "id")
        
        
        newAd = NSManagedObject(entity: entity!, insertInto: context)
        
        id = UUID()
        
        image = UIImage.init(named: "Car-2")
        imageLocation = self.saveImage(image!, withFileName: id.uuidString)
        
        newAd.setValue("Tesla Roadster", forKey: "name")
        newAd.setValue("2017", forKey: "year")
        newAd.setValue("25,00,00,000", forKey: "price")
        newAd.setValue("Aigen Tech", forKey: "username")
        newAd.setValue(imageLocation, forKey: "image")
        newAd.setValue(id, forKey: "id")
        
        
        //Setup Launch Settings
        entity = NSEntityDescription.entity(forEntityName: "LaunchStatus", in: context)
        let launchStatus = NSManagedObject(entity: entity!, insertInto: context)
        launchStatus.setValue(1, forKey: "id")
        launchStatus.setValue(false, forKey: "isLoggedIn")
        launchStatus.setValue("", forKey: "username")
        
        saveContext(context)
    }
    
    func saveLoginDetails(_ username: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LaunchStatus")
        
        request.predicate = NSPredicate(format: "id = 1")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if (result.count > 0) {
                let data = result[0] as! NSManagedObject
                data.setValue(true, forKey: "isLoggedIn")
                data.setValue(username, forKey: "username")
            } else {
                print("Lauch data not found")
            }
        } catch {
            print("Getting Launch status failed")
        }
        saveContext(context)
    }
    
    private func saveContext(_ context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Saved data successfully")
        } catch {
            print("Failed saving data")
        }
    }
    
    func createAd(name name: String, year year: String, price price: String, image image: UIImage ) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Ads", in: context)
        let ad = NSManagedObject(entity: entity!, insertInto: context)
        
        let id = UUID()
        
        let imageLocation = self.saveImage(image, withFileName: id.uuidString)
        
        ad.setValue(name, forKey: "name")
        ad.setValue(year, forKey: "year")
        ad.setValue(price, forKey: "price")
        ad.setValue(self.getCurrentUsername(appDelegate, context), forKey: "username")
        ad.setValue(imageLocation, forKey: "image")
        ad.setValue(id, forKey: "id")
        
        saveContext(context)
    }
    
    func getCurrentUsername(_ appDelegate: AppDelegate,_ context: NSManagedObjectContext) -> String {
        var username = "";
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LaunchStatus")
        
        request.predicate = NSPredicate(format: "id = 1")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if (result.count > 0) {
                let data = result[0] as! NSManagedObject;
                username = data.value(forKey: "username") as! String;
            }
        } catch {
            username = "Failed"
        }
        
        return username
    }
    
    func saveImage(_ image: UIImage, withFileName name:String) -> String {
        
        // Save imageData to filePath
        
        // Get access to shared instance of the file manager
        let fileManager = FileManager.default
        
        // Get the URL for the users home directory
        let documentsURL =  fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // Get the document URL as a string
        let documentPath = documentsURL.path
        
        // Create filePath URL by appending final path component (name of image)
        let filePath = documentsURL.appendingPathComponent("\(String(name)).png")
        
        
        // Check for existing image data
        do {
            // Look through array of files in documentDirectory
            let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
            
            for file in files {
                // If we find existing image filePath delete it to make way for new imageData
                if "\(documentPath)/\(file)" == filePath.path {
//                    try fileManager.removeItem(atPath: filePath.path)
                }
            }
        } catch {
            print("Could not add image from document directory: \(error)")
        }
        
        
        // Create imageData and write to filePath
        do {
            if let pngImageData = image.pngData() {
                try pngImageData.write(to: filePath, options: .atomic)
                print("Saved image to file")
            }
        } catch {
            print("couldn't write image")
        }
        
        return filePath.path
    }
    
    func getAds() -> [NSManagedObject] {
        var ads : [NSManagedObject] = [];
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Ads")
        
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if (result.count > 0) {
                ads = result as! [NSManagedObject]
            }
        } catch {
            print("Failed to fetch ads")
        }
        
        return ads
    }
}
