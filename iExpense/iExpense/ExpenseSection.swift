//
//  ExpenseSection.swift
//  iExpense
//
//  Created by christian on 8/24/22.
//

import SwiftUI

struct ExpenseSection: View {
    let title: String
    let expenses: [ExpenseItem]
    let deleteItems: (IndexSet) -> Void
    
    var body: some View {
        Section(title) {
            ForEach(expenses) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        Text(item.type)
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    Text(item.currency)
                        .font(.caption)
                        .fontWeight(.semibold)
                    Text(item.amount, format: .localCurrency)
                    
                    
                    Image(systemName: "dollarsign.circle.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .style(for: item)
                    
                    
                }
                .accessibilityElement()
                .accessibilityLabel("\(item.name), \(item.amount.formatted(.currency(code:"USD")))")
                .accessibilityHint(item.type)
            }
            .onDelete(perform: deleteItems)
        }
    }
}

struct ExpenseSection_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseSection(title: "Example", expenses: []) { _ in }
    }
}
