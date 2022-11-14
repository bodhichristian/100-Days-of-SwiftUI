//
//  FormatStyle-LocalCurrency.swift
//  iExpense
//
//  Created by christian on 8/24/22.
//

import Foundation

extension FormatStyle where Self == FloatingPointFormatStyle<Double>.Currency {
    static var localCurrency: Self {
        .currency(code: Locale.current.currencyCode ?? "USD")
    }
}
