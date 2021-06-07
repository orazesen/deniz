import 'package:get/get.dart';
import 'package:saray_pub/models/banner.dart';

class BannersController extends GetxController {
  RxList<Banner> _banners = List<Banner>().obs;

  List<Banner> get banners {
    return [..._banners];
  }

  set banners(List<Banner> bans) {
    _banners = RxList<Banner>(bans);
  }

  Future<void> setBanners(List<Banner> temp) async {
    _banners = List<Banner>().obs;
    // final RxList<Banner> temp = RxList<Banner>();
    // try {
    //   data.forEach((element) {
    //     final Banner banner = Banner(
    //       id: element['id'],
    //       fileUrl: element['file_url'],
    //     );
    //     temp.add(banner);
    //   });
    // } catch (e) {
    //   throw (e);
    // }
    _banners = temp;
    update();
  }
}
