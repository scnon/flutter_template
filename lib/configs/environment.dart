import '/services/cache.dart';

const String _envKey = 'DART_DEFINE_APP_ENV';
const String _envKeyChain = 'KEYCHAIN_ENV';

/// 环境类型
class EnvType {
  /// 开发环境
  static const String debug = "debug";

  /// 生产环境
  static const String prod = "prod";
}

/// 环境配置
class EnvConfig {
  final String type;

  EnvConfig({this.type = EnvType.debug});
}

/// 环境配置
class Environment {
  /// 当前环境
  static const appEnv = String.fromEnvironment(_envKey);

  /// 开发环境
  static final EnvConfig _debugConfig = EnvConfig(
    type: EnvType.debug,
  );

  /// 生产环境
  static final EnvConfig _prodConfig = EnvConfig(
    type: EnvType.prod,
  );

  static EnvConfig get config => _getEnvConfig();

  static List<EnvConfig> envs = [
    _debugConfig,
    _prodConfig,
  ];

  // 根据不同环境返回对应的环境配置
  static EnvConfig _getEnvConfig() {
    /// 获取本地缓存的请求环境
    final env = CacheService().getString(_envKeyChain) ?? appEnv;
    switch (env) {
      case EnvType.debug:
        return _debugConfig;
      case EnvType.prod:
        return _prodConfig;
      default:
        return _debugConfig;
    }
  }
}
