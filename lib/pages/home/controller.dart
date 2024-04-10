part of 'index.dart';

class HomeController extends GetxController {
  final currentVer = "".obs;
  final remoteVer = "".obs;
  final shorebird = ShorebirdCodePush();

  @override
  void onInit() async {
    super.onInit();

    currentVer.value = (await shorebird.currentPatchNumber()).toString();
    remoteVer.value = (await shorebird.nextPatchNumber()).toString();
  }

  void checkUpdate() async {
    final hasNew = await shorebird.isNewPatchAvailableForDownload();
    if (hasNew) {
      Get.snackbar("提示", "有新版本可以下载");
      await shorebird.downloadUpdateIfAvailable();
      Get.snackbar("提示", "下载完成");
    } else {
      Get.snackbar("提示", "当前已是最新版本");
    }
  }

  void downloadUpdate() {}
}
