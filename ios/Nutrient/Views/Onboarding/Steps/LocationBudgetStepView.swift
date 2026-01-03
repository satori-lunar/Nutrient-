//
//  LocationBudgetStepView.swift
//  Nutrient
//
//  Created by Nutrient Team on 2026-01-02.
//

import SwiftUI

struct LocationBudgetStepView: View {
    @Binding var profile: UserProfile

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Location & Budget")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text("This helps us find stores near you and create budget-friendly meal plans.")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                VStack(spacing: 20) {
                    // Location
                    VStack(alignment: .leading) {
                        Text("Location")
                            .font(.headline)

                        TextField("ZIP Code", text: $profile.zipCode)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)

                        HStack {
                            TextField("City", text: $profile.city)
                                .textFieldStyle(.roundedBorder)
                            TextField("State", text: $profile.state)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 80)
                        }
                    }

                    // Weekly budget
                    VStack(alignment: .leading) {
                        Text("Weekly Grocery Budget")
                            .font(.headline)

                        Text("How much do you typically spend on groceries each week?")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        HStack {
                            Text("$")
                            TextField("Amount", value: $profile.weeklyBudget, format: .number)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)
                        }
                    }

                    // Emergency mode budget
                    VStack(alignment: .leading) {
                        Text("Emergency Budget Mode")
                            .font(.headline)

                        Text("What's the absolute minimum you'd like to spend? (We'll use this for 'emergency' meal plans)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        HStack {
                            Text("$")
                            TextField("Amount", value: $profile.emergencyModeBudget, format: .number)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)
                        }
                    }
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(12)
                .padding(.horizontal)

                // Store preferences
                VStack(alignment: .leading) {
                    Text("Store Preferences")
                        .font(.headline)

                    Text("Which stores do you typically shop at? (Select all that apply)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    VStack(alignment: .leading, spacing: 12) {
                        StorePreferenceRow(store: "Walmart", icon: "cart.fill")
                        StorePreferenceRow(store: "Aldi", icon: "cart.fill")
                        StorePreferenceRow(store: "Kroger", icon: "cart.fill")
                        StorePreferenceRow(store: "Target", icon: "cart.fill")
                        StorePreferenceRow(store: "Local ethnic markets", icon: "building.2.fill")
                        StorePreferenceRow(store: "Farmer's markets", icon: "leaf.fill")
                    }
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
}

struct StorePreferenceRow: View {
    let store: String
    let icon: String
    @State private var isSelected = false

    var body: some View {
        Button(action: { isSelected.toggle() }) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(isSelected ? .green : .secondary)
                Text(store)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .green : .secondary)
            }
        }
    }
}

struct LocationBudgetStepView_Previews: PreviewProvider {
    static var previews: some View {
        LocationBudgetStepView(profile: .constant(UserProfile()))
    }
}
