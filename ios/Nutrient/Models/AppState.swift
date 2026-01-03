//
//  AppState.swift
//  Nutrient
//
//  Created by Nutrient Team on 2026-01-02.
//

import Foundation
import Combine

class AppState: ObservableObject {
    @Published var isOnboardingCompleted: Bool {
        didSet {
            UserDefaults.standard.set(isOnboardingCompleted, forKey: "isOnboardingCompleted")
        }
    }

    @Published var currentUser: UserProfile?
    @Published var familyMembers: [FamilyMember] = []

    // API Client
    let apiClient = APIClient()

    init() {
        self.isOnboardingCompleted = UserDefaults.standard.bool(forKey: "isOnboardingCompleted")

        // Load cached user data
        if let userData = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(UserProfile.self, from: userData) {
            self.currentUser = user
        }
    }

    func completeOnboarding(with profile: UserProfile) {
        self.currentUser = profile
        self.isOnboardingCompleted = true

        // Cache user data
        if let encoded = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(encoded, forKey: "currentUser")
        }
    }

    func updateUserProfile(_ profile: UserProfile) {
        self.currentUser = profile
        if let encoded = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(encoded, forKey: "currentUser")
        }
    }
}
