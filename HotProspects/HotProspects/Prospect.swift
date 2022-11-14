//
//  Prospect.swift
//  HotProspects
//
//  Created by christian on 11/7/22.
//

import SwiftUI

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
}

@MainActor class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedData")
    
    init() {
        //looks in documentsDirectory for stored data
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                people = decoded
                return
            }
        }
        //if no data is in documentsDirectory, people is an empty array
        people = []
    }
    
    private func save() {
        //saves current people array to documentsDirectory
        if let encoded = try? JSONEncoder().encode(people) {
            try? encoded.write(to: savePath, options: [.atomic, .completeFileProtection])
        }
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    func delete(_ prospect: Prospect) {
        if let index = people.firstIndex(where: { currentProspect in
            currentProspect.id == prospect.id
        }) {
            people.remove(at: index)
            save()
        }
    }
    
    //sends outs a change notification so views are refreshed
    func toggle(_ prospect: Prospect) {
        //calling objectWillChange.send() before changing the property ensures correct animations
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
}
