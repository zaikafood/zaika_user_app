import 'package:zaika/features/auth/controllers/auth_controller.dart';
import 'package:zaika/features/profile/controllers/profile_controller.dart';
import 'package:zaika/features/profile/domain/models/userinfo_model.dart';
import 'package:get/get.dart';
import 'package:zaika/features/refer%20and%20earn/domain/services/earn_refer_service.dart';
import 'package:zaika/features/refer%20and%20earn/domain/services/earn_refer_service_interface.dart';

import '../domain/model/earn_refer.dart';

class ReferAndEarnController extends GetxController implements GetxService {
  final EarnReferServiceInterface earnReferServiceInterface;
  ReferAndEarnController({required this.earnReferServiceInterface});

  List<TransactionHistoryResponse>? _earninglistResponse=[];
  List<TransactionHistoryResponse>? get earninglistResponse => _earninglistResponse;

  List<TransactionData>? _earninglist=[];
  List<TransactionData>? get earningList => _earninglist;
  UserInfoModel? _userInfoModel;
  UserInfoModel? get userInfoModel => _userInfoModel;
  bool _isLoading=false;
  bool get isLoading  => _isLoading;

  int _page = 1;
  int? _lastPage;
  bool _isPaginating = false;
  bool get isPaginating => _isPaginating;


  void getUserInfo()
  {
  getInfo();
  getEarningList(isInitial: true);
  }
  Future<void> getInfo() async {
    if(Get.find<AuthController>().isLoggedIn() && Get.find<ProfileController>().userInfoModel == null) {
      await Get.find<ProfileController>().getUserInfo();
    }
    _userInfoModel = Get.find<ProfileController>().userInfoModel;
    update();
  }

getEarningList({bool isInitial = false}) async{
  if (_isPaginating || (isInitial && _isLoading)) return;
  if (isInitial) {
    _page = 1;
    _isLoading = true;
    _earninglist = [];
    update();
  } else {

    if (_page >= (_lastPage ?? 1)) {
      return;
    }
    _isPaginating = true;
    _page++;
    update();
  }
  _isLoading=true;
  _earninglist = [];
  update();
  final response=  await earnReferServiceInterface.getEarnReferData(page: _page);
  if(response != null){
    if (isInitial) {
      _earninglist = response.data;
    }
    else {
      _earninglist?.addAll(response.data);
    }
    _lastPage = response.lastPage;
  }
  if (isInitial) {
    _isLoading = false;
  } else {
    _isPaginating = false;
  }
update();
}

}