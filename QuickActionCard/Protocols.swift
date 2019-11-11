
//
//  Protocols.swift
//  QuickActionCard
//
//  Created by Leon Vladimirov on 11/8/19.
//  Copyright © 2019 Leon Vladimirov. All rights reserved.
//

import SwiftUI

internal protocol CardViewModifiers {
    func overlayUIScreen() -> Self
    func enableHapticFeedback() -> Self
    func tapToDismiss() -> Self
    func dismissButton() -> Self
    func cardCornerRadius(_ cornerRadius: CGFloat) -> Self
    func cardPadding(_ padding: CGFloat) -> Self
}

internal protocol Properties {
    var cornerRadius: CGFloat {get set}
    var cardPadding: CGFloat {get set}
    
    var shouldHapticTapOnAppear: Bool {get set}
    var hasDismissButton: Bool {get set}
    var shouldDismissOntap: Bool {get set}
    var overlaysUIScreen: Bool {get set}
}
