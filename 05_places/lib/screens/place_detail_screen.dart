import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './map_screen.dart';
import '../models/place.dart';
import '../providers/great_places.dart';

class PlaceDetailScreen extends StatelessWidget {

  static const routeName = '/place-detail';

  @override
  Widget build(BuildContext context){
    final id = ModalRoute.of(context)?.settings.arguments;
    final selectedPlace = Provider.of<GreatPlaces>(context, listen: false).findById(id as String);
    return (
      Scaffold(
        appBar: AppBar(
          title: Text(selectedPlace.title),
        ),
        body: Column(
          children: <Widget>[
            Container(
              height: 250,
              width: double.infinity,
              child: Image.file(
                selectedPlace.image,
                fit: BoxFit.cover,
                width: double.infinity,
              )
            ),
            SizedBox(height: 20),
            Text(
              selectedPlace.location?.address as String,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              )
            ),
            SizedBox(height: 20),
            FlatButton(
              child: Text(
                'View on Map',
              ),
              textColor: Theme.of(context).primaryColor,
              onPressed: () {
                print('--------------------------------');
                print('Inside Place Detail Screen');
                print(selectedPlace.location?.latitude);
                print(selectedPlace.location?.longitude);
                print('--------------------------------');
                Navigator.of(context).push(
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => MapScreen(
                      initialLocation: selectedPlace.location as PlaceLocation,
                      isSelecting: false,
                    ),
                  )
                );
              },
            ),
          ]
        ),
      )
    );
  }
}
