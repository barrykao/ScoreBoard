//
//  Games.swift
//  ScoreBoard
//
//  Created by BarryKao on 2019/11/5.
//  Copyright © 2019 BarryKao. All rights reserved.
//

import Foundation
class GameData: NSObject,NSCoding {
    func encode(with aCoder: NSCoder) {
        //把物件存到檔案
        //aCoder當作是Dictionary，會自動把存在裡面的值寫到檔案
        aCoder.encode(self.teamAllScore, forKey: "teamAllScore")
        aCoder.encode(self.visitAllScore, forKey: "visitAllScore")
        aCoder.encode(self.teamQuarterScore, forKey: "teamQuarterScore")
        aCoder.encode(self.visitQuarterScore, forKey: "visitQuarterScore")
        aCoder.encode(self.timeQuarter, forKey: "timeQuarter")
        aCoder.encode(self.teamName, forKey: "teamName")
        aCoder.encode(self.visitName, forKey: "visitName")
        aCoder.encode(self.timeAll, forKey: "timeAll")

    }
    
    required init?(coder aDecoder: NSCoder) {
        //檔案轉成物件
        
        self.teamAllScore = aDecoder.decodeObject(forKey: "teamAllScore") as? Int
        self.visitAllScore = aDecoder.decodeObject(forKey: "visitAllScore") as? Int
        self.teamQuarterScore = aDecoder.decodeObject(forKey: "teamQuarterScore") as! [Int]
        self.visitQuarterScore = aDecoder.decodeObject(forKey: "visitQuarterScore") as! [Int]
        self.timeQuarter = aDecoder.decodeObject(forKey: "timeQuarter") as! [String]
        self.teamName = aDecoder.decodeObject(forKey: "teamName") as? String
        self.visitName = aDecoder.decodeObject(forKey: "visitName") as? String
        self.timeAll = aDecoder.decodeObject(forKey: "timeAll") as? String

        super.init()
        
    }
    
    //    add note 會時會呼叫
    override init() {
        
    }
    
    var teamAllScore: Int?
    var visitAllScore: Int?
    var teamQuarterScore: [Int] = []
    var visitQuarterScore: [Int] = []
    var timeQuarter: [String] = []
    var teamName: String?
    var visitName: String?
    var timeAll: String?
    
}

class QuarterData {
    
    var firstScore: Int?
    var secondScore: Int?
    var time: String?
    
}
