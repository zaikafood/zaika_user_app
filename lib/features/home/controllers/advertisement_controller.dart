import 'package:get/get.dart';
import 'package:zaika/common/enums/data_source_enum.dart';
import 'package:zaika/features/home/domain/models/advertisement_model.dart';
import 'package:zaika/features/home/domain/services/advertisement_service_interface.dart';

class AdvertisementController extends GetxController implements GetxService {
  final AdvertisementServiceInterface advertisementServiceInterface;
  AdvertisementController({required this.advertisementServiceInterface});

  List<AdvertisementModel>? _advertisementList;
  List<AdvertisementModel>? get advertisementList => _advertisementList;

  bool _showSkip = false;
  bool get showSkip => _showSkip;

  void showSkipButton() {
    _showSkip = true;
    update();
  }

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  Duration autoPlayDuration = const Duration(seconds: 100);

  bool autoPlay = true;

  Future<void> getAdvertisementList({DataSourceEnum dataSource = DataSourceEnum.local, bool fromRecall = false}) async {
    if(!fromRecall) {
      _advertisementList = null;
    }
    List<AdvertisementModel>? advertisementList;
    if(dataSource == DataSourceEnum.local) {
      advertisementList = await advertisementServiceInterface.getAdvertisementList(source: DataSourceEnum.local);
      _prepareAdvertisement(advertisementList);
      getAdvertisementList(dataSource: DataSourceEnum.client, fromRecall: true);
    } else {
      advertisementList = await advertisementServiceInterface.getAdvertisementList(source: DataSourceEnum.client);
      _prepareAdvertisement(advertisementList);
    }
  }

  _prepareAdvertisement(List<AdvertisementModel>? advertisementList) {
    if (advertisementList != null) {
      _advertisementList = [];
      _advertisementList = advertisementList;
    }
    update();
  }

  void setCurrentIndex(int index, bool notify) {
    _currentIndex = index;
    if(notify) {
      update();
    }
  }

  void updateAutoPlayStatus({bool shouldUpdate = false, bool status = false}){
    autoPlay = status;
    if(shouldUpdate){
      update();
    }
  }

}