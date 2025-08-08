import '../model/earn_refer.dart';

abstract class EarnReferServiceInterface{
  Future<TransactionHistoryResponse?> getEarnReferData({required int page});
}