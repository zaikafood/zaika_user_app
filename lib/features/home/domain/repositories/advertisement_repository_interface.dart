import 'package:zaika/common/enums/data_source_enum.dart';
import 'package:zaika/features/home/domain/models/advertisement_model.dart';
import 'package:zaika/interface/repository_interface.dart';

abstract class AdvertisementRepositoryInterface extends RepositoryInterface{
  @override
  Future<List<AdvertisementModel>?> getList({int? offset, DataSourceEnum? source});
}