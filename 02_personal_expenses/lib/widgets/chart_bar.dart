import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {

  //Properties
  final String label;
  final double spendingAmount;
  final double spendingPctOfTotal;

  //Constructor
  ChartBar(
    this.label,
    this.spendingAmount,
    this.spendingPctOfTotal
  );

  @override
  Widget build(BuildContext context) {
    return (
      LayoutBuilder(builder: (ctx, constraint) {
        return Column(
          children: <Widget>[
            //Amount text with dollar sign
            //FittedBox ensures that text does not overflow
            //and shrinks the text instead
            Container(
              height: constraint.maxHeight * 0.15,
              child: FittedBox(
                child: Text(
                  '\$${spendingAmount.toStringAsFixed(0)}'
                )
              ),
            ),
            //4px spacing box
            SizedBox(
              height: constraint.maxHeight * 0.05
            ),
            //Bar
            Container(
              height: constraint.maxHeight * 0.6,
              width: 10,
              child: Stack(
                children: <Widget>[
                  //Bottom most container
                  //Background bar
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1
                      ),
                      color: Color.fromRGBO(220, 220, 220, 1), //rgba
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  //Percentage bar
                  FractionallySizedBox(
                    heightFactor: spendingPctOfTotal,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10)
                      )
                    )
                  )
                ]
              )
            ),
            //4px spacing box
            SizedBox(
              height: constraint.maxHeight * 0.05
            ),
            //day of the week label
            Container(
              height: constraint.maxHeight * 0.15,
              child: FittedBox(
                child: Text(
                  label
                )
              )
            )
          ]
        );
      })
    );
  }
}
