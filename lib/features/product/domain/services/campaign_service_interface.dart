import 'package:zaika/common/enums/data_source_enum.dart';
import 'package:zaika/common/models/product_model.dart';
import 'package:zaika/features/product/domain/models/basic_campaign_model.dart';

abstract class CampaignServiceInterface {
  Future<List<BasicCampaignModel>?> getBasicCampaignList();
  Future<List<Product>?> getItemCampaignList({DataSourceEnum? source});
  Future<BasicCampaignModel?> getCampaignDetails(String campaignID);
}