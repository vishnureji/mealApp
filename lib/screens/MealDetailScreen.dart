import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:recipeapp/models/meal_details_model.dart';

class MealDetailScreen extends StatelessWidget {
  final String mealId;

  const MealDetailScreen({super.key, required this.mealId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Detail'),
      ),
      body: FutureBuilder<Meal>(
        future: fetchMealDetails(mealId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var meal = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(meal.strMealThumb),
                  const SizedBox(height: 16.0),
                  Text(
                    meal.strMeal,
                    style: const TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Category: ${meal.strCategory}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Instructions: ${meal.strInstructions}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<Meal> fetchMealDetails(String mealId) async {
    final response = await Dio()
        .get('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$mealId');
    if (response.statusCode == 200) {
      return Meal.fromJson(response.data['meals'][0]);
    } else {
      throw Exception('Failed to load meal details');
    }
  }
}
