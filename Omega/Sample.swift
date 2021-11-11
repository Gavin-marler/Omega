//
//  Sample.swift
//  Omega
//
//  Created by Gavin Marler on 11/5/21.
//

import SwiftUI

class Sample: Identifiable, Codable {
    var id = UUID()
    var name = "Name"
    var location = "Locatoin"
    var date = "TOday"
    var chemical = "Boron"
    var preCal = 0.00
    var start = 000
    var isStopped = false
    var isCompleted = false
    var end = 000
    var postCal = 0.00
}

class Samples: ObservableObject {
    @Published private(set) var tests: [Sample]
    static let saveKey = "SavedData"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "Saved Data"){
            if let decoded = try? JSONDecoder().decode([Sample].self, from: data) {
                self.tests = decoded
                return
            }
        }
        
        self.tests = []
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(tests) {
            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
        }
    }
    func add( sample: Sample){
        tests.append(sample)
        save()
    }
}
