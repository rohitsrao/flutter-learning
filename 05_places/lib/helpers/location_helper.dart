import '../config.dart';

class LocationHelper {
  
  static String generateLocationPreviewImage({required double latitude, required double longitude}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$GOOGLE_MAPS_API_KEY';
  }
}
