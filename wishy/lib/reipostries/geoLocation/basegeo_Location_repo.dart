import 'package:geolocator/geolocator.dart';

abstract class BaseGeloloctionRepository{
  Future<Position?> getCurrentLocation() async{
    return null;
  }
}