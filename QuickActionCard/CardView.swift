//
//  CardView.swift
//  QuickActionCard
//
//  Created by Leon Vladimirov on 11/8/19.
//  Copyright © 2019 Leon Vladimirov. All rights reserved.
//

import SwiftUI

/// Displays a Card for quick user actions
struct CardView<Content>: View where Content : View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    @Binding var isPresented: Bool
    
    @ObservedObject internal var properties = CardViewProperties()

    @State private var cardOffset: CGFloat = UIScreen.main.bounds.size.height
    
    let viewBuilder: () -> Content

    var body: some View {
        ZStack {
            GeometryReader { _ in
                EmptyView()
            }
                .background(
                    Rectangle()
//                      If light mode then (if overlaysScreen: then gray; else: then transparent)
//                      If dark mode then transparent color
                        .foregroundColor(
                            (colorScheme == .light && properties.overlaysUIScreen) ?
                            properties.overlaysUIScreen ? Color.gray : Color.black.opacity(0.0001) : Color.black.opacity(0.0001))
                        .edgesIgnoringSafeArea(.all)

                        .frame(width: UIScreen.main.bounds.size.width,
                               height: UIScreen.main.bounds.size.height * 2)
                        .opacity(0.5)
                )
                
                 .onTapGesture {
                    if self.properties.shouldDismissOntap {
                       dismissView(isPresented: self.$isPresented)
                    }
                 }

                .opacity(self.isPresented ? 1.0 : 0.0)
                .animation(Animation.easeIn.delay(0.15))
            
            
            VStack {
                 Spacer()
                 viewBuilder()
                     .padding()
                     .frame(width:  UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
                     .background(
                         Card(isPresented: $isPresented,
                              overlaysUIScreen: $properties.overlaysUIScreen,
                              hasDismissButton: $properties.hasDismissButton,
                              cornerRadius: $properties.cornerRadius,
                              cardPadding: $properties.cardPadding)
                          )
                     .clipped()

            }
            .animation(.easeInOut)

            .offset(y: cardOffset)
            .offset(y: (self.isPresented && cardOffset == 0) ? 0 : UIScreen.main.bounds.size.height)
            
        }
        .onAppear() {
            self.cardOffset = 0
            
            if self.properties.shouldHapticTapOnAppear {
                   let tapGenerator = UINotificationFeedbackGenerator()
                   tapGenerator.notificationOccurred(.success)
            }
            
        }
    }
}

fileprivate func dismissView(isPresented: Binding<Bool>) {
    withAnimation {
        isPresented.wrappedValue = false
    }
}


// pragma MARK: Card Struct

fileprivate struct Card: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @Binding var isPresented: Bool
    @Binding var overlaysUIScreen: Bool
    @Binding var hasDismissButton: Bool

    @Binding var cornerRadius: CGFloat
    @Binding var cardPadding: CGFloat

    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill((colorScheme == .light && overlaysUIScreen) ? Color.white : Color(UIColor.systemGray6))
                
                .padding(.bottom, cardPadding)
                
                .padding(.trailing, cardPadding)
                .padding(.leading, cardPadding)

            
            if hasDismissButton {
                Button(action: {
                    dismissView(isPresented: self.$isPresented)
                 }) {
                     CardViewButtonShape()
                        .alignmentGuide(.trailing, computeValue: {d in d[.trailing] + d.width / 2})
                        .alignmentGuide(.top, computeValue: {d in d[.top] - d.height / 4})
                 }
            }
        }

    }
}
