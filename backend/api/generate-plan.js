export default async function handler(req, res) {
  // Only POST allowed
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  // Validate app secret (prevents abuse if URL is discovered)
  const appSecret = req.headers['x-app-secret'];
  if (!appSecret || appSecret !== process.env.APP_SECRET) {
    return res.status(401).json({ error: 'Unauthorized' });
  }

  const {
    familyMembers = [],
    allergies = [],
    availableIngredients = [],
    mealPreferences = '',
    date = new Date().toDateString()
  } = req.body;

  // Build family description
  const familyDesc = familyMembers
    .map(m => `${m.name} (${m.isChild ? 'child' : 'adult'})`)
    .join(', ');

  const allergyDesc = allergies.length > 0
    ? `Allergies/restrictions: ${allergies.join(', ')}.`
    : 'No known allergies.';

  const ingredientDesc = availableIngredients.length > 0
    ? `Preferred ingredients to use: ${availableIngredients.join(', ')}.`
    : 'No specific ingredient preferences.';

  const prefDesc = mealPreferences.trim().length > 0
    ? `Additional preferences: ${mealPreferences.trim()}`
    : '';

  const systemPrompt = `You are a professional meal planning assistant.
Generate a nutritious, varied, and practical daily meal plan for a family.
Always return ONLY valid JSON — no markdown, no extra text.`;

  const userPrompt = `Create a daily meal plan for: ${familyDesc}.
${allergyDesc}
${ingredientDesc}
${prefDesc}
Date: ${date}

Return JSON in exactly this structure:
{
  "breakfast": {
    "title": "Meal name",
    "ingredients": [
      { "name": "ingredient name", "baseGrams": 100, "unit": "g" }
    ],
    "steps": ["Step 1 instruction", "Step 2 instruction"],
    "prepTimeMinutes": 15
  },
  "lunch": { ... same structure ... },
  "dinner": { ... same structure ... }
}

Rules:
- Each meal must have 4-7 ingredients
- Each meal must have 3-5 cooking steps
- prepTimeMinutes must be a realistic number (5-45)
- Vary the meals — do not repeat proteins or cuisines
- Respect all allergies strictly
- Use metric units (g, ml, tbsp, tsp, pieces)`;

  try {
    const response = await fetch('https://api.openai.com/v1/responses', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${process.env.OPENAI_API_KEY}`
      },
      body: JSON.stringify({
        model: 'gpt-4o-mini',
        input: [
          { role: 'system', content: systemPrompt },
          { role: 'user', content: userPrompt }
        ],
        temperature: 0.85,
        max_output_tokens: 2000,
        text: { format: { type: 'json_object' } }
      })
    });

    if (!response.ok) {
      const err = await response.text();
      console.error('OpenAI error:', err);
      return res.status(502).json({ error: 'OpenAI request failed' });
    }

    const data = await response.json();
    const content = JSON.parse(data.output[0].content[0].text);

    // Validate expected structure
    if (!content.breakfast || !content.lunch || !content.dinner) {
      return res.status(502).json({ error: 'Invalid response structure from OpenAI' });
    }

    return res.status(200).json(content);

  } catch (error) {
    console.error('Handler error:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
}
