import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {

  final List<Transaction> transactions;
  final Function deleteTransaction;

  //Constructor
  TransactionList(this.transactions, this.deleteTransaction);

  //build method
  @override
  Widget build(BuildContext context) {
    return (
      //List of transactions column
        //We have a column of card widgets for each transaction
          //In each card we have a row which lets us position the price next to title and date
            //the price is inside its own container
            //the title and date are in a column
      transactions.isEmpty ? 
      LayoutBuilder(builder: (ctx, constraints) {
        return (
          Column(
            children: <Widget>[
              Text(
                'No Transactions added yet!',
                style: Theme.of(context).textTheme.title,
              ),
              SizedBox(
                height: 20
              ),
              Container(
                height: constraints.maxHeight * 0.6,
                child: Image.asset(
                  'assets/images/waiting.png',
                  fit: BoxFit.cover
                )
              )
            ]
          )
        );
      })
      : ListView.builder(
        itemBuilder: (ctx, index) {
          return (
            Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 5
              ),
              child: ListTile(
                //price in avatar
                leading: CircleAvatar(
                  radius: 30,
                  child: Padding(
                    padding: EdgeInsets.all(6),
                    child: FittedBox(
                      child: Text(
                        '\$${transactions[index].amount}'
                      )
                    )
                  )
                ),
                //transaction title
                title: Text(
                  transactions[index].title, 
                  style: Theme.of(context).textTheme.title
                ),
                //transaction date subtitle
                subtitle: Text(
                  DateFormat('MMM d, y').format(transactions[index].date),
                ),
                //delete icon
                trailing: MediaQuery.of(context).size.width > 450 ? 
                    FlatButton.icon(
                      textColor: Theme.of(context).errorColor,
                      icon: Icon(Icons.delete),
                      label: Text('Delete'),
                      onPressed: () => deleteTransaction(transactions[index].id)
                    )
                  : IconButton(
                      icon: Icon(
                        Icons.delete
                      ),
                      color: Theme.of(context).errorColor,
                      onPressed: () {
                        deleteTransaction(transactions[index].id);
                      }
                    )
              )
            )
          );
        },
        itemCount: transactions.length,
      )
    );
  }
}
