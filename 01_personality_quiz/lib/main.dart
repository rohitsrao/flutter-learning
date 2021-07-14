import 'package:flutter/material.dart';

import './quiz.dart';
import './result.dart';

void main() => runApp(MyApp());

//Need to create a class in order to create a widget
class MyApp extends StatefulWidget{
	
	@override
	State<StatefulWidget> createState() {
		return _MyAppState();
	}
}

class _MyAppState extends State<MyApp> {
	
	var _questionIndex = 0;
	var _totalScore = 0;
	
	final _questions = const [
		{'questionText': 'What\'s your favorite color ?!', 
			'answers': [
				{'text': 'black', 'score': 10}, 
				{'text': 'red', 'score': 5},
				{'text': 'green', 'score': 3},
				{'text': 'white', 'score': 1}
			]
		},
		{'questionText': 'What\'s your favorite animal ?!', 
			'answers': [
				{'text': 'rabbit', 'score': 3},
				{'text': 'snake', 'score': 11},
				{'text': 'elephant', 'score': 5},
				{'text': 'lion', 'score': 9}
			]
		},
		{'questionText': 'What is your favorite car ?!', 
			'answers': [
				{'text': 'ferrari', 'score': 10},
				{'text': 'bmw', 'score': 5},
				{'text': 'pagani', 'score': 20},
				{'text': 'tesla', 'score': 1},
			 ]
		}
	];
	
	void _answerQuestion(int score) {
		
		//Increment total score
		_totalScore += score;
		
		setState(() {
			_questionIndex = _questionIndex + 1;
		});
		print(_questionIndex);
		if (_questionIndex < _questions.length) {
			print('We have more questions!');
		}
	}
	
	void _resetQuiz() {
		
		setState(() {
			_questionIndex = 0;
			_totalScore = 0;
		});
		print('ResetQuiz called');
	}
	
	@override
	Widget build(BuildContext context) {
		
		return MaterialApp(
			home: Scaffold(
				appBar: AppBar(
					title: Text('My First App'),
				),
				body: _questionIndex < _questions.length 
				? Quiz(
						answerQuestion:_answerQuestion, 
						questions:_questions,
						questionIndex: _questionIndex
					)
				: Result(_totalScore, _resetQuiz)
			),
		);
	}
}

//Code Explanation

//runApp runs Flutter App. It basically takes the
//widget tree and draws something based on it on the
//screen.
//The argument to runApp is an instance of the Widget
//in this case it is MyApp. runApp basically calls
//the build method of MyApp after instanciating it.

//The build method from StatelessWidget needs
//to be overwritten. It must accept an argument 
//of custom type BuildContext. The build method
//returns a widget.
//The build method is called by Flutter when it
//draws something on the screen.

//return a specifc MaterialApp widget
//present in material.dart that takes care
//of basic setup
//home is the core widget that Flutter will
//bring on to the screen when MyApp is mounted

//Scaffold() included as part of material.dart has the job of creating a base page design
//for the app. It will give a basic design, structure and color scheme for the app.
//Scaffold inturn takes in a few more named arguments. 
//one of these arguments is appBar which needs a PreferredSizeWidget provided by AppBar()
//which in turn accepts a TextWidget

//<Widget> is an annotation. Explicitly tells Dart that it is a list of Widgets. It is aka Generic Type

//setState is a function that forces Flutter to re-render the userInterface. Rather not the entire App. 
//but it only re-renders the widget where the setState method was called. Flutter knows what changed 
//on the screen and what needs to be redrawn. build method is getting called when setState is called
