//
//  UserProfile.swift
//  Nutrient
//
//  Created by Nutrient Team on 2026-01-02.
//

import Foundation

struct UserProfile: Codable, Identifiable {
    var id: Int?
    var userId: Int?

    // Household composition
    var householdSize: Int = 1
    var numAdults: Int = 1
    var numChildren: Int = 0

    // Location and budget
    var zipCode: String = ""
    var city: String = ""
    var state: String = ""
    var country: String = ""
    var weeklyBudget: Double?
    var emergencyModeBudget: Double?

    // Time and energy capacity
    var typicalCookingTime: CookingTime = .moderate
    var energyLevelPreference: EnergyLevel = .moderate

    // Cultural background
    var culturalBackground: String = ""
    var traditionalMeals: [String] = []
    var dietaryRestrictions: [String] = []

    // Preferences
    var favoriteCuisines: [String] = []
    var dislikedIngredients: [String] = []
    var cookingSkillLevel: CookingSkillLevel = .intermediate

    enum CodingKeys: String, CodingKey {
        case id, userId
        case householdSize = "household_size"
        case numAdults = "num_adults"
        case numChildren = "num_children"
        case zipCode = "zip_code"
        case weeklyBudget = "weekly_budget"
        case emergencyModeBudget = "emergency_mode_budget"
        case typicalCookingTime = "typical_cooking_time"
        case energyLevelPreference = "energy_level_preference"
        case culturalBackground = "cultural_background"
        case traditionalMeals = "traditional_meals"
        case dietaryRestrictions = "dietary_restrictions"
        case favoriteCuisines = "favorite_cuisines"
        case dislikedIngredients = "disliked_ingredients"
        case cookingSkillLevel = "cooking_skill_level"
    }
}

enum CookingTime: String, Codable, CaseIterable {
    case quick = "5-10min"
    case moderate = "15-30min"
    case extended = "30-60min"
    case long = "60+min"

    var displayName: String {
        switch self {
        case .quick: return "Quick (5-10 min)"
        case .moderate: return "Moderate (15-30 min)"
        case .extended: return "Extended (30-60 min)"
        case .long: return "Long (60+ min)"
        }
    }
}

enum EnergyLevel: String, Codable, CaseIterable {
    case high = "high_energy"
    case moderate = "moderate_energy"
    case low = "low_energy"
    case burnout = "burnout_mode"

    var displayName: String {
        switch self {
        case .high: return "High energy"
        case .moderate: return "Moderate energy"
        case .low: return "Low energy"
        case .burnout: return "Burnout mode"
        }
    }
}

enum CookingSkillLevel: String, Codable, CaseIterable {
    case beginner = "beginner"
    case intermediate = "intermediate"
    case advanced = "advanced"

    var displayName: String {
        switch self {
        case .beginner: return "Beginner"
        case .intermediate: return "Intermediate"
        case .advanced: return "Advanced"
        }
    }
}

struct FamilyMember: Codable, Identifiable {
    var id: Int?
    var name: String
    var age: Int?
    var relationship: String // "parent", "child", "spouse", etc.
    var preferences: [String] = []
    var restrictions: [String] = []
}
