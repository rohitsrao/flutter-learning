import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {

  //Properties
  //defining a list of transactions that stores
  //the transactions for the last 7 days. 
  final List<Transaction> recentTransactions;
    
  //Constructor
  Chart(this.recentTransactions);
    
  //Defining a getter function that returns a list of maps
  List<Map<String, Object>> get groupedTransactionValues {
    return (
      //Applies a function for every index in the list
      List.generate(7, (index) {
        
        //Figure out which weekday
        final weekDay = DateTime.now().subtract(Duration(days: index));
       
        //Compute total transactions for that weekday
        double totalSum = 0.0;
        
        for (var i = 0; i < recentTransactions.length; i++) {
          if (recentTransactions[i].date.day == weekDay.day && 
              recentTransactions[i].date.month == weekDay.month && 
              recentTransactions[i].date.year == weekDay.year) {
            totalSum += recentTransactions[i].amount;
          }
        }
        
        return (
          //Return a map
          {
            'day': DateFormat.E().format(weekDay).substring(0, 1),
            'amount': totalSum,
          }
        );
      }).reversed.toList()
    );
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return (
      Card(
        elevation: 6,
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransactionValues.map((data) {
              return (
                Flexible(
                  fit: FlexFit.tight,
                  child: ChartBar(
                    data['day'], //label
                    data['amount'], //spendingAmount
                    totalSpending==0.0 ? 0.0 : (data['amount'] as double)/totalSpending
                  )
                )
              );
            }).toList()
          )
        )
      )
    );
  }
}
