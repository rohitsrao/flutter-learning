import 'dart:io';
import 'package:flutter/foundation.dart';

import '../helpers/db_helper.dart';
import '../helpers/location_helper.dart';
import '../models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Place findById(String id) {
    return _items.firstWhere((place) => place.id == id);
  }

  Future<void> addPlace(
    String pickedTitle, 
    File pickedImage,
    PlaceLocation pickedLocation,
  ) async {
    final address = await LocationHelper.getPlaceAddress(pickedLocation.latitude, pickedLocation.longitude);
    final processedPickedLocation = PlaceLocation(
      latitude: pickedLocation.latitude, 
      longitude: pickedLocation.longitude, 
      address: address,
    );
    final newPlace = Place(
      id: DateTime.now().toString(),
      image: pickedImage,
      title: pickedTitle,
      location: processedPickedLocation,
    );
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location?.latitude as double,
      'loc_lng': newPlace.location?.longitude as double,
      'address': newPlace.location?.address as String,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _items = dataList
      .map(
        (item) => Place(
          id: item['id'],
          title: item['title'],
          image: File(item['image']),
          location: PlaceLocation(
            latitude: item['loc_lat'],
            longitude: item['loc_lng'],
            address: item['address'],
          )
        )
      )
      .toList();
    notifyListeners();
  }
}
