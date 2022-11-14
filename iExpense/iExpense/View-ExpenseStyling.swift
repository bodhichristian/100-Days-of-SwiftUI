//
//  View-ExpenseStyling.swift
//  iExpense
//
//  Created by christian on 8/24/22.
//

import SwiftUI

extension View {
    func style(for item: ExpenseItem) -> some View {
        if item.amount < 10 {
            return self.foregroundColor(.blue)
        } else if item.amount < 100 {
            return self.foregroundColor(.green)
        } else {
            return self.foregroundColor(.yellow)
        }
        
    }
}
