//
//  APIClient.swift
//  Nutrient
//
//  Created by Nutrient Team on 2026-01-02.
//

import Foundation
import Combine

class APIClient {
    private let baseURL = URL(string: "http://localhost:8000/api/v1")!
    private let session = URLSession.shared

    // MARK: - Authentication

    func login(email: String, password: String) -> AnyPublisher<User, Error> {
        let loginData = ["email": email, "password": password]
        return performRequest(endpoint: "/auth/login", method: "POST", body: loginData)
    }

    func register(email: String, password: String, fullName: String) -> AnyPublisher<User, Error> {
        let registerData = ["email": email, "password": password, "full_name": fullName]
        return performRequest(endpoint: "/auth/register", method: "POST", body: registerData)
    }

    // MARK: - User Profiles

    func createProfile(_ profile: UserProfile) -> AnyPublisher<UserProfile, Error> {
        return performRequest(endpoint: "/profiles", method: "POST", body: profile)
    }

    func updateProfile(_ profile: UserProfile) -> AnyPublisher<UserProfile, Error> {
        guard let profileId = profile.id else {
            return Fail(error: APIError.invalidRequest).eraseToAnyPublisher()
        }
        return performRequest(endpoint: "/profiles/\(profileId)", method: "PUT", body: profile)
    }

    func getProfile(userId: Int) -> AnyPublisher<UserProfile, Error> {
        return performRequest(endpoint: "/profiles/\(userId)", method: "GET")
    }

    // MARK: - Pantry

    func getPantryItems(userId: Int) -> AnyPublisher<[PantryItem], Error> {
        return performRequest(endpoint: "/pantry/items?user_id=\(userId)", method: "GET")
    }

    func addPantryItem(_ item: PantryItem) -> AnyPublisher<PantryItem, Error> {
        return performRequest(endpoint: "/pantry/items", method: "POST", body: item)
    }

    func updatePantryItem(_ item: PantryItem) -> AnyPublisher<PantryItem, Error> {
        guard let itemId = item.id else {
            return Fail(error: APIError.invalidRequest).eraseToAnyPublisher()
        }
        return performRequest(endpoint: "/pantry/items/\(itemId)", method: "PUT", body: item)
    }

    // MARK: - Meal Planning

    func getMealPlans(userId: Int) -> AnyPublisher<[MealPlan], Error> {
        return performRequest(endpoint: "/meal-planning/plans?user_id=\(userId)", method: "GET")
    }

    func createMealPlan(_ plan: MealPlan) -> AnyPublisher<MealPlan, Error> {
        return performRequest(endpoint: "/meal-planning/plans", method: "POST", body: plan)
    }

    func generateMealPlan(request: MealPlanGenerationRequest) -> AnyPublisher<MealPlan, Error> {
        return performRequest(endpoint: "/meal-planning/generate", method: "POST", body: request)
    }

    // MARK: - Recipes

    func searchRecipes(query: String, filters: RecipeFilters? = nil) -> AnyPublisher<[Recipe], Error> {
        var endpoint = "/recipes/search?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        if let filters = filters {
            // Add filter parameters
            if let cuisine = filters.cuisine {
                endpoint += "&cuisine=\(cuisine)"
            }
            if let maxTime = filters.maxPrepTimeMinutes {
                endpoint += "&max_time=\(maxTime)"
            }
        }
        return performRequest(endpoint: endpoint, method: "GET")
    }

    func getCookNowSuggestions(userId: Int) -> AnyPublisher<[Recipe], Error> {
        return performRequest(endpoint: "/recipes/cook-now?user_id=\(userId)", method: "GET")
    }

    // MARK: - Private Methods

    private func performRequest<T: Decodable>(endpoint: String, method: String, body: Encodable? = nil) -> AnyPublisher<T, Error> {
        let url = baseURL.appendingPathComponent(endpoint)
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let body = body {
            request.httpBody = try? JSONEncoder().encode(body)
        }

        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }

                guard (200...299).contains(httpResponse.statusCode) else {
                    throw APIError.httpError(httpResponse.statusCode)
                }

                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

// MARK: - Supporting Types

enum APIError: Error {
    case invalidRequest
    case invalidResponse
    case httpError(Int)
    case decodingError(Error)
}

struct User: Codable {
    let id: Int
    let email: String
    let fullName: String
    let isActive: Bool
}

struct PantryItem: Codable, Identifiable {
    var id: Int?
    let userId: Int
    var name: String
    var barcode: String?
    var quantity: Double
    var unit: String
    var category: String?
    var expirationDate: Date?
    var purchaseDate: Date?
    var estimatedValue: Double?
    var isPerishable: Bool
    var storageLocation: String?
    var notes: String?
}

struct MealPlan: Codable, Identifiable {
    var id: Int?
    let userId: Int
    var name: String
    var startDate: Date
    var endDate: Date
    var budgetLimit: Double?
    var totalEstimatedCost: Double?
    var recipes: [MealPlanRecipe] = []
}

struct MealPlanRecipe: Codable, Identifiable {
    var id: Int?
    let mealPlanId: Int
    let recipeId: Int
    var scheduledDate: Date
    var mealType: String
    var servings: Int
    var isAlternative: Bool
    var notes: String?
}

struct MealPlanGenerationRequest: Codable {
    let userId: Int
    let startDate: Date
    let endDate: Date
    let preferences: [String: AnyCodable]?
}

struct Recipe: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String?
    let prepTimeMinutes: Int
    let cookTimeMinutes: Int
    let servings: Int
    let difficulty: String
    let cuisineType: String?
    let ingredients: [RecipeIngredient]
    let instructions: String?
}

struct RecipeIngredient: Codable {
    let id: Int?
    let name: String
    let quantity: Double
    let unit: String
    let isOptional: Bool
    let notes: String?
}

struct RecipeFilters: Codable {
    let cuisine: String?
    let maxPrepTimeMinutes: Int?
    let difficulty: String?
    let dietaryRestrictions: [String]?
}

struct AnyCodable: Codable {
    let value: Any

    init(_ value: Any) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            value = string
        } else if let int = try? container.decode(Int.self) {
            value = int
        } else if let double = try? container.decode(Double.self) {
            value = double
        } else if let bool = try? container.decode(Bool.self) {
            value = bool
        } else if let array = try? container.decode([AnyCodable].self) {
            value = array
        } else if let dict = try? container.decode([String: AnyCodable].self) {
            value = dict
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported type")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let string = value as? String {
            try container.encode(string)
        } else if let int = value as? Int {
            try container.encode(int)
        } else if let double = value as? Double {
            try container.encode(double)
        } else if let bool = value as? Bool {
            try container.encode(bool)
        } else if let array = value as? [AnyCodable] {
            try container.encode(array)
        } else if let dict = value as? [String: AnyCodable] {
            try container.encode(dict)
        } else {
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: container.codingPath, debugDescription: "Unsupported type"))
        }
    }
}
