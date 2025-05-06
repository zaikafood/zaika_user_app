import 'package:zaika/common/enums/data_source_enum.dart';
import 'package:zaika/interface/repository_interface.dart';

abstract class CampaignRepositoryInterface implements RepositoryInterface {
  @override
  Future<dynamic> getList({int? offset, bool basicCampaign = false, DataSourceEnum? source});
}