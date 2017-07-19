//
//  User+CoreDataProperties.swift
//  Reader
//
//  Created by 张海南 on 2017/7/19.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation
import CoreData


extension User {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User");
    }
    
    @NSManaged public var userId: String
    @NSManaged public var identityType: String
    @NSManaged public var identifier: String
    @NSManaged public var credential: String?
    @NSManaged public var expiresIn: Int32
    @NSManaged public var refreshToken: String?
    @NSManaged public var unionid: String?
    @NSManaged public var verified: Int32
    @NSManaged public var email: String?
    @NSManaged public var nickname: String?
    @NSManaged public var avatar: String?
    @NSManaged public var nationalityId: Int32
    @NSManaged public var hskId: Int32
    @NSManaged public var interestedLangs: String?
    @NSManaged public var username: String?
    @NSManaged public var gender: Int32
    @NSManaged public var phone: String?
    @NSManaged public var desc: String?
    @NSManaged public var address: String?
    @NSManaged public var zipCode: String?
    @NSManaged public var city: String?
    @NSManaged public var province: String?
    @NSManaged public var country: String?
    @NSManaged public var createTime: Int64
    @NSManaged public var lastUpdateTime: Int64
    @NSManaged public var isDel: Int32
    @NSManaged public var status: Int32
    @NSManaged public var sessionId: String?
    
}
