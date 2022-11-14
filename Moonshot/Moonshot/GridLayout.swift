//
//  GridLayout.swift
//  Moonshot
//
//  Created by christian on 8/31/22.
//

import SwiftUI

struct GridLayout: View {
    let astronauts: [String: Astronaut]
    let missions: [Mission]
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(missions) { mission in
                    NavigationLink {
                        MissionView(mission: mission, astronauts: astronauts)
                    } label: {
                        VStack {
                            Image(mission.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .padding(4)
                                .padding()
                            
                            VStack {
                                Text(mission.displayName)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text(mission.formattedLaunchDate)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.5))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
                            .background(.secondary)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.secondary)
                        )
                    }
                }
            }
            .padding([.horizontal, .bottom, .top])

        }
        .navigationTitle("Moonshot")
        //.background(.darkBackground)
        .background(LinearGradient(gradient: Gradient(colors: [.black, .darkBackground]), startPoint: .top, endPoint: .bottom))
        .preferredColorScheme(.dark)
    }
}

struct GridLayout_Previews: PreviewProvider {
    static var previews: some View {
        GridLayout(astronauts: Bundle.main.decode("astronauts.json"), missions: Bundle.main.decode("missions.json"))
            .preferredColorScheme(.dark)
    }
}
