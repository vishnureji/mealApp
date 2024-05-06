import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recipeapp/models/meals_model.dart';
import 'package:dio/dio.dart';
import 'package:recipeapp/screens/MealDetailScreen.dart';

final dio = Dio();

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffF4612D),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          leading: const CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white,
            child: Icon(Icons.person_outline_rounded),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(110.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(
                    child: ColoredBox(
                      color: Colors.white,
                      child: TextField(
                        maxLines: 1,
                        decoration: InputDecoration(fillColor: Colors.white),
                      ),
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.sort))
                ],
              ),
            ),
          ),
        ),
        body: FutureBuilder<Meals>(
          future: fetchMeals(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: snapshot.data!.meals.length,
                itemBuilder: (context, index) {
                  var meal = snapshot.data!.meals[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MealDetailScreen(mealId: meal.idMeal),
                        ),
                      );
                    },
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          Image.network(meal.strMealThumb),
                          Text(meal.strMeal),
                          Text(meal.idMeal),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ));
  }

  Future<Meals> fetchMeals() async {
    final response = await Dio()
        .get('https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood');
    if (response.statusCode == 200) {
      return Meals.fromJson(response.data);
    } else {
      throw Exception('Failed to load meals');
    }
  }
}
