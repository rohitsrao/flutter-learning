//Screen that shows the meals for a category.

import 'package:flutter/material.dart';

class CategoryMealsScreen extends StatelessWidget {

  final String id;
  final String title;

  CategoryMealsScreen(
    this.id,
    this.title
  );

  @override
  Widget build(BuildContext context){
    return (
      Scaffold(
        appBar: AppBar(
          title: Text(title) 
        ),
        body: Center(
          child: Text(
            'The Recipes for the category'
          )
        )
      )
    );
  }
}
