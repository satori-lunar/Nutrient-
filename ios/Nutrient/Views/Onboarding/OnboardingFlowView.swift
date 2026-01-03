//
//  OnboardingFlowView.swift
//  Nutrient
//
//  Created by Nutrient Team on 2026-01-02.
//

import SwiftUI

struct OnboardingFlowView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentStep = 0
    @State private var profile = UserProfile()

    private let steps = [
        "Welcome",
        "Household",
        "Location & Budget",
        "Time & Energy",
        "Culture & Preferences",
        "Family Members",
        "Complete"
    ]

    var body: some View {
        VStack {
            // Progress indicator
            ProgressView(value: Double(currentStep + 1), total: Double(steps.count))
                .padding(.horizontal)
                .padding(.top)

            Text("Step \(currentStep + 1) of \(steps.count)")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.bottom)

            TabView(selection: $currentStep) {
                WelcomeStepView()
                    .tag(0)

                HouseholdStepView(profile: $profile)
                    .tag(1)

                LocationBudgetStepView(profile: $profile)
                    .tag(2)

                TimeEnergyStepView(profile: $profile)
                    .tag(3)

                CulturePreferencesStepView(profile: $profile)
                    .tag(4)

                FamilyMembersStepView(profile: $profile)
                    .tag(5)

                CompleteStepView(profile: $profile, onComplete: completeOnboarding)
                    .tag(6)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            // Navigation buttons
            HStack {
                if currentStep > 0 {
                    Button(action: { currentStep -= 1 }) {
                        Text("Back")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }

                Spacer()

                if currentStep < steps.count - 1 {
                    Button(action: { currentStep += 1 }) {
                        Text("Next")
                            .foregroundColor(.green)
                            .fontWeight(.semibold)
                    }
                    .padding()
                }
            }
            .padding(.horizontal)
        }
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }

    private func completeOnboarding() {
        appState.completeOnboarding(with: profile)
    }
}

struct OnboardingFlowView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingFlowView()
            .environmentObject(AppState())
    }
}
