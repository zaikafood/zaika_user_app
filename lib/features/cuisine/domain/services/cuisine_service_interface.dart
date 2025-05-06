import 'package:zaika/common/enums/data_source_enum.dart';
import 'package:zaika/features/cuisine/domain/models/cuisine_model.dart';
import 'package:zaika/features/cuisine/domain/models/cuisine_restaurants_model.dart';

abstract class CuisineServiceInterface{
  Future<CuisineModel?> getCuisineList({DataSourceEnum? source});
  List<int?> generateCuisineIds(CuisineModel? cuisineModel);
  Future<CuisineRestaurantModel?> getRestaurantList(int offset, int cuisineId);
}