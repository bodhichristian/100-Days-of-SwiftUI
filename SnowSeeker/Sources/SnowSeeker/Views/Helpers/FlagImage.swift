//
//  CircleFlag.swift
//  SnowSeeker
//
//  Created by christian on 11/26/22.
//

import SwiftUI

struct FlagImage: View {
    var image: Image
    
    var body: some View {
        image
            .resizable()
            .frame(width: 75, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 2)
            }
            .shadow(radius: 7)
            .padding(6)
    }
}

struct FlagImage_Previews: PreviewProvider {
    static var previews: some View {
        FlagImage(image: Image(Resort.example.country))
    }
}
