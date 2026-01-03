//
//  HouseholdStepView.swift
//  Nutrient
//
//  Created by Nutrient Team on 2026-01-02.
//

import SwiftUI

struct HouseholdStepView: View {
    @Binding var profile: UserProfile

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Tell us about your household")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text("This helps us create meal plans that work for everyone in your family.")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                VStack(spacing: 20) {
                    // Household size
                    VStack(alignment: .leading) {
                        Text("Household Size")
                            .font(.headline)

                        Picker("Household Size", selection: $profile.householdSize) {
                            ForEach(1...10, id: \.self) { size in
                                Text("\(size) \(size == 1 ? "person" : "people")").tag(size)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 120)
                        .clipped()
                    }

                    // Adults and children
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Family Composition")
                            .font(.headline)

                        HStack {
                            Text("Adults:")
                            Spacer()
                            Picker("", selection: $profile.numAdults) {
                                ForEach(0...profile.householdSize, id: \.self) { count in
                                    Text("\(count)").tag(count)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(width: 60)
                        }

                        HStack {
                            Text("Children:")
                            Spacer()
                            Picker("", selection: $profile.numChildren) {
                                ForEach(0...(profile.householdSize - profile.numAdults), id: \.self) { count in
                                    Text("\(count)").tag(count)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(width: 60)
                        }
                    }
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(12)
                .padding(.horizontal)

                // Primary cook question
                VStack(alignment: .leading) {
                    Text("Are you the primary cook in your household?")
                        .font(.headline)

                    Text("This helps us understand your role in meal preparation.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    HStack(spacing: 20) {
                        Button(action: {
                            // Handle primary cook selection
                        }) {
                            Text("Yes, mainly me")
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.green.opacity(0.1))
                                .foregroundColor(.green)
                                .cornerRadius(8)
                        }

                        Button(action: {
                            // Handle shared cooking
                        }) {
                            Text("Shared responsibility")
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.top, 8)
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

struct HouseholdStepView_Previews: PreviewProvider {
    static var previews: some View {
        HouseholdStepView(profile: .constant(UserProfile()))
    }
}
