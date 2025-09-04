import 'package:zaika/common/enums/data_source_enum.dart';
import 'package:zaika/features/home/domain/models/banner_model.dart';
import 'package:zaika/features/home/domain/models/cashback_model.dart';
import 'package:zaika/interface/repository_interface.dart';

import '../../../dashboard/model/StockCount.dart';

abstract class HomeRepositoryInterface extends RepositoryInterface {
  @override
  Future<BannerModel?> getList({int? offset, DataSourceEnum? source});
  Future<List<CashBackModel>?> getCashBackOfferList({DataSourceEnum? source});
  Future<CashBackModel?> getCashBackData(double amount);
  Future<StockModel> getStock();
}