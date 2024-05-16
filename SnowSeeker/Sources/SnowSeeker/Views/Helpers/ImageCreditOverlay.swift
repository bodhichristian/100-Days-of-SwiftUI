//
//  ImageCreditOverlay.swift
//  SnowSeeker
//
//  Created by christian on 11/26/22.
//

import SwiftUI

struct ImageCreditOverlay: View {
    var resort: Resort
    
    var gradient: LinearGradient {
        .linearGradient(
            Gradient(
                colors: [.black.opacity(0.6), .black.opacity(0)]),
                startPoint: .bottom,
                endPoint: .center)
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            gradient
            Text("Photo: \(resort.imageCredit)")
                .font(.caption)
                .foregroundColor(.white)
                .padding(5)
        }
    }
}

struct ImageCreditOverlay_Previews: PreviewProvider {
    static var previews: some View {
        ImageCreditOverlay(resort: Resort.example)
    }
}
