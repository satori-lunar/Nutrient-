//
//  CreateMealPlanView.swift
//  Nutrient
//
//  Created by Nutrient Team on 2026-01-02.
//

import SwiftUI

struct CreateMealPlanView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var planName = ""
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(86400 * 7) // 7 days from now
    @State private var budgetLimit: Double?
    @State private var useQuickGeneration = true

    let onPlanCreated: (MealPlan) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Plan Details")) {
                    TextField("Plan Name", text: $planName)
                        .onAppear {
                            if planName.isEmpty {
                                planName = "Meal Plan \(formattedDate(Date()))"
                            }
                        }

                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)

                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                }

                Section(header: Text("Budget (Optional)")) {
                    HStack {
                        Text("$")
                        TextField("Budget Limit", value: $budgetLimit, format: .currency(code: "USD"))
                            .keyboardType(.decimalPad)
                    }
                }

                Section(header: Text("Generation Method")) {
                    Toggle("Use intelligent generation", isOn: $useQuickGeneration)

                    if useQuickGeneration {
                        Text("We'll create a meal plan based on your preferences, pantry items, and time constraints.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    } else {
                        Text("Manual planning - you'll add recipes yourself.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }

                Section {
                    Button(action: generatePlan) {
                        Text(useQuickGeneration ? "Generate Meal Plan" : "Create Empty Plan")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(12)
                    }
                    .disabled(planName.isEmpty)
                }
            }
            .navigationTitle("Create Meal Plan")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }

    private func generatePlan() {
        // TODO: Call API to generate meal plan
        // For now, create a mock plan
        let plan = MealPlan(
            id: Int.random(in: 1000...9999),
            userId: 1,
            name: planName,
            startDate: startDate,
            endDate: endDate,
            budgetLimit: budgetLimit,
            totalEstimatedCost: useQuickGeneration ? 75.50 : 0.0,
            recipes: useQuickGeneration ? [
                // Mock recipes would be generated here
            ] : []
        )

        onPlanCreated(plan)
    }
}

struct CreateMealPlanView_Previews: PreviewProvider {
    static var previews: some View {
        CreateMealPlanView(onPlanCreated: { _ in })
    }
}
