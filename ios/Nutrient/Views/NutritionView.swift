//
//  NutritionView.swift
//  Nutrient
//
//  Created by Nutrient Team on 2026-01-02.
//

import SwiftUI

struct NutritionView: View {
    var body: some View {
        VStack {
            Text("Nutrition")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Text("Coming soon: Compassionate nutrition tracking focused on family wellness")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()

            Spacer()
        }
        .navigationTitle("Nutrition")
    }
}

struct NutritionView_Previews: PreviewProvider {
    static var previews: some View {
        NutritionView()
    }
}
