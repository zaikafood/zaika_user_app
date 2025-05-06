import 'package:zaika/common/enums/data_source_enum.dart';
import 'package:zaika/features/splash/domain/models/config_model.dart';
import 'package:get/get_connect/http/src/response/response.dart';

abstract class SplashServiceInterface {
  Future<Response> getConfigData({required DataSourceEnum? source});
  ConfigModel? prepareConfigData(Response response);
  Future<bool> initSharedData();
  bool? showIntro();
  void disableIntro();
  Future<void> saveCookiesData(bool data);
  bool getCookiesData();
  void cookiesStatusChange(String? data);
  bool getAcceptCookiesStatus(String data);
  Future<bool> subscribeMail(String email);
  void toggleTheme(bool darkTheme);
  Future<bool> loadCurrentTheme();
  bool getReferBottomSheetStatus();
  Future<void> saveReferBottomSheetStatus(bool data);
}