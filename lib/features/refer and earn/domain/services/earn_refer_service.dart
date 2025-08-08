import 'package:zaika/features/refer%20and%20earn/domain/model/earn_refer.dart';
import 'package:zaika/features/refer%20and%20earn/domain/repositories/earn_refer_repository_interface.dart';
import 'package:zaika/features/refer%20and%20earn/domain/services/earn_refer_service_interface.dart';

class EarnReferService implements EarnReferServiceInterface{
 final EarnReferRepositoryInterface earnReferRepositoryInterface;
  EarnReferService({required this.earnReferRepositoryInterface});
  Future<TransactionHistoryResponse?> getEarnReferData({required int page}) async{
    return await  earnReferRepositoryInterface.getEarnReferData(page: page);
  }
}