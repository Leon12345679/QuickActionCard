//
//  QuickActionCard.swift
//  QuickActionCard
//
//  Created by Leon Vladimirov on 10/26/19.
//  Copyright © 2019 Leon Vladimirov. All rights reserved.
//

import SwiftUI

// pragma MARK: property and modifier protocols

fileprivate protocol CardViewModifiers {
    func overlayParent() -> Self
    func enableHapticFeedback() -> Self
    func tapToDismiss() -> Self
    func dismissButton() -> Self
    func cardCornerRadius(_ cornerRadius: CGFloat) -> Self
}

fileprivate protocol Properties {
    var cornerRadius: CGFloat {get set}
    
    var shouldHapticTapOnAppear: Bool {get set}
    var hasDismissButton: Bool {get set}
    var shouldDismissOntap: Bool {get set}
    var overlaysParent: Bool {get set}
}

// pragma MARK: Extensions

extension CardView: CardViewModifiers {
    
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
    
    /// Adjust the corner radius of the card. 10 is the default value
    /// - Parameter cornerRadius: the new corner radius
    func cardCornerRadius(_ cornerRadius: CGFloat) -> CardView<Content> {
        let copy = self
        copy.properties.cornerRadius = cornerRadius

        return copy
    }

    
    /// Adds an overlay on top of the parent
    func overlayParent() -> CardView<Content> {
        let copy = self
        copy.properties.overlaysParent = true

        return copy
    }
    
    /// Adds haptic feedback on appear
    func enableHapticFeedback() -> CardView<Content> {
        let copy = self
        copy.properties.shouldHapticTapOnAppear = true

        return copy
    }
}

// pragma MARK: Properties Object

fileprivate final class CardViewProperties: ObservableObject, Properties {
    
    @Published var cornerRadius: CGFloat
    
    @Published var shouldHapticTapOnAppear: Bool
    @Published var hasDismissButton: Bool
    @Published var shouldDismissOntap: Bool
    @Published var overlaysParent: Bool

    init() {
        self.cornerRadius = 10

        self.shouldHapticTapOnAppear = false
        self.hasDismissButton = false
        self.shouldDismissOntap = false
        self.overlaysParent = false
    }
}

// pragma MARK: Card Wrapper (Main Interface)

/// Displays a Card for quick user actions
struct CardView<Content>: View where Content : View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    @Binding var isPresented: Bool
        
    @ObservedObject private var properties = CardViewProperties()
    
    @State private var showOverlay: Bool = false
    @State private var showCard: Bool = true
    
    let viewBuilder: () -> Content
    
    var body: some View {
        ZStack {
            if showOverlay {
                GeometryReader() { geometry in
                    Rectangle()
//                      If light color scheme then apply overlay. If dark - no overlay.
                        .fill(self.colorScheme == .light ?
                            (self.properties.overlaysParent ? Color.black.opacity(0.2) : Color.black.opacity(0.00001)) // Light
                            : Color.black.opacity(0.00001)) // Dark
                        
                        .onTapGesture {
                            if self.properties.shouldDismissOntap {
                                withAnimation {
                                    self.showOverlay = false
                                    self.isPresented = false
                                }
                            }
                        }
                }
                .transition(.opacity)
            }
            
            if showCard {
                VStack {
                    Spacer()
                    viewBuilder()
                        .padding()
                        .padding()
                        
                        .frame(width:  UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
                    
                        .background(
                            Card(isPresented: $isPresented,
                                 showOverlay: $showOverlay,
                                 hasDismissButton: $properties.hasDismissButton,
                                 cornerRadius: 10)
                             )
                        
                        .clipped()
                 }
            }
        }
        .transition(.move(edge: .bottom))
        .onAppear() {
            if self.properties.shouldHapticTapOnAppear {
                let tapGenerator = UINotificationFeedbackGenerator()
                tapGenerator.notificationOccurred(.success)
            }
            
            if self.properties.shouldDismissOntap || self.properties.overlaysParent {
                withAnimation {
                    self.showOverlay = true
                }
            }
        }
    }
}

// pragma MARK: Card Struct

fileprivate struct Card: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @Binding var isPresented: Bool
    @Binding var showOverlay: Bool
    @Binding var hasDismissButton: Bool

    var cornerRadius: CGFloat
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(colorScheme == .light ? Color.white : Color(UIColor.systemGray6))
                .shadow(color: colorScheme == .light ? Color(UIColor.systemGray5) : Color.clear, radius: cornerRadius)
                .padding()
    
            
            if hasDismissButton {
                Button(action: {
                     withAnimation {
                        self.showOverlay = false
                        self.isPresented = false
                     }
                 }) {
                     CardViewButtonShape()
                         .alignmentGuide(.trailing, computeValue: {d in d[.trailing] + d.width / 1.2})
                         .alignmentGuide(.top, computeValue: {d in d[.top] - d.height / 1.2})
                 }
            }
        }
    }
}

// pragma MARK: Dismiss Button

fileprivate struct CardViewButtonShape: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        Circle()
            .fill(Color(UIColor.systemGray6))
            .frame(width: 30, height: 30)
            .overlay(
                CrossSymbol(crossColor: self.colorScheme == .light ? .black : .white)
                    .frame(width: 17, height: 17)
            )
    }
}


fileprivate struct CrossSymbol: View {
    var crossColor: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .rotation(Angle(degrees: 45))
                .frame(width: 4)
            RoundedRectangle(cornerRadius: 10)
                .rotation(Angle(degrees: -45))
                .frame(width: 4)
        }
        .foregroundColor(crossColor)
    }
}
