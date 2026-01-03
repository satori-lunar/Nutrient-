//
//  MealPlanningView.swift
//  Nutrient
//
//  Created by Nutrient Team on 2026-01-02.
//

import SwiftUI

struct MealPlanningView: View {
    @EnvironmentObject var appState: AppState
    @State private var mealPlans: [MealPlan] = []
    @State private var showingCreatePlanSheet = false
    @State private var isLoading = false

    var body: some View {
        NavigationView {
            VStack {
                // Header
                HStack {
                    Text("Meal Plans")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Spacer()

                    Button(action: { showingCreatePlanSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(.green)
                    }
                }
                .padding(.horizontal)

                // Current meal plan or empty state
                if isLoading {
                    ProgressView("Loading meal plans...")
                        .padding()
                } else if mealPlans.isEmpty {
                    EmptyMealPlansView(onCreatePlan: { showingCreatePlanSheet = true })
                } else {
                    MealPlansList(mealPlans: mealPlans)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingCreatePlanSheet) {
                CreateMealPlanView(onPlanCreated: addMealPlan)
            }
            .onAppear(perform: loadMealPlans)
        }
    }

    private func loadMealPlans() {
        isLoading = true
        // TODO: Load from API
        // For now, using mock data
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.mealPlans = [
                MealPlan(id: 1, userId: 1, name: "This Week's Meals", startDate: Date(), endDate: Date().addingTimeInterval(86400 * 7), budgetLimit: 100.0, totalEstimatedCost: 85.50, recipes: [
                    MealPlanRecipe(id: 1, mealPlanId: 1, recipeId: 1, scheduledDate: Date(), mealType: "dinner", servings: 4, isAlternative: false, notes: nil),
                    MealPlanRecipe(id: 2, mealPlanId: 1, recipeId: 2, scheduledDate: Date().addingTimeInterval(86400), mealType: "dinner", servings: 4, isAlternative: false, notes: nil)
                ])
            ]
            self.isLoading = false
        }
    }

    private func addMealPlan(_ plan: MealPlan) {
        mealPlans.append(plan)
        showingCreatePlanSheet = false
    }
}

struct EmptyMealPlansView: View {
    let onCreatePlan: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "calendar")
                .font(.system(size: 60))
                .foregroundColor(.secondary)

            Text("No meal plans yet")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Create your first meal plan to get started with organized, stress-free cooking.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: onCreatePlan) {
                Text("Create Meal Plan")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }

            Spacer()
        }
        .padding()
    }
}

struct MealPlansList: View {
    let mealPlans: [MealPlan]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(mealPlans) { plan in
                    MealPlanCard(plan: plan)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
    }
}

struct MealPlanCard: View {
    let plan: MealPlan

    var body: some View {
        NavigationLink(destination: MealPlanDetailView(plan: plan)) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(plan.name)
                        .font(.headline)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }

                HStack {
                    Label(formatDateRange(plan.startDate, plan.endDate), systemImage: "calendar")
                    Spacer()
                    if let budget = plan.budgetLimit, let cost = plan.totalEstimatedCost {
                        Text("$\(cost, specifier: "%.2f") / $\(budget, specifier: "%.2f")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .font(.subheadline)
                .foregroundColor(.secondary)

                Text("\(plan.recipes.count) meals planned")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func formatDateRange(_ start: Date, _ end: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none

        if Calendar.current.isDate(start, inSameDayAs: end) {
            return formatter.string(from: start)
        } else {
            return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
        }
    }
}

struct MealPlanningView_Previews: PreviewProvider {
    static var previews: some View {
        MealPlanningView()
            .environmentObject(AppState())
    }
}
