import Foundation

struct RecipeDatabase {
    static let all: [Recipe] = breakfasts + lunches + dinners

    // MARK: - Breakfasts (12 recipes, 5-10 min each)

    static let breakfasts: [Recipe] = [
        Recipe(
            title: "Scrambled Eggs with Toast",
            mealType: .breakfast,
            ingredients: [
                MealIngredient(name: "Eggs", baseGrams: 2, unit: "pcs"),
                MealIngredient(name: "Bread", baseGrams: 2, unit: "slices"),
                MealIngredient(name: "Butter", baseGrams: 10, unit: "g"),
                MealIngredient(name: "Salt", baseGrams: 1, unit: "pinch"),
            ],
            steps: ["Whisk eggs with salt", "Melt butter in pan on medium heat", "Pour eggs, stir gently until set", "Toast bread, serve together"],
            prepTimeMinutes: 7,
            tags: ["quick", "protein"]
        ),
        Recipe(
            title: "Greek Yogurt Bowl",
            mealType: .breakfast,
            ingredients: [
                MealIngredient(name: "Greek yogurt", baseGrams: 150, unit: "g"),
                MealIngredient(name: "Banana", baseGrams: 1, unit: "pcs"),
                MealIngredient(name: "Honey", baseGrams: 15, unit: "g"),
                MealIngredient(name: "Oats", baseGrams: 30, unit: "g"),
            ],
            steps: ["Slice banana", "Layer yogurt in bowl", "Top with banana, oats, and honey"],
            prepTimeMinutes: 5,
            tags: ["no-cook", "protein", "fiber"]
        ),
        Recipe(
            title: "Omelette with Vegetables",
            mealType: .breakfast,
            ingredients: [
                MealIngredient(name: "Eggs", baseGrams: 3, unit: "pcs"),
                MealIngredient(name: "Bell pepper", baseGrams: 50, unit: "g"),
                MealIngredient(name: "Tomato", baseGrams: 50, unit: "g"),
                MealIngredient(name: "Olive oil", baseGrams: 5, unit: "ml"),
                MealIngredient(name: "Salt", baseGrams: 1, unit: "pinch"),
            ],
            steps: ["Dice vegetables", "Whisk eggs with salt", "Heat oil, pour eggs", "Add vegetables, fold when set"],
            prepTimeMinutes: 8,
            tags: ["protein", "vegetables"]
        ),
        Recipe(
            title: "Overnight Oats",
            mealType: .breakfast,
            ingredients: [
                MealIngredient(name: "Oats", baseGrams: 50, unit: "g"),
                MealIngredient(name: "Milk", baseGrams: 150, unit: "ml"),
                MealIngredient(name: "Chia seeds", baseGrams: 10, unit: "g"),
                MealIngredient(name: "Honey", baseGrams: 10, unit: "g"),
            ],
            steps: ["Mix oats, milk, chia seeds, and honey", "Refrigerate overnight", "Stir and serve cold"],
            prepTimeMinutes: 3,
            tags: ["no-cook", "fiber", "make-ahead"]
        ),
        Recipe(
            title: "Avocado Toast",
            mealType: .breakfast,
            ingredients: [
                MealIngredient(name: "Bread", baseGrams: 2, unit: "slices"),
                MealIngredient(name: "Avocado", baseGrams: 1, unit: "pcs"),
                MealIngredient(name: "Lemon juice", baseGrams: 5, unit: "ml"),
                MealIngredient(name: "Salt", baseGrams: 1, unit: "pinch"),
                MealIngredient(name: "Red pepper flakes", baseGrams: 1, unit: "pinch"),
            ],
            steps: ["Toast bread", "Mash avocado with lemon juice and salt", "Spread on toast, sprinkle pepper flakes"],
            prepTimeMinutes: 5,
            tags: ["quick", "healthy-fats"]
        ),
        Recipe(
            title: "Banana Pancakes",
            mealType: .breakfast,
            ingredients: [
                MealIngredient(name: "Banana", baseGrams: 1, unit: "pcs"),
                MealIngredient(name: "Eggs", baseGrams: 2, unit: "pcs"),
                MealIngredient(name: "Oats", baseGrams: 30, unit: "g"),
                MealIngredient(name: "Butter", baseGrams: 5, unit: "g"),
            ],
            steps: ["Mash banana, mix with eggs and oats", "Heat butter in pan", "Pour small circles, flip when bubbly", "Serve warm"],
            prepTimeMinutes: 10,
            tags: ["protein", "fiber"]
        ),
        Recipe(
            title: "Cottage Cheese with Fruit",
            mealType: .breakfast,
            ingredients: [
                MealIngredient(name: "Cottage cheese", baseGrams: 150, unit: "g"),
                MealIngredient(name: "Berries", baseGrams: 80, unit: "g"),
                MealIngredient(name: "Honey", baseGrams: 10, unit: "g"),
            ],
            steps: ["Place cottage cheese in bowl", "Top with berries and drizzle honey"],
            prepTimeMinutes: 3,
            tags: ["no-cook", "protein"]
        ),
        Recipe(
            title: "Boiled Eggs with Veggies",
            mealType: .breakfast,
            ingredients: [
                MealIngredient(name: "Eggs", baseGrams: 2, unit: "pcs"),
                MealIngredient(name: "Cucumber", baseGrams: 80, unit: "g"),
                MealIngredient(name: "Tomato", baseGrams: 80, unit: "g"),
                MealIngredient(name: "Salt", baseGrams: 1, unit: "pinch"),
            ],
            steps: ["Boil eggs for 7 minutes", "Slice cucumber and tomato", "Peel eggs, serve with vegetables"],
            prepTimeMinutes: 10,
            tags: ["protein", "vegetables"]
        ),
        Recipe(
            title: "Smoothie Bowl",
            mealType: .breakfast,
            ingredients: [
                MealIngredient(name: "Banana", baseGrams: 1, unit: "pcs"),
                MealIngredient(name: "Berries", baseGrams: 100, unit: "g"),
                MealIngredient(name: "Milk", baseGrams: 100, unit: "ml"),
                MealIngredient(name: "Oats", baseGrams: 20, unit: "g"),
            ],
            steps: ["Blend banana, berries, and milk until thick", "Pour into bowl", "Top with oats"],
            prepTimeMinutes: 5,
            tags: ["no-cook", "vitamins"]
        ),
        Recipe(
            title: "Rice Porridge",
            mealType: .breakfast,
            ingredients: [
                MealIngredient(name: "Rice", baseGrams: 60, unit: "g"),
                MealIngredient(name: "Milk", baseGrams: 200, unit: "ml"),
                MealIngredient(name: "Sugar", baseGrams: 10, unit: "g"),
                MealIngredient(name: "Butter", baseGrams: 5, unit: "g"),
            ],
            steps: ["Rinse rice", "Simmer rice in milk on low heat for 10 min", "Stir in sugar and butter"],
            prepTimeMinutes: 12,
            tags: ["warm", "carbs"]
        ),
        Recipe(
            title: "Cheese Sandwich",
            mealType: .breakfast,
            ingredients: [
                MealIngredient(name: "Bread", baseGrams: 2, unit: "slices"),
                MealIngredient(name: "Cheese", baseGrams: 40, unit: "g"),
                MealIngredient(name: "Butter", baseGrams: 10, unit: "g"),
                MealIngredient(name: "Tomato", baseGrams: 50, unit: "g"),
            ],
            steps: ["Butter bread slices", "Layer cheese and tomato slices", "Close sandwich, optionally toast"],
            prepTimeMinutes: 5,
            tags: ["quick", "protein"]
        ),
        Recipe(
            title: "Fruit Salad with Nuts",
            mealType: .breakfast,
            ingredients: [
                MealIngredient(name: "Apple", baseGrams: 1, unit: "pcs"),
                MealIngredient(name: "Banana", baseGrams: 1, unit: "pcs"),
                MealIngredient(name: "Walnuts", baseGrams: 20, unit: "g"),
                MealIngredient(name: "Honey", baseGrams: 10, unit: "g"),
            ],
            steps: ["Dice apple and banana", "Mix in bowl with walnuts", "Drizzle with honey"],
            prepTimeMinutes: 5,
            tags: ["no-cook", "vitamins", "fiber"]
        ),
    ]

