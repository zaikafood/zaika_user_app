import 'package:zaika/common/enums/data_source_enum.dart';
import 'package:zaika/features/home/domain/models/advertisement_model.dart';

abstract class AdvertisementServiceInterface {
  Future<List<AdvertisementModel>?> getAdvertisementList({required DataSourceEnum source});
}