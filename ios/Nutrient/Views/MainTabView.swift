//
//  MainTabView.swift
//  Nutrient
//
//  Created by Nutrient Team on 2026-01-02.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        TabView {
            NavigationView {
                MealPlanningView()
            }
            .tabItem {
                Label("Meals", systemImage: "fork.knife")
            }

            NavigationView {
                PantryView()
            }
            .tabItem {
                Label("Pantry", systemImage: "archivebox")
            }

            NavigationView {
                RecipesView()
            }
            .tabItem {
                Label("Recipes", systemImage: "book")
            }

            NavigationView {
                NutritionView()
            }
            .tabItem {
                Label("Nutrition", systemImage: "chart.bar")
            }

            NavigationView {
                ProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: "person")
            }
        }
        .accentColor(.green)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(AppState())
    }
}
