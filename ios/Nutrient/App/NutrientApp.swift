//
//  NutrientApp.swift
//  Nutrient
//
//  Created by Nutrient Team on 2026-01-02.
//

import SwiftUI

@main
struct NutrientApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            if appState.isOnboardingCompleted {
                MainTabView()
                    .environmentObject(appState)
            } else {
                OnboardingFlowView()
                    .environmentObject(appState)
            }
        }
    }
}
