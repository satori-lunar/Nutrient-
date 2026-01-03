//
//  RecipesView.swift
//  Nutrient
//
//  Created by Nutrient Team on 2026-01-02.
//

import SwiftUI

struct RecipesView: View {
    var body: some View {
        VStack {
            Text("Recipes")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Text("Coming soon: Browse and search recipes that fit your preferences")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()

            Spacer()
        }
        .navigationTitle("Recipes")
    }
}

struct RecipesView_Previews: PreviewProvider {
    static var previews: some View {
        RecipesView()
    }
}
