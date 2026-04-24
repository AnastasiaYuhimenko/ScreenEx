//
//  Coins+CoreDataProperties.swift
//  ScreenEx
//
//  Created by Anastasia on 24.04.2026.
//
//

public import Foundation
public import CoreData


public typealias CoinsCoreDataPropertiesSet = NSSet

extension Coins {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Coins> {
        return NSFetchRequest<Coins>(entityName: "Coins")
    }

    @NSManaged public var count: NSDecimalNumber?
    @NSManaged public var name: String?

}

extension Coins : Identifiable {

}
