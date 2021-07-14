import 'package:flutter/material.dart';

class Result extends StatelessWidget {
	
	final int _resultScore;
	final Function resetHandler;
	
	//Constructor
	Result(this._resultScore, this.resetHandler);
	
	String get resultPhrase {
		
		String resultText;
		
		if (_resultScore <= 8) {
			resultText = 'You are awesome and innocent';
		} else if (_resultScore <= 12){
			resultText = 'Pretty Likeable';
		}else if (_resultScore <= 16){
			resultText = 'You are ... strange ?!';
		}else {
			resultText = 'You are so bad!';
		}
		
		return resultText;
	}
	
	@override
	Widget build(BuildContext context) {
		return Center(
			child: Column(
				children: <Widget>[
					Text(
						resultPhrase,
						style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
						textAlign: TextAlign.center
					),
					FlatButton(
						child: Text('Restart Quiz'),
						textColor: Colors.blue,
						onPressed: resetHandler
					)
				]
			)
		);
	}
}
