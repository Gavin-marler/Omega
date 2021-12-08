//
//  Sample.swift
//  Omega
//
//  Created by Gavin Marler on 12/7/21.
//

import Foundation

class Sample: Identifiable, Codable {
    var id = UUID()
    var name = ""
    var location = ""
    var date = Date()
    var chemical = Chemical.example
    var preCal = 0.00
    var start = Date()
    var end = Date()
    var postCal = 0.00
    var lab = 0.00
    var isStopped: Bool {
        if postCal == 0 {
            return false
        }
        return true
    }
    var isCompleted: Bool {
        if lab == 0{
            return false
        }
        return true
    }
}

class Samples: ObservableObject {
    @Published private(set) var tests: [Sample]
    static let saveKey = "SavedData"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: Self.saveKey){
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
    func removeItems(at offsets: IndexSet){
        tests.remove(atOffsets: offsets)
    }
    
    func update(sample: Sample){
        tests.removeAll{$0.id == sample.id}
        tests.append(sample)
        save()
    }
}
