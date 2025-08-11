import 'package:zaika/features/refer%20and%20earn/domain/model/earn_refer.dart';

abstract class EarnReferRepositoryInterface{
  Future<TransactionHistoryResponse?> getEarnReferData({required int page});
}