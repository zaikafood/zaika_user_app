import 'package:zaika/interface/repository_interface.dart';

import '../../model/StockCount.dart';

abstract class DashboardRepoInterface implements RepositoryInterface {
  Future<bool> saveRegistrationSuccessful(bool status);
  Future<bool> saveIsRestaurantRegistration(bool status);
  bool getRegistrationSuccessful();
  bool getIsRestaurantRegistration();

}