    // MARK: - Lunches (14 recipes, 8-15 min each)

    static let lunches: [Recipe] = [
        Recipe(
            title: "Chicken Rice Bowl",
            mealType: .lunch,
            ingredients: [
                MealIngredient(name: "Chicken breast", baseGrams: 150, unit: "g"),
                MealIngredient(name: "Rice", baseGrams: 80, unit: "g"),
                MealIngredient(name: "Soy sauce", baseGrams: 15, unit: "ml"),
                MealIngredient(name: "Olive oil", baseGrams: 5, unit: "ml"),
                MealIngredient(name: "Salt", baseGrams: 1, unit: "pinch"),
            ],
            steps: ["Cook rice according to package", "Slice chicken, season with salt", "Pan-fry chicken in olive oil until golden", "Serve over rice with soy sauce"],
            prepTimeMinutes: 15,
            tags: ["protein", "carbs"]
        ),
        Recipe(
            title: "Vegetable Stir-Fry",
            mealType: .lunch,
            ingredients: [
                MealIngredient(name: "Bell pepper", baseGrams: 80, unit: "g"),
                MealIngredient(name: "Zucchini", baseGrams: 80, unit: "g"),
                MealIngredient(name: "Carrot", baseGrams: 60, unit: "g"),
                MealIngredient(name: "Soy sauce", baseGrams: 15, unit: "ml"),
                MealIngredient(name: "Olive oil", baseGrams: 10, unit: "ml"),
                MealIngredient(name: "Rice", baseGrams: 80, unit: "g"),
            ],
            steps: ["Cook rice", "Slice all vegetables", "Stir-fry vegetables in oil for 5 min", "Add soy sauce, serve with rice"],
            prepTimeMinutes: 12,
            tags: ["vegetables", "fiber"]
        ),
        Recipe(
            title: "Tuna Salad",
            mealType: .lunch,
            ingredients: [
                MealIngredient(name: "Canned tuna", baseGrams: 100, unit: "g"),
                MealIngredient(name: "Lettuce", baseGrams: 80, unit: "g"),
                MealIngredient(name: "Tomato", baseGrams: 80, unit: "g"),
                MealIngredient(name: "Cucumber", baseGrams: 60, unit: "g"),
                MealIngredient(name: "Olive oil", baseGrams: 10, unit: "ml"),
                MealIngredient(name: "Lemon juice", baseGrams: 10, unit: "ml"),
            ],
            steps: ["Chop lettuce, tomato, cucumber", "Drain tuna", "Mix everything in bowl", "Dress with olive oil and lemon"],
            prepTimeMinutes: 8,
            tags: ["protein", "no-cook", "omega-3"]
        ),
        Recipe(
            title: "Pasta with Tomato Sauce",
            mealType: .lunch,
            ingredients: [
                MealIngredient(name: "Pasta", baseGrams: 100, unit: "g"),
                MealIngredient(name: "Tomato", baseGrams: 150, unit: "g"),
                MealIngredient(name: "Garlic", baseGrams: 2, unit: "cloves"),
                MealIngredient(name: "Olive oil", baseGrams: 10, unit: "ml"),
                MealIngredient(name: "Salt", baseGrams: 1, unit: "pinch"),
            ],
            steps: ["Boil pasta according to package", "Dice tomatoes, mince garlic", "Sauté garlic in oil, add tomatoes", "Simmer 5 min, toss with pasta"],
            prepTimeMinutes: 12,
            tags: ["carbs", "vegetables"]
        ),
        Recipe(
            title: "Lentil Soup",
            mealType: .lunch,
            ingredients: [
                MealIngredient(name: "Red lentils", baseGrams: 80, unit: "g"),
                MealIngredient(name: "Carrot", baseGrams: 60, unit: "g"),
                MealIngredient(name: "Onion", baseGrams: 50, unit: "g"),
                MealIngredient(name: "Olive oil", baseGrams: 5, unit: "ml"),
                MealIngredient(name: "Salt", baseGrams: 1, unit: "pinch"),
                MealIngredient(name: "Cumin", baseGrams: 1, unit: "tsp"),
            ],
            steps: ["Dice onion and carrot", "Sauté in oil for 2 min", "Add lentils and 400ml water", "Simmer 10 min, season with cumin and salt"],
            prepTimeMinutes: 15,
            tags: ["fiber", "protein", "warm"]
        ),
        Recipe(
            title: "Egg Fried Rice",
            mealType: .lunch,
            ingredients: [
                MealIngredient(name: "Rice", baseGrams: 100, unit: "g"),
                MealIngredient(name: "Eggs", baseGrams: 2, unit: "pcs"),
                MealIngredient(name: "Carrot", baseGrams: 40, unit: "g"),
                MealIngredient(name: "Soy sauce", baseGrams: 15, unit: "ml"),
                MealIngredient(name: "Olive oil", baseGrams: 10, unit: "ml"),
            ],
            steps: ["Cook rice and let cool slightly", "Dice carrot, scramble eggs in oil", "Add rice and carrot to pan", "Stir-fry 3 min, add soy sauce"],
            prepTimeMinutes: 12,
            tags: ["protein", "carbs"]
        ),
        Recipe(
            title: "Quinoa Salad",
            mealType: .lunch,
            ingredients: [
                MealIngredient(name: "Quinoa", baseGrams: 80, unit: "g"),
                MealIngredient(name: "Cucumber", baseGrams: 80, unit: "g"),
                MealIngredient(name: "Tomato", baseGrams: 80, unit: "g"),
                MealIngredient(name: "Lemon juice", baseGrams: 15, unit: "ml"),
                MealIngredient(name: "Olive oil", baseGrams: 10, unit: "ml"),
            ],
            steps: ["Cook quinoa in water for 12 min", "Dice cucumber and tomato", "Fluff quinoa, mix with vegetables", "Dress with lemon juice and olive oil"],
            prepTimeMinutes: 15,
            tags: ["protein", "fiber", "vegetables"]
        ),
        Recipe(
            title: "Turkey Wrap",
            mealType: .lunch,
            ingredients: [
                MealIngredient(name: "Tortilla", baseGrams: 1, unit: "pcs"),
                MealIngredient(name: "Turkey breast", baseGrams: 80, unit: "g"),
                MealIngredient(name: "Lettuce", baseGrams: 30, unit: "g"),
                MealIngredient(name: "Tomato", baseGrams: 50, unit: "g"),
                MealIngredient(name: "Mustard", baseGrams: 10, unit: "g"),
            ],
            steps: ["Spread mustard on tortilla", "Layer turkey, lettuce, tomato slices", "Roll tightly and cut in half"],
            prepTimeMinutes: 5,
            tags: ["protein", "quick", "no-cook"]
        ),
        Recipe(
            title: "Chickpea Bowl",
            mealType: .lunch,
            ingredients: [
                MealIngredient(name: "Canned chickpeas", baseGrams: 150, unit: "g"),
                MealIngredient(name: "Cucumber", baseGrams: 60, unit: "g"),
                MealIngredient(name: "Tomato", baseGrams: 60, unit: "g"),
                MealIngredient(name: "Olive oil", baseGrams: 10, unit: "ml"),
                MealIngredient(name: "Lemon juice", baseGrams: 10, unit: "ml"),
                MealIngredient(name: "Salt", baseGrams: 1, unit: "pinch"),
            ],
            steps: ["Drain and rinse chickpeas", "Dice cucumber and tomato", "Mix everything in bowl", "Season with oil, lemon, and salt"],
            prepTimeMinutes: 5,
            tags: ["fiber", "protein", "no-cook"]
        ),
        Recipe(
            title: "Grilled Cheese with Soup",
            mealType: .lunch,
            ingredients: [
                MealIngredient(name: "Bread", baseGrams: 2, unit: "slices"),
                MealIngredient(name: "Cheese", baseGrams: 50, unit: "g"),
                MealIngredient(name: "Butter", baseGrams: 15, unit: "g"),
                MealIngredient(name: "Tomato", baseGrams: 200, unit: "g"),
                MealIngredient(name: "Salt", baseGrams: 1, unit: "pinch"),
            ],
            steps: ["Blend tomatoes, heat in pot with salt", "Butter bread, add cheese", "Grill sandwich in pan until golden", "Serve with tomato soup"],
            prepTimeMinutes: 10,
            tags: ["warm", "protein"]
        ),
        Recipe(
            title: "Sweet Potato Bowl",
            mealType: .lunch,
            ingredients: [
                MealIngredient(name: "Sweet potato", baseGrams: 150, unit: "g"),
                MealIngredient(name: "Olive oil", baseGrams: 5, unit: "ml"),
                MealIngredient(name: "Black beans", baseGrams: 80, unit: "g"),
                MealIngredient(name: "Salt", baseGrams: 1, unit: "pinch"),
                MealIngredient(name: "Cumin", baseGrams: 1, unit: "tsp"),
            ],
            steps: ["Dice sweet potato small", "Microwave sweet potato 5 min", "Heat black beans with cumin", "Combine in bowl, drizzle oil"],
            prepTimeMinutes: 8,
            tags: ["fiber", "protein", "vegetables"]
        ),
        Recipe(
            title: "Couscous with Vegetables",
            mealType: .lunch,
            ingredients: [
                MealIngredient(name: "Couscous", baseGrams: 80, unit: "g"),
                MealIngredient(name: "Bell pepper", baseGrams: 60, unit: "g"),
                MealIngredient(name: "Zucchini", baseGrams: 60, unit: "g"),
                MealIngredient(name: "Olive oil", baseGrams: 10, unit: "ml"),
                MealIngredient(name: "Lemon juice", baseGrams: 10, unit: "ml"),
            ],
            steps: ["Pour boiling water over couscous, cover 5 min", "Dice and sauté vegetables in oil", "Fluff couscous, mix with vegetables", "Add lemon juice"],
            prepTimeMinutes: 10,
            tags: ["quick", "vegetables", "fiber"]
        ),
        Recipe(
            title: "Bean and Corn Salad",
            mealType: .lunch,
            ingredients: [
                MealIngredient(name: "Canned beans", baseGrams: 100, unit: "g"),
                MealIngredient(name: "Corn", baseGrams: 80, unit: "g"),
                MealIngredient(name: "Tomato", baseGrams: 80, unit: "g"),
                MealIngredient(name: "Olive oil", baseGrams: 10, unit: "ml"),
                MealIngredient(name: "Lime juice", baseGrams: 10, unit: "ml"),
            ],
            steps: ["Drain beans and corn", "Dice tomato", "Mix all ingredients", "Dress with oil and lime juice"],
            prepTimeMinutes: 5,
            tags: ["fiber", "protein", "no-cook"]
        ),
        Recipe(
            title: "Mushroom Rice",
            mealType: .lunch,
            ingredients: [
                MealIngredient(name: "Rice", baseGrams: 80, unit: "g"),
                MealIngredient(name: "Mushrooms", baseGrams: 100, unit: "g"),
                MealIngredient(name: "Onion", baseGrams: 40, unit: "g"),
                MealIngredient(name: "Butter", baseGrams: 10, unit: "g"),
                MealIngredient(name: "Salt", baseGrams: 1, unit: "pinch"),
            ],
            steps: ["Cook rice", "Slice mushrooms and onion", "Sauté in butter until golden", "Mix with rice, season with salt"],
            prepTimeMinutes: 15,
            tags: ["warm", "fiber"]
        ),
    ]

