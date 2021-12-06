
## 2021.12.6: 增加简单的正在播放页面
 * 在Playing页，显示album art

## 2021.12.5: 最初版本
 * 可以连接[Volumio RestFul API](https://volumio.github.io/docs/API/REST_API.html)
 * 可以浏览音乐库
 * 可以在浏览库时，显示album art
 * 在Chrome中调试时，需要[关闭安全检查](https://stackoverflow.com/questions/65630743/how-to-solve-flutter-web-api-cors-error-only-with-dart-code/66879350#66879350) (否则XMLHttpRequest出错)：1. 删除`flutter/bin/cache/flutter_tools.stamp`，2. 在`flutter/packages/flutter/tools/lib/src/web/chrome.dart`中，在`--disable--extensions`后增加`--diable-web-security`
