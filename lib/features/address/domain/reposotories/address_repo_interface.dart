import 'package:zaika/common/enums/data_source_enum.dart';
import 'package:zaika/features/address/domain/models/address_model.dart';
import 'package:zaika/interface/repository_interface.dart';

abstract class AddressRepoInterface<T> implements RepositoryInterface<AddressModel> {
  @override
  Future<List<AddressModel>?> getList({int? offset, bool isLocal = false, DataSourceEnum? source});
}