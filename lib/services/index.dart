import 'package:get/get.dart';

import 'cache.dart';

class ServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CacheService());
  }
}
