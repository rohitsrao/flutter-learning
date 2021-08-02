import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';
import './widgets/transaction_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        //textTheme for general titles and buttons
        textTheme: ThemeData.light().textTheme.copyWith(
          title: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
            fontSize: 18
          ),
          button: TextStyle(
            color: Colors.white,
          )
        ),
        //appBar theme
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold
            )
          )
        )
      )
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //Defining the list of transactions
  final List<Transaction> _userTransactions = [
//    //Dummy transaction 1
//    Transaction(
//      id: 't1',
//      title: 'New Shoes',
//      amount: 69.99,
//      date: DateTime.now()
//    ),
//    //Dummy transaction 2
//    Transaction(
//      id: 't2',
//      title: 'Weekly Groceries',
//      amount: 16.53,
//      date: DateTime.now()
//    )
  ];

  //Chart Switch booleans
  bool _showChart = false;

  //Defining a list of recent transactions
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  //function to add transaction to list
  void _addNewTransaction(String txTitle, double txAmount, DateTime chosenDate) {
    
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: chosenDate
    );
    
    setState(() {
      _userTransactions.add(newTx);
    });
    
  }

  //function to delete a transaction from a list
  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  //Function to start the process of adding a
  //transaction by bringing up the input fields
  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        //return the widget you want to show inside 
        //the modal sheet
        return (
          NewTransaction(_addNewTransaction)
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    //variable to store the Media Query Object
    final mediaQuery = MediaQuery.of(context);
    
    //Defining a variable to store the screen orientation
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    
    //Defining app bar
    final PreferredSizeWidget appBar = Platform.isIOS ? 
      CupertinoNavigationBar(
        middle: Text('Personal Expenses'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
              child: Icon(CupertinoIcons.add),
              onTap: () => _startAddNewTransaction(context)
            )
          ]
        )
      )
      : AppBar(
        title: Text(
          'Personal Expenses',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add
            ),
            onPressed: () => _startAddNewTransaction(context)
          )
        ]
      );

    //Defining transaction list widget as a constant
    final txListWidget = Container(
      height: (mediaQuery.size.height 
              - appBar.preferredSize.height
              - mediaQuery.padding.top
              ) * 0.7,
      child: TransactionList(_userTransactions, _deleteTransaction)
    );

    //Storing body in a separate variable
    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //Switch Widget to enable to disable landscape mode
            //show switch only if device is in landscape mode
            if (isLandscape) Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Show Chart',
                  style: Theme.of(context).textTheme.title,
                ),
                Switch.adaptive(
                  activeColor: Theme.of(context).accentColor,
                  value: _showChart,
                  onChanged: (val) {
                    setState(() {
                      _showChart = val;
                    });
                  }
                )
              ]
            ),
            if (!isLandscape) Container(
              height: (mediaQuery.size.height 
                      - appBar.preferredSize.height
                      - mediaQuery.padding.top
                      ) * 0.3,
              child: Chart(_recentTransactions),
            ),
            if (!isLandscape) txListWidget,
            if (isLandscape) _showChart ?
            //Chart Container
            Container(
              height: (mediaQuery.size.height 
                      - appBar.preferredSize.height
                      - mediaQuery.padding.top
                      ) * 0.7,
              child: Chart(_recentTransactions),
            )
            //Transaction List Container
            : txListWidget
          ]
        )
      )
    );

    return ( 
      Platform.isIOS ? 
        CupertinoPageScaffold(
          child: pageBody,
          navigationBar: appBar
        )
        : Scaffold(
          //appBar
          appBar: appBar,
          //body
          body: pageBody,
          //floating action button
          floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add
            ),
            onPressed: () => _startAddNewTransaction(context)
          ),
          floatingActionButtonLocation: Platform.isIOS ? 
            Container()
          : FloatingActionButtonLocation.centerDocked
        )
    );
  }
}
