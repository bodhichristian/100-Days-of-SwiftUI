//
//  ProspectsView.swift
//  HotProspects
//
//  Created by christian on 11/7/22.
//

import SwiftUI
import CodeScanner
import UserNotifications

struct ProspectsView: View {
    @EnvironmentObject var prospects: Prospects
    @State private var isShowingScanner = false
    @State private var sortOrder = SortType.date
    @State private var isShowingSortOptions = false
    
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    enum SortType {
        case name, date
    }
    
    let filter: FilterType
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted People"
        case .uncontacted:
            return "Uncontacted People"
        }
    }
    
    var filteredProspects: [Prospect] {
        let result: [Prospect]

        switch filter {
        case .none:
            result = prospects.people
        case .contacted:
            result = prospects.people.filter { $0.isContacted }
        case .uncontacted:
            result = prospects.people.filter { !$0.isContacted }
        }

        if sortOrder == .name {
            return result.sorted { $0.name < $1.name }
        } else {
            return result.reversed()
        }
    }
    //let deleteItems: (IndexSet) -> Void
    
    //sample data
    let sampleName = ["Roy Rogers", "Tony Stark", "Bob Marley", "Axl Rose", "Gilbert Gottfried", "Whoopi Goldberg", "Sandra Bullock", "Dennis the Menace", "Rick Ross", "Mariah Carey", "James Joyce"]
    
    let sampleEmail = ["catlover134@meowmix.com", "dogwhisperer@puppycrew.woof", "disneyadult@magickingdom.com", "msfrizzfanclub@magicschoolbus.com", "beyourownboss@enterpriserentacar.com", "carriedaway@emails.com", "fierceandfamished@hangry.net", "amialive@sentience.edu", "rollercoaster@tycoon.com", "cloudywithachance@meatballs.gov"]
    
    
    var body: some View {
        NavigationView {
            List {
                                
                Section {
                    ForEach(filteredProspects) { prospect in
                        HStack {
                            
                            if filter == .none && prospect.isContacted {
                                Image(systemName: "person.crop.circle.fill.badge.checkmark")
                                    .foregroundColor(.green)
                                
                                
                            } else if filter == .none && !prospect.isContacted {
                                Image(systemName: "person.crop.circle.badge.xmark")
                                    .foregroundColor(.blue)
                                
                            }
                            
                            VStack(alignment: .leading) {
                                Text(prospect.name)
                                    .font(.headline)
                                Text(prospect.emailAddress)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                        }
                        .contextMenu {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                if prospect.isContacted == false {
                                    Label("Mark as Contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                                } else {
                                    Label("Mark as Uncontacted", systemImage: "person.crop.circle.badge.xmark")
                                }
                            }
                            
                            Button(role: .destructive) {
                                prospects.delete(prospect)
                            } label: {
                                Label("Delete prospect", systemImage: "trash")
                            }
                        }
                        //.listRowBackground(Color.gray)
                        .swipeActions {
                            if prospect.isContacted {
                                Button {
                                    prospects.toggle(prospect)
                                } label: {
                                    Label("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark")
                                }
                                .tint(.blue)
                            } else {
                                Button {
                                    prospects.toggle(prospect)
                                } label: {
                                    Label("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                                }
                                .tint(.green)
                            }
                            
                            Button {
                                addNotification(for: prospect)
                            } label: {
                                Label("Remind Me", systemImage: "bell")
                            }
                            .tint(.orange)
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                prospects.delete(prospect)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }.tint(.red)
                        }
                    }
                }
                //.onDelete(perform: deleteItems)
            }
            //.background(Color(red: 0.2, green: 0.2, blue: 0.8))
            //.scrollContentBackground(.hidden)
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isShowingSortOptions = true
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingScanner = true
                    } label: {
                        Label("Scan", systemImage: "qrcode.viewfinder")
                    }
                }
                
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "\(sampleName.randomElement()!)\n\(sampleEmail.randomElement()!)", completion: handleScan)
                
            }
            .confirmationDialog("Sort by...)", isPresented: $isShowingSortOptions) {
                Button("Name (A-Z)") { sortOrder = .name }
                Button("Date (Newest First)") { sortOrder = .date }
            }
            
        }
    }
    
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            
            prospects.add(person)
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            
            // trigger for the next occurrence of 9am
            // let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            //testing trigger
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("D'oh")
                        
                    }
                }
            }
        }
    }
}
    
    // reference 'sharing data across tabs' lesson if preview stops working.
    // unsure where to place .environmentObject(prospects)
    struct ProspectsView_Previews: PreviewProvider {
        static var previews: some View {
            ProspectsView(filter: .none)
                .environmentObject(Prospects())
        }
    }
    
    
    
