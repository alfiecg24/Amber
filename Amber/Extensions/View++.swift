//
//  View++.swift
//  Amber
//
//  Created by Alfie on 16/06/2023.
//

import SwiftUI

extension View {
    func customButton() -> ModifiedContent<Self, ButtonModifier> {
        return modifier(ButtonModifier())
    }
}
