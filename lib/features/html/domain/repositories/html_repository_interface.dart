import 'package:zaika/features/html/enums/html_type.dart';
import 'package:zaika/interface/repository_interface.dart';
import 'package:get/get_connect/http/src/response/response.dart';

abstract class HtmlRepositoryInterface extends RepositoryInterface {
  Future<Response> getHtmlText(HtmlType htmlType, String languageCode);
}