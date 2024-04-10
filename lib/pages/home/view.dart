part of 'index.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              color: Colors.blue,
              alignment: Alignment.center,
              child: const Text("new version", style: TextStyle(color: Colors.white)),
            ),
            Obx(() => Text("Current Version: ${controller.currentVer}")),
            Obx(() => Text("Remote Version: ${controller.remoteVer}")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.checkUpdate,
              child: const Text("Check Update"),
            ),
            ElevatedButton(
              onPressed: controller.downloadUpdate,
              child: const Text("Download Update"),
            ),
          ],
        ),
      ),
    );
  }
}
