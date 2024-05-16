//
//  phoneOnly - View ext.swift
//  SnowSeeker
//
//  Created by christian on 11/25/22.
//

import Foundation
import SwiftUI

//this extension uses UIDevice to detect whether app is running on phone or tablet.
//if on phone, the simpler StackNavigationViewStyle apporach is used

extension View {
    @ViewBuilder func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.navigationViewStyle(.stack)
        } else {
            self
        }
    }
}
