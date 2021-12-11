//
//  Chemical.swift
//  Omega
//
//  Created by Gavin Marler on 12/7/21.
//

import Foundation

struct Chemical: Codable, Identifiable, Hashable {
    let id:         Int
    let chemical:   String
    let method:     String
    let methodNum:  Int
    let flowRate:   String
    let volMinMax:  String
    let NIOSH:      String
    let pel :       Double
 
    static let example = Chemical(id: 1, chemical: "4-Ketocyclophosphamide", method: "CYCLOPHOSPHAMIDE and IFOSFAMIDE in urine", methodNum: 8327, flowRate: "", volMinMax: "8 mL", NIOSH: "https://www.cdc.gov/niosh/nmam/pdf/8327.pdf", pel: 0.00)
}
