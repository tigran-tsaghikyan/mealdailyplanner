import Foundation

// MARK: - API Response Models (mirrors backend JSON)

private struct APIResponse: Decodable {
    let breakfast: APIMeal
    let lunch: APIMeal
    let dinner: APIMeal
}

private struct APIMeal: Decodable {
    let title: String
    let ingredients: [APIIngredient]
    let steps: [String]
    let prepTimeMinutes: Int
}

private struct APIIngredient: Decodable {
    let name: String
    let baseGrams: Double
    let unit: String
}

// MARK: - Request Body

private struct GeneratePlanRequest: Encodable {
    struct FamilyMemberDTO: Encodable {
        let name: String
        let isChild: Bool
    }

    let familyMembers: [FamilyMemberDTO]
    let allergies: [String]
    let availableIngredients: [String]
    let mealPreferences: String
    let date: String
}

// MARK: - Service

final class MealPlanAPIService {
    static let shared = MealPlanAPIService()
    private init() {}

    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest  = 25
        config.timeoutIntervalForResource = 30
        return URLSession(configuration: config)
    }()

    // MARK: - Generate Meals

    /// Calls the Vercel proxy and returns 3 parsed Meal objects.
    /// Throws on network error, bad response, or parse failure → caller falls back to local.
    func generateMeals(profile: UserProfile) async throws -> [Meal] {
        guard let url = URL(string: APIConfig.backendURL) else {
            throw APIError.invalidURL
        }

        // Build request body
        let body = GeneratePlanRequest(
            familyMembers: profile.familyMembers.map {
                .init(name: $0.name, isChild: $0.isChild)
            },
            allergies: profile.allergies,
            availableIngredients: profile.availableIngredients,
            mealPreferences: profile.mealPreferences,
            date: DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none)
        )

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(APIConfig.appSecret, forHTTPHeaderField: "x-app-secret")
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await session.data(for: request)

        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw APIError.badResponse
        }

        let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
        return convert(apiResponse)
    }

    // MARK: - Conversion

    private func convert(_ response: APIResponse) -> [Meal] {
        [
            makeMeal(response.breakfast, type: .breakfast),
            makeMeal(response.lunch,     type: .lunch),
            makeMeal(response.dinner,    type: .dinner)
        ]
    }

    private func makeMeal(_ api: APIMeal, type: MealType) -> Meal {
        Meal(
            type: type,
            title: api.title,
            ingredients: api.ingredients.map {
                MealIngredient(name: $0.name, baseGrams: $0.baseGrams, unit: $0.unit)
            },
            steps: api.steps,
            prepTimeMinutes: api.prepTimeMinutes
        )
    }
}

// MARK: - Errors

enum APIError: Error {
    case invalidURL
    case badResponse
}