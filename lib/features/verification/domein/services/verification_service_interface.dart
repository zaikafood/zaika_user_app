import 'package:zaika/common/models/response_model.dart';
import 'package:zaika/features/verification/domein/model/verification_data_model.dart';

abstract class VerificationServiceInterface{
  Future<ResponseModel> forgetPassword(String? phone);
  Future<ResponseModel> verifyToken(String? phone, String verificationCode);
  Future<ResponseModel> resetPassword(String? resetToken, String number, String password, String confirmPassword);
  Future<ResponseModel> checkEmail(String email);
  Future<ResponseModel> verifyEmail(String email, String token, String verificationCode);
  Future<ResponseModel> verifyPhone(VerificationDataModel data);
  Future<ResponseModel> verifyFirebaseOtp({required String phoneNumber, required String session, required String otp, required String loginType, required String? token, required bool isSignUpPage, required bool isForgetPassPage});
}