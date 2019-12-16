# CoreDataWithCloudKitSample

Sample code for Core Data with CloudKit.

## INSERT
```
import UIKit
import CoreData

    private func insertData(code:String,name:String,costRate:Double,salesPrice:Int,image:UIImage!){
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext

        let objectEntity:NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: "GoodsMaster", into: managedContext) as NSManagedObject
        objectEntity.setValue(code, forKey: "code")
        objectEntity.setValue(name, forKey: "name")
        objectEntity.setValue(costRate, forKey: "costRate")
        objectEntity.setValue(salesPrice, forKey: "salesPrice")

        if (image != nil){
            let imageData = image.jpegData(compressionQuality: 1.0)

            var imageOrientation:Int = 0
            if (image.imageOrientation == UIImage.Orientation.down){
                imageOrientation = 2
            }else{
                imageOrientation = 1
            }

            objectEntity.setValue(imageData, forKey: "image")
            objectEntity.setValue(imageOrientation, forKey: "imageOrientation")
        }

        do {
            try managedContext.save()
        }catch let error {
            //INSERTでエラーになった場合
            NSLog("\(error)")
        }
    }
```

## SELECT
```
import UIKit
import CoreData

    private struct GoodsMaster {
        var code:String
        var name:String
        var costRate:Double
        var salesPrice:Int
        var image:UIImage!
    }

    private func searchData(minSalesPrice:Int,maxSalesPrice:Int){
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GoodsMaster")
        fetchRequest.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "salesPrice >= %d and salesPrice <= %d", minSalesPrice,maxSalesPrice)
        fetchRequest.predicate = predicate

        let sortDescriptor1 = NSSortDescriptor(key: "salesPrice", ascending: false) //降順
        let sortDescriptor2 = NSSortDescriptor(key: "costRate", ascending: true) //昇順
        fetchRequest.sortDescriptors = [sortDescriptor1,sortDescriptor2]

        do{
            let fetchResults: Array = try managedContext.fetch(fetchRequest)

            self.goodsMasters.removeAll()
            for fetchResult in fetchResults {
                let code = (fetchResult as AnyObject).value(forKey: "code") as! String
                let name = (fetchResult as AnyObject).value(forKey: "name") as! String
                let costRate = (fetchResult as AnyObject).value(forKey: "costRate") as! Double
                let salesPrice = (fetchResult as AnyObject).value(forKey: "salesPrice") as! Int

                let imageData = (fetchResult as AnyObject).value(forKey: "image") as! NSData?
                let imageOrientation = (fetchResult as AnyObject).value(forKey: "imageOrientation") as! Int?

                var image:UIImage! = nil
                if (imageData != nil){
                    image = UIImage(data: imageData! as Data)
                    if (imageOrientation == 2) {
                        image = UIImage(cgImage: image!.cgImage!, scale: image!.scale, orientation: UIImage.Orientation.down)
                    }
                }
                let goodsMaster = GoodsMaster(code: code, name: name, costRate: costRate, salesPrice: salesPrice,image: image)
                self.goodsMasters.append(goodsMaster)
            }
        }catch let error {
            NSLog("\(error)")
        }
    }
```

## UPDATE
```
import UIKit
import CoreData

     private func updateData(whereCode:String,updateName:String,updateCostRate:Double,updateSalesPrice:Int,updateImage:UIImage!){
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GoodsMaster")
        fetchRequest.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "code == %@", whereCode)
        fetchRequest.predicate = predicate

        do {
            let fetchResults: Array = try managedContext.fetch(fetchRequest)

            for fetchResult in fetchResults {
                let managedObject = fetchResult as! NSManagedObject
                managedObject.setValue(updateName, forKey: "name")
                managedObject.setValue(updateCostRate, forKey: "costRate")
                managedObject.setValue(updateSalesPrice, forKey: "salesPrice")
                if (updateImage != nil){
                    let imageData = updateImage.jpegData(compressionQuality: 1.0)

                    var imageOrientation:Int = 0
                    if (updateImage.imageOrientation == UIImage.Orientation.down){
                        imageOrientation = 2
                    }else{
                        imageOrientation = 1
                    }

                    managedObject.setValue(imageData, forKey: "image")
                    managedObject.setValue(imageOrientation, forKey: "imageOrientation")
                }
                try managedContext.save()
            }
        }catch let error {
            NSLog("\(error)")
        }
    }
```

## DELETE
```
import UIKit
import CoreData

    private func deleteData(whereCode:String){
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GoodsMaster")
        fetchRequest.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "code == %@", whereCode)
        fetchRequest.predicate = predicate

        do {
            let fetchResults: Array = try managedContext.fetch(fetchRequest)

            for fetchResult in fetchResults {
                let managedObject = fetchResult as! NSManagedObject

                managedContext.delete(managedObject)
            }
            try managedContext.save()
        }catch let error {
            NSLog("\(error)")
        }
    }
```
