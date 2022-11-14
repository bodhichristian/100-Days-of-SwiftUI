//
//  AstronautView.swift
//  Moonshot
//
//  Created by christian on 8/30/22.
//

import SwiftUI

struct AstronautView: View {
    let astronaut: Astronaut
    
    var body: some View {
        ScrollView {
            VStack {
                Image(astronaut.id)
                    .resizable()
                    .frame(width: 400, height: 300)
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(.white, lineWidth: 3)
                    )
                
                Text(astronaut.description)
                    .padding()
            }
        }
        .background(LinearGradient(gradient: Gradient(colors: [.black, .darkBackground]), startPoint: .top, endPoint: .bottom))
        .navigationTitle(astronaut.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    static var previews: some View {
        AstronautView(astronaut: astronauts["aldrin"]!)
            .preferredColorScheme(.dark)
    }
}
