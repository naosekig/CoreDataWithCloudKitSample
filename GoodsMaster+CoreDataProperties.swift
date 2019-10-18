//
//  GoodsMaster+CoreDataProperties.swift
//  CoreDataWithCloudKitSample
//
//  Created by NAOAKI SEKIGUCHI on 2019/10/18.
//  Copyright © 2019 NAOAKI SEKIGUCHI. All rights reserved.
//
//

import Foundation
import CoreData


extension GoodsMaster {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GoodsMaster> {
        return NSFetchRequest<GoodsMaster>(entityName: "GoodsMaster")
    }

    @NSManaged public var code: String?
    @NSManaged public var costRate: Double
    @NSManaged public var image: Data?
    @NSManaged public var imageOrientation: Int16
    @NSManaged public var name: String?
    @NSManaged public var salesPrice: Int64

}
