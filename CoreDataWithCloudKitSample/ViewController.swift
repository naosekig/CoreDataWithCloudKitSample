//
//  ViewController.swift
//  CoreDataWithCloudKitSample
//
//  Created by NAOAKI SEKIGUCHI on 2019/10/18.
//  Copyright © 2019 NAOAKI SEKIGUCHI. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UINavigationController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let labelSearch:UILabel = UILabel()
    private let labelMinSalesPrice:UILabel = UILabel()
    private let textMinSalesPrice:UITextView = UITextView()
    private let labelMaxSalesPrice:UILabel = UILabel()
    private let textMaxSalesPrice:UITextView = UITextView()
    private let buttonSearch:UIButton = UIButton()
    private let labelCode:UILabel = UILabel()
    private let textCode:UITextView = UITextView()
    private let labelName:UILabel = UILabel()
    private let textName:UITextView = UITextView()
    private let labelCostRate:UILabel = UILabel()
    private let textCostRate:UITextView = UITextView()
    private let labelSalesPrice:UILabel = UILabel()
    private let textSalesPrice:UITextView = UITextView()
    private let labelImage:UILabel = UILabel()
    private let imageView:UIImageView = UIImageView()
    private let buttonImage:UIButton = UIButton()
    private let buttonInsert:UIButton = UIButton()
    private let buttonUpdate:UIButton = UIButton()
    private let buttonDelete:UIButton = UIButton()
    private let tableView:UITableView = UITableView()
    private var goodsMasters:[GoodsMaster] = [GoodsMaster]()

    //Core Dataから検索したデータを格納する構造体
    private struct GoodsMaster {
        var code:String
        var name:String
        var costRate:Double
        var salesPrice:Int
        var image:UIImage!
    }
    
    //初期処理
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        labelSearch.text = "検索条件[SalesPrice]"
        self.view.addSubview(labelSearch)
        
        labelMinSalesPrice.text = "最小値"
        self.view.addSubview(labelMinSalesPrice)
        
        designTextView(textView: textMinSalesPrice,keyboardType: .numberPad)
        self.view.addSubview(textMinSalesPrice)
        
        labelMaxSalesPrice.text = "最大値"
        self.view.addSubview(labelMaxSalesPrice)
        
        designTextView(textView: textMaxSalesPrice,keyboardType: .numberPad)
        self.view.addSubview(textMaxSalesPrice)
        buttonSearch.setTitle("検索", for: .normal)
        buttonSearch.addTarget(self, action: #selector(self.touchUpButtonSearch), for: .touchUpInside)
        designButton(button: buttonSearch)
        self.view.addSubview(buttonSearch)
        
        labelCode.text = "Code(コード)"
        self.view.addSubview(labelCode)
        designTextView(textView: textCode,keyboardType: .numberPad)
        self.view.addSubview(textCode)
        labelName.text = "Name(名称)"
        self.view.addSubview(labelName)
        designTextView(textView: textName,keyboardType: .default)
        self.view.addSubview(textName)
        labelCostRate.text = "CostRate(原価率)"
        self.view.addSubview(labelCostRate)
        designTextView(textView: textCostRate,keyboardType: .decimalPad)
        self.view.addSubview(textCostRate)
        labelSalesPrice.text = "SalesPrice(売単価)"
        self.view.addSubview(labelSalesPrice)
        designTextView(textView: textSalesPrice,keyboardType: .numberPad)
        self.view.addSubview(textSalesPrice)
        
        labelImage.text = "Image(画像)"
        self.view.addSubview(labelImage)
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        buttonImage.setTitle("Photosから取得", for: .normal)
        buttonImage.addTarget(self, action: #selector(self.touchUpButtonPicture), for: .touchUpInside)
        designButton(button: buttonImage)
        self.view.addSubview(buttonImage)
        
        buttonInsert.setTitle("INSERT", for: .normal)
        buttonInsert.addTarget(self, action: #selector(self.touchUpButtonInsert), for: .touchUpInside)
        designButton(button: buttonInsert)
        self.view.addSubview(buttonInsert)
        
        buttonUpdate.setTitle("UPDATE", for: .normal)
        buttonUpdate.addTarget(self, action: #selector(self.touchUpButtonUpdate), for: .touchUpInside)
        designButton(button: buttonUpdate)
        self.view.addSubview(buttonUpdate)
        
        buttonDelete.setTitle("DELETE", for: .normal)
        buttonDelete.addTarget(self, action: #selector(self.touchUpButtonDelete), for: .touchUpInside)
        designButton(button: buttonDelete)
        self.view.addSubview(buttonDelete)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }
    
    //UITextViewのデザイン設定
    private func designTextView(textView:UITextView,keyboardType:UIKeyboardType){
        textView.layer.cornerRadius = 10
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 0.5
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.keyboardType = keyboardType
        textView.delegate = self
    }
    
    //UIButtonのデザイン設定
    private func designButton(button:UIButton){
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.setTitleColor(UIColor.blue, for: .normal)
    }
    
    //画面表示時に画面設定を実施
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        changeScreen()
    }
    
    //端末回転時に画面設定を実施
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(
            alongsideTransition: nil,
            completion: {(UIViewControllerTransitionCoordinatorContext) in
                self.changeScreen()
            }
        )
    }
    
    //画面設定
    private func changeScreen() {
        let windowSize: CGRect = (UIApplication.shared.windows.first { $0.isKeyWindow }?.bounds)!
        let widthValue:CGFloat = windowSize.width
        let heightValue:CGFloat = windowSize.height
        
        labelSearch.frame = CGRect(x: 5, y: 50, width: widthValue-120, height: 40)
        buttonSearch.frame = CGRect(x: widthValue-110, y: 45, width: 100, height: 40)
        labelMinSalesPrice.frame = CGRect(x: 2, y: 100, width: 100, height: 40)
        textMinSalesPrice.frame = CGRect(x: 60, y: 102, width: widthValue/2-102, height: 40)
        labelMaxSalesPrice.frame = CGRect(x: widthValue/2 + 2, y: 100, width: 100, height: 40)
        textMaxSalesPrice.frame = CGRect(x: widthValue/2 + 100, y: 100, width: widthValue/2-102, height: 40)
        
        labelCode.frame = CGRect(x: 5, y: 150, width: 150, height: 40)
        textCode.frame = CGRect(x: 160, y: 150, width: widthValue-165, height: 40)
        labelName.frame = CGRect(x: 5, y: 195, width: 150, height: 40)
        textName.frame = CGRect(x: 160, y: 195, width: widthValue-165, height: 40)
        labelCostRate.frame = CGRect(x: 5, y: 240, width: 150, height: 40)
        textCostRate.frame = CGRect(x: 160, y: 240, width: widthValue-165, height: 40)
        labelSalesPrice.frame = CGRect(x: 5, y: 285, width: 150, height: 40)
        textSalesPrice.frame = CGRect(x: 160, y: 285, width: widthValue-165, height: 40)
        labelImage.frame = CGRect(x: 5, y: 330, width: 150, height: 80)
        imageView.frame = CGRect(x: 160, y: 330, width: widthValue-320, height: 80)
        buttonImage.frame = CGRect(x: widthValue-155, y: 330, width: 150, height: 80)
        
        buttonInsert.frame = CGRect(x: 5, y: 415, width: widthValue/3-10, height: 40)
        buttonUpdate.frame = CGRect(x: widthValue/3+5, y: 415, width: widthValue/3-10, height: 40)
        buttonDelete.frame = CGRect(x: widthValue/3*2+5, y: 415, width: widthValue/3-10, height: 40)
        
        tableView.frame = CGRect(x: 5, y: 455, width: widthValue-10, height: heightValue-455)
    }
    
    /**
     Core DataにデータをINSERTする
     @param INSERTするデータ code:コード name:名称 costRate:原価率 salesPrice:売単価 image:画像
     */
    private func insertData(code:String,name:String,costRate:Double,salesPrice:Int,image:UIImage!){
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        //INSERTするデータを設定
        let objectEntity:NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: "GoodsMaster", into: managedContext) as NSManagedObject
        objectEntity.setValue(code, forKey: "code")
        objectEntity.setValue(name, forKey: "name")
        objectEntity.setValue(costRate, forKey: "costRate")
        objectEntity.setValue(salesPrice, forKey: "salesPrice")
        
        if (image != nil){
            //UIImageをNSDataに変換
            let imageData = image.jpegData(compressionQuality: 1.0)
        
            //UIImageの方向を確認
            var imageOrientation:Int = 0
            if (image.imageOrientation == UIImage.Orientation.down){
                imageOrientation = 2
            }else{
                imageOrientation = 1
            }
            
            objectEntity.setValue(imageData, forKey: "image")
            objectEntity.setValue(imageOrientation, forKey: "imageOrientation")
        }
        
        //データのINSERTを実行
        do {
            try managedContext.save()
        }catch let error {
            //INSERTでエラーになった場合
            NSLog("\(error)")
        }
    }
    
    /**
     Core Dataからデータを検索する
     @param 検索条件 minSalesPrice:検索条件のsalesPriceの最小値 maxSalesPrice:検索条件のsalesPriceの最大値
     */
    private func searchData(minSalesPrice:Int,maxSalesPrice:Int){
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        //検索条件指定
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GoodsMaster")
        fetchRequest.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "salesPrice >= %d and salesPrice <= %d", minSalesPrice,maxSalesPrice)
        fetchRequest.predicate = predicate
        
        //ソート条件指定
        let sortDescriptor1 = NSSortDescriptor(key: "salesPrice", ascending: false) //降順
        let sortDescriptor2 = NSSortDescriptor(key: "costRate", ascending: true) //昇順
        fetchRequest.sortDescriptors = [sortDescriptor1,sortDescriptor2]
        
        do{
            //検索実行
            let fetchResults: Array = try managedContext.fetch(fetchRequest)
            
            //検索成功
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
            //検索でエラーになった場合
            NSLog("\(error)")
        }
    }
    
    /**
     指定した条件でCore DataのデータをUPDATEする
     @param whereCode:更新対象のコード updateName:名称の更新値 updateCostRate:原価率の更新値 updateSalesPrice:売単価の更新値 updateImage:画像の更新値
     */
    private func updateData(whereCode:String,updateName:String,updateCostRate:Double,updateSalesPrice:Int,updateImage:UIImage!){
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        //1.更新対象のレコードを検索する
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GoodsMaster")
        fetchRequest.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "code == %@", whereCode)
        fetchRequest.predicate = predicate
        
        do {
            //検索実行
            let fetchResults: Array = try managedContext.fetch(fetchRequest)
            
            //2.検索したレコードの値をUPDATEする
            for fetchResult in fetchResults {
                let managedObject = fetchResult as! NSManagedObject
                managedObject.setValue(updateName, forKey: "name")
                managedObject.setValue(updateCostRate, forKey: "costRate")
                managedObject.setValue(updateSalesPrice, forKey: "salesPrice")
                if (updateImage != nil){
                    //UIImageをNSDataに変換
                    let imageData = updateImage.jpegData(compressionQuality: 1.0)
                    
                    //UIImageの方向を確認
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
            //Updateでエラーになった場合
            NSLog("\(error)")
        }
    }
    
    /**
     指定した条件でCore DataのデータをDELETEする
     @param whereCode:削除対象のCode
     */
    private func deleteData(whereCode:String){
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        //1.削除対象のレコードを検索する
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GoodsMaster")
        fetchRequest.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "code == %@", whereCode)
        fetchRequest.predicate = predicate
        
        do {
            //検索実行
            let fetchResults: Array = try managedContext.fetch(fetchRequest)
            
            //2.検索したレコードの値を削除する
            for fetchResult in fetchResults {
                let managedObject = fetchResult as! NSManagedObject
                
                managedContext.delete(managedObject)
            }
            try managedContext.save()
        }catch let error {
            //Updateでエラーになった場合
            NSLog("\(error)")
        }
    }
    
    //UITableViewの行数の設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goodsMasters.count
    }
    
    //UITableViewのCellのデザイン設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index:Int = indexPath.row
        var cell:UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = goodsMasters[index].code + " " + goodsMasters[index].name
        cell.textLabel!.font = UIFont.systemFont(ofSize: 16)
        cell.textLabel!.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    //UITableViewの行選択イベント
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index:Int = indexPath.row
        textCode.text = goodsMasters[index].code
        textName.text = goodsMasters[index].name
        textCostRate.text = goodsMasters[index].costRate.description
        textSalesPrice.text = goodsMasters[index].salesPrice.description
        imageView.image = goodsMasters[index].image
    }
    
    //検索ボタン押下処理
    @objc func touchUpButtonSearch(){
        self.view.endEditing(true)
        
        var minSalesPriceString = textMinSalesPrice.text!
        if (minSalesPriceString.count == 0){
            minSalesPriceString = "0"
        }
        var maxSalesPriceString = textMaxSalesPrice.text!
        if (maxSalesPriceString.count == 0){
            maxSalesPriceString = "999999999999"
        }
        
        searchData(minSalesPrice: Int(minSalesPriceString)!, maxSalesPrice: Int(maxSalesPriceString)!)
        tableView.reloadData()
    }
    
    //INSERTボタン押下処理
    @objc func touchUpButtonInsert(){
        self.view.endEditing(true)
        
        let codeString = textCode.text!
        let nameString = textName.text!
        let costRateString = textCostRate.text!
        let salesPriceString = textSalesPrice.text!
        
        insertData(code: codeString, name: nameString, costRate: Double(costRateString)!, salesPrice: Int(salesPriceString)!,image:imageView.image)
        touchUpButtonSearch()
    }
    
    //UPDATEボタン押下処理
    @objc func touchUpButtonUpdate(){
        self.view.endEditing(true)
        
        let codeString = textCode.text!
        let nameString = textName.text!
        let costRateString = textCostRate.text!
        let salesPriceString = textSalesPrice.text!
        
        updateData(whereCode: codeString, updateName: nameString, updateCostRate: Double(costRateString)!, updateSalesPrice: Int(salesPriceString)!,updateImage: imageView.image)
        touchUpButtonSearch()
    }
    
    //DELETEボタン押下処理
    @objc func touchUpButtonDelete(){
        self.view.endEditing(true)
        
        let codeString = textCode.text!
        
        deleteData(whereCode: codeString)
        touchUpButtonSearch()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n"){
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    //「Photosから取得」ボタン押下処理
    @objc func touchUpButtonPicture(){
        openPicker()
    }
    
    //UIImagePickerControllerの表示処理
    @objc func openPicker(){
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            return
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker.delegate = self
        
        self.present(picker,animated:false,completion:nil)
    }
    
    //UIImagePickerControllerでの画像の選択イベント
    func imagePickerController(_ picker:UIImagePickerController,didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey:Any]){
        
        picker.presentingViewController?.dismiss(animated: false, completion: nil)
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        let widthValue:CGFloat = image!.size.width
        let heightValue:CGFloat = image!.size.height
        let scaleValue:CGFloat = 860/widthValue
        
        let size = CGSize(width: widthValue*scaleValue, height: heightValue*scaleValue)
        UIGraphicsBeginImageContext(size)
        image!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizeImage:UIImage! = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        imageView.image = resizeImage
    }
}

