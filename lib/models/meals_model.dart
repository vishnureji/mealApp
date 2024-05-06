class Meals {
  List<Meal> meals;

  Meals({
    required this.meals,
  });

  factory Meals.fromJson(Map<String, dynamic> json) {
    return Meals(
      meals: List<Meal>.from(json['meals'].map((x) => Meal.fromJson(x))),
    );
  }
}

class Meal {
  String strMeal;
  String strMealThumb;
  String idMeal;

  Meal({
    required this.strMeal,
    required this.strMealThumb,
    required this.idMeal,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      strMeal: json['strMeal'],
      strMealThumb: json['strMealThumb'],
      idMeal: json['idMeal'],
    );
  }
}
