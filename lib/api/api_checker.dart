import 'package:zaika/features/auth/controllers/auth_controller.dart';
import 'package:zaika/features/favourite/controllers/favourite_controller.dart';
import 'package:zaika/helper/route_helper.dart';
import 'package:zaika/common/widgets/custom_snackbar_widget.dart';
import 'package:get/get.dart';

class ApiChecker {
  static final Map<String, String> errors = {};

  static void checkApi(Response response, {bool showToaster = false}) async{
    if(response.body != null && response.body['errors'] != null) {
      List errorFromApi = response.body['errors'] ?? [];
      for (var error in errorFromApi) {
        if (error['code'] != null && error['message'] != null) {
          errors[error['code']] = error['message'];
        }
      }
    }
    else if(response.statusCode == 401) {
      await Get.find<AuthController>().clearSharedData(removeToken: false).then((value) {
        Get.find<FavouriteController>().removeFavourites();
        Get.offAllNamed(RouteHelper.getInitialRoute());
      });
    }
    else {
      showCustomSnackBar(response.statusText);
    }
  }
  // static Future<void> checkApi(Response response, {bool showToaster = false}) async {
  //   if(response.statusCode == 401) {
  //     await Get.find<AuthController>().clearSharedData(removeToken: false).then((value) {
  //       Get.find<FavouriteController>().removeFavourites();
  //       Get.offAllNamed(RouteHelper.getInitialRoute());
  //     });
  //   } else {
  //     showCustomSnackBar(response.statusText);
  //   }
  // }
}
