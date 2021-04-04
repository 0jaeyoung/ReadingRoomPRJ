//
//  Room.swift
//  ReadingRoomPRJ
//
//  Created by MCNC on 2021/03/28.
//

import UIKit

class Room: NSObject {
    static var shared: Room = Room()
    
    var college: String!
    var name: String!
    var seat: [Any]!
    var available: NSArray!
    var reserved: [Any]!
    var confirmTimeLimit: Any!
    var maximumReservationTime: Any!
    var maximumReservationCount: Any!
    var totalCount: Int!
    var rowCount: Int!
    var columnCount: Int!
    
    init(room: NSDictionary) {
        self.college = room["college"] as? String
        self.name = room["roomName"] as? String
        self.seat = room["seat"] as? [Any]
        self.available = room["available"] as? NSArray
        self.reserved = room["reserved"] as? [Any]
        self.confirmTimeLimit = room["confirmTimeLimit"]
        self.rowCount = seat.endIndex
        self.columnCount = (seat[0] as AnyObject).count
        self.totalCount = rowCount * columnCount!
    }
    
    override init() {
    }
    
    struct StaticInstance {
        static var instance: Room?
    }
    
    class func sharedInstace() -> Room {
        return StaticInstance.instance!
    }
}
