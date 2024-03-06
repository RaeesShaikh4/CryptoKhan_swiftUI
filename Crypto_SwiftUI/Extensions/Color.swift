//
//  Color.swift
//  Crypto_SwiftUI
//
//  Created by Vishal on 06/02/24.
//

import Foundation
import SwiftUI

extension Color {
    static let theme = ColorTheme()
    static let launchTheme = LaunchTheme()
}

struct ColorTheme {
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secondaryText = Color("SecondaryTextColor")
    let AccentColorButtons = Color("AccentColorButtons")
    let textfieldFG = Color("textfield-FG")
}

struct LaunchTheme {
    let accent = Color("LaunchAccentColor")
    let background = Color("LaunchBackgroundColor")
}