    // MARK: - Dinners (14 recipes, 8-15 min each)

    static let dinners: [Recipe] = [
        Recipe(
            title: "Baked Salmon with Greens",
            mealType: .dinner,
            ingredients: [
                MealIngredient(name: "Salmon fillet", baseGrams: 150, unit: "g"),
                MealIngredient(name: "Broccoli", baseGrams: 100, unit: "g"),
                MealIngredient(name: "Olive oil", baseGrams: 10, unit: "ml"),
                MealIngredient(name: "Lemon juice", baseGrams: 10, unit: "ml"),
                MealIngredient(name: "Salt", baseGrams: 1, unit: "pinch"),
            ],
            steps: ["Season salmon with salt and lemon", "Place salmon and broccoli on tray with oil", "Bake at 200C for 12 min"],
            prepTimeMinutes: 15,
            tags: ["protein", "omega-3", "vegetables"]
        ),
        Recipe(
            title: "Chicken Stir-Fry",
            mealType: .dinner,
            ingredients: [
                MealIngredient(name: "Chicken breast", baseGrams: 150, unit: "g"),
                MealIngredient(name: "Bell pepper", baseGrams: 80, unit: "g"),
                MealIngredient(name: "Broccoli", baseGrams: 80, unit: "g"),
                MealIngredient(name: "Soy sauce", baseGrams: 15, unit: "ml"),
                MealIngredient(name: "Olive oil", baseGrams: 10, unit: "ml"),
            ],
            steps: ["Slice chicken and vegetables", "Stir-fry chicken in oil 5 min", "Add vegetables, cook 3 min", "Add soy sauce, toss and serve"],
            prepTimeMinutes: 12,
            tags: ["protein", "vegetables"]
        ),
        Recipe(
            title: "Spaghetti Aglio e Olio",
            mealType: .dinner,
            ingredients: [
                MealIngredient(name: "Spaghetti", baseGrams: 100, unit: "g"),
                MealIngredient(name: "Garlic", baseGrams: 3, unit: "cloves"),
                MealIngredient(name: "Olive oil", baseGrams: 20, unit: "ml"),
                MealIngredient(name: "Red pepper flakes", baseGrams: 1, unit: "pinch"),
                MealIngredient(name: "Parsley", baseGrams: 5, unit: "g"),
            ],
            steps: ["Boil spaghetti", "Slice garlic, sauté in olive oil", "Add pepper flakes", "Toss pasta with garlic oil and parsley"],
            prepTimeMinutes: 12,
            tags: ["carbs", "quick"]
        ),
        Recipe(
            title: "Turkey Meatballs",
            mealType: .dinner,
            ingredients: [
                MealIngredient(name: "Ground turkey", baseGrams: 150, unit: "g"),
                MealIngredient(name: "Onion", baseGrams: 30, unit: "g"),
                MealIngredient(name: "Bread crumbs", baseGrams: 20, unit: "g"),
                MealIngredient(name: "Egg", baseGrams: 1, unit: "pcs"),
                MealIngredient(name: "Salt", baseGrams: 1, unit: "pinch"),
            ],
            steps: ["Grate onion, mix with turkey, egg, breadcrumbs, salt", "Form small balls", "Pan-fry in oil 8 min, turning occasionally"],
            prepTimeMinutes: 12,
            tags: ["protein"]
        ),
        Recipe(
            title: "Vegetable Curry",
            mealType: .dinner,
            ingredients: [
                MealIngredient(name: "Potato", baseGrams: 100, unit: "g"),
                MealIngredient(name: "Carrot", baseGrams: 60, unit: "g"),
                MealIngredient(name: "Canned coconut milk", baseGrams: 100, unit: "ml"),
                MealIngredient(name: "Curry powder", baseGrams: 1, unit: "tbsp"),
                MealIngredient(name: "Olive oil", baseGrams: 5, unit: "ml"),
                MealIngredient(name: "Rice", baseGrams: 80, unit: "g"),
            ],
            steps: ["Cook rice", "Dice potato and carrot small", "Sauté vegetables, add curry powder", "Pour coconut milk, simmer 10 min", "Serve over rice"],
            prepTimeMinutes: 15,
            tags: ["vegetables", "warm", "fiber"]
        ),
        Recipe(
            title: "Pan-Fried Fish with Salad",
            mealType: .dinner,
            ingredients: [
                MealIngredient(name: "White fish fillet", baseGrams: 150, unit: "g"),
                MealIngredient(name: "Lettuce", baseGrams: 60, unit: "g"),
                MealIngredient(name: "Tomato", baseGrams: 60, unit: "g"),
                MealIngredient(name: "Olive oil", baseGrams: 10, unit: "ml"),
                MealIngredient(name: "Lemon juice", baseGrams: 10, unit: "ml"),
                MealIngredient(name: "Salt", baseGrams: 1, unit: "pinch"),
            ],
            steps: ["Season fish with salt", "Pan-fry in oil 4 min each side", "Chop lettuce and tomato", "Serve fish with salad and lemon"],
            prepTimeMinutes: 10,
            tags: ["protein", "vegetables"]
        ),
        Recipe(
            title: "Stuffed Bell Peppers",
            mealType: .dinner,
            ingredients: [
                MealIngredient(name: "Bell pepper", baseGrams: 1, unit: "pcs"),
                MealIngredient(name: "Rice", baseGrams: 60, unit: "g"),
                MealIngredient(name: "Ground beef", baseGrams: 100, unit: "g"),
                MealIngredient(name: "Tomato", baseGrams: 50, unit: "g"),
                MealIngredient(name: "Salt", baseGrams: 1, unit: "pinch"),
            ],
            steps: ["Cook rice halfway", "Mix rice with beef, diced tomato, salt", "Stuff peppers, place in pan with water", "Cover, cook 12 min on medium heat"],
            prepTimeMinutes: 15,
            tags: ["protein", "vegetables"]
        ),
        Recipe(
            title: "Shrimp with Garlic Butter",
            mealType: .dinner,
            ingredients: [
                MealIngredient(name: "Shrimp", baseGrams: 150, unit: "g"),
                MealIngredient(name: "Garlic", baseGrams: 2, unit: "cloves"),
                MealIngredient(name: "Butter", baseGrams: 15, unit: "g"),
                MealIngredient(name: "Lemon juice", baseGrams: 10, unit: "ml"),
                MealIngredient(name: "Bread", baseGrams: 2, unit: "slices"),
            ],
            steps: ["Mince garlic, melt butter in pan", "Add shrimp, cook 2 min each side", "Squeeze lemon over shrimp", "Serve with toasted bread"],
            prepTimeMinutes: 8,
            tags: ["protein", "quick"]
        ),
        Recipe(
            title: "Black Bean Tacos",
            mealType: .dinner,
            ingredients: [
                MealIngredient(name: "Tortilla", baseGrams: 2, unit: "pcs"),
                MealIngredient(name: "Black beans", baseGrams: 100, unit: "g"),
                MealIngredient(name: "Tomato", baseGrams: 60, unit: "g"),
                MealIngredient(name: "Lettuce", baseGrams: 30, unit: "g"),
                MealIngredient(name: "Lime juice", baseGrams: 10, unit: "ml"),
            ],
            steps: ["Heat beans with salt and cumin", "Dice tomato, shred lettuce", "Warm tortillas", "Fill with beans, top with veggies and lime"],
            prepTimeMinutes: 8,
            tags: ["fiber", "protein"]
        ),
        Recipe(
            title: "Zucchini Noodles with Pesto",
            mealType: .dinner,
            ingredients: [
                MealIngredient(name: "Zucchini", baseGrams: 200, unit: "g"),
                MealIngredient(name: "Pesto", baseGrams: 30, unit: "g"),
                MealIngredient(name: "Cherry tomatoes", baseGrams: 60, unit: "g"),
                MealIngredient(name: "Olive oil", baseGrams: 5, unit: "ml"),
            ],
            steps: ["Spiralize or grate zucchini into noodles", "Halve cherry tomatoes", "Sauté zucchini noodles 2 min in oil", "Toss with pesto and tomatoes"],
            prepTimeMinutes: 8,
            tags: ["low-carb", "vegetables"]
        ),
        Recipe(
            title: "Chicken Soup",
            mealType: .dinner,
            ingredients: [
                MealIngredient(name: "Chicken breast", baseGrams: 120, unit: "g"),
                MealIngredient(name: "Carrot", baseGrams: 60, unit: "g"),
                MealIngredient(name: "Potato", baseGrams: 80, unit: "g"),
                MealIngredient(name: "Onion", baseGrams: 40, unit: "g"),
                MealIngredient(name: "Salt", baseGrams: 1, unit: "pinch"),
            ],
            steps: ["Dice all vegetables and chicken small", "Bring 500ml water to boil", "Add chicken and vegetables", "Simmer 12 min, season with salt"],
            prepTimeMinutes: 15,
            tags: ["protein", "warm", "vegetables"]
        ),
        Recipe(
            title: "Egg and Vegetable Skillet",
            mealType: .dinner,
            ingredients: [
                MealIngredient(name: "Eggs", baseGrams: 3, unit: "pcs"),
                MealIngredient(name: "Tomato", baseGrams: 100, unit: "g"),
                MealIngredient(name: "Bell pepper", baseGrams: 60, unit: "g"),
                MealIngredient(name: "Onion", baseGrams: 40, unit: "g"),
                MealIngredient(name: "Olive oil", baseGrams: 10, unit: "ml"),
            ],
            steps: ["Dice vegetables", "Sauté onion and pepper 3 min", "Add tomato, cook 2 min", "Crack eggs on top, cover until set"],
            prepTimeMinutes: 10,
            tags: ["protein", "vegetables"]
        ),
        Recipe(
            title: "Beef and Broccoli",
            mealType: .dinner,
            ingredients: [
                MealIngredient(name: "Beef strips", baseGrams: 150, unit: "g"),
                MealIngredient(name: "Broccoli", baseGrams: 120, unit: "g"),
                MealIngredient(name: "Soy sauce", baseGrams: 15, unit: "ml"),
                MealIngredient(name: "Garlic", baseGrams: 2, unit: "cloves"),
                MealIngredient(name: "Olive oil", baseGrams: 10, unit: "ml"),
            ],
            steps: ["Cut broccoli into florets", "Stir-fry beef strips with garlic 3 min", "Add broccoli, cook 4 min", "Add soy sauce, toss and serve"],
            prepTimeMinutes: 10,
            tags: ["protein", "vegetables"]
        ),
        Recipe(
            title: "Mediterranean Plate",
            mealType: .dinner,
            ingredients: [
                MealIngredient(name: "Hummus", baseGrams: 80, unit: "g"),
                MealIngredient(name: "Cucumber", baseGrams: 80, unit: "g"),
                MealIngredient(name: "Tomato", baseGrams: 80, unit: "g"),
                MealIngredient(name: "Bread", baseGrams: 2, unit: "slices"),
                MealIngredient(name: "Olive oil", baseGrams: 10, unit: "ml"),
            ],
            steps: ["Slice cucumber and tomato", "Arrange hummus, vegetables on plate", "Toast bread, drizzle olive oil", "Serve as a platter"],
            prepTimeMinutes: 5,
            tags: ["no-cook", "fiber", "healthy-fats"]
        ),
    ]
}
