//
//  Extensions.swift
//  QuickActionCard
//
//  Created by Leon Vladimirov on 11/8/19.
//  Copyright © 2019 Leon Vladimirov. All rights reserved.
//

import SwiftUI


extension CardView: CardViewModifiers {
    
    /// Adds an overlay on top of the full screen
    func overlayUIScreen() -> CardView<Content> {
        let copy = self
        copy.properties.overlaysUIScreen = true
        
        return copy
    }
    /// Adds a  dismiss button in the top right corner
    func dismissButton() -> CardView<Content> {
        let copy = self
        copy.properties.hasDismissButton = true
        
        return copy
    }
    
    /// Tap outside the card to dismiss
    func tapToDismiss() -> CardView<Content> {
        let copy = self
        copy.properties.shouldDismissOntap = true
        
        return copy
    }
    
    /// Adjust the trailing,  leading and bottom padding on the card. 5 is the default value
    /// - Parameter padding: the new padding value
    func cardPadding(_ padding: CGFloat) -> CardView<Content> {
        let copy = self
        copy.properties.cardPadding = padding
        
        return copy
    }

    /// Adjust the corner radius of the card. 10 is the default value
    /// - Parameter cornerRadius: the new corner radius
    func cardCornerRadius(_ cornerRadius: CGFloat) -> CardView<Content> {
        let copy = self
        copy.properties.cornerRadius = cornerRadius

        return copy
    }
    
    /// Adds haptic feedback on appear
    func enableHapticFeedback() -> CardView<Content> {
        let copy = self
        copy.properties.shouldHapticTapOnAppear = true

        return copy
    }
}

