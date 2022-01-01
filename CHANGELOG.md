## More TODO
 * 支持playlists, radio的播放
 * Try [Flutter Embedded Linux](https://github.com/sony/flutter-embedded-linux)
 * 采样率和音频格式显示。
 * Seek功能
 * 参考Apple Music
   * 正在播放页变成卡片式
   * 正在播放页加入模糊背景（album art主题色？）

## 2022.1.2 - Release v0.2.0
 * Nothing is changed.

## 2021.12.30
 * 设置输入增加软键盘，用[VK](https://pub.dev/packages/vk)实现
 * 通过增加一个path_provider，解决图片在release模式下不显示的问题。见[path_provider的问题](https://github.com/Baseflow/flutter_cached_network_image/issues/441#issuecomment-785473476)

## 2021.12.28
 * Flutter 2.8.1 (之前是2.5.3)
 * Album art也可以显示出来了
 * Dark mode下界面小问题解决（播放按钮颜色等）
 * 增加重复状态按钮

## 2021.12.27
 * 增加`shared_preferences_pi.dart`

## 2021.12.26
 * 增加一个简单的设置页，用flutter-settings-screen实现。注意在web下，需要
   `flutter run -d web-server --web-port=3344`才能成功保存设置，`flutter run -d web`不行。
 * 增加黑暗模式
 * Fix dummy-volumio的albumart CORS问题

## 2021.12.19 - Release v0.1.0
 * 改名为Touch Display Lite
 * 增加打包Volumio插件
  * [Volumio 3 plugins source](https://github.com/balbuze/volumio-plugins-sources/)
  * [Plugin system overview](https://volumio.github.io/docs/Plugin_System/Plugin_System_Overview)

## 2021.12.12 - v1.1
 * 5分钟后自动关闭屏幕

## 2021.12.11 - v1.0
 * 增加随机播放功能
 * 通过flutter-pi运行，
 * 安装中文字体
 * [flutter-pi release编译](https://github.com/ardera/flutter-pi#building-the-appso-for-running-your-app-in-releaseprofile-mode)，需要一个Linux x64机器.
 * 点击一首歌时，把整个目录加到queue中，然后从点击这首歌开始播放(使用replaceAndPlay命令)

## 2021.12.10 - 更多功能
 * 支持横竖屏自适应：[《Flutter实战·第二版》](https://book.flutterchina.club/)
 * 解决歌曲播放完成后，Play页面红屏的问题
 * 升级Volumio 3，因为flutter-pi需要Raspbian Buster，而Volumio 2还在Raspbian Jessie老版

## 2021.12.9
 * 解决中文名的目录浏览问题：服务器端需要UTF-8 bytes，所以需要转码一下。播放也做了同样修改。

## 2021.12.8 切换到WebSocket接口，实现基本功能
 * 可以实现浏览音乐库，以及实时显示正在播放的功能。
 * 播放进度条用Stream.periodic()实现。
 * [WebSocket API](https://volumio.github.io/docs/API/WebSocket_APIs.html)
 ```
https://github.com/maxill1/node-red-contrib-volumio: 
play ==> pushState
pause ==> pushState
prev ==> pushState
next ==> getSpushStatetate
setRandom ==> pushState
setRepeat ==> pushState
volume ==> pushState
mute ==> pushState
unmute ==> pushState
getQueue ==> pushQueue
playPlaylist ==> pushQueue
playFavourites ==> pushQueue
addToQueue ==> pushState
getState ==> pushState
getBrowseSources ==> pushBrowseSources
browseLibrary ==> pushBrowseLibrary
getMultiRoomDevices ==> pushMultiRoomDevices
search ==> pushBrowseLibrary
 ```
 * [Source code](https://github.com/volumio/Volumio2/blob/master/app/plugins/user_interface/websocket/index.js)

## 2021.12.6: 增加简单的正在播放页面
 * 在Playing页，显示album art

## 2021.12.5: 最初版本
 * 可以连接[Volumio RestFul API](https://volumio.github.io/docs/API/REST_API.html)
 * 可以浏览音乐库
 * 可以在浏览库时，显示album art
 * 在Chrome中调试时，需要[关闭安全检查](https://stackoverflow.com/questions/65630743/how-to-solve-flutter-web-api-cors-error-only-with-dart-code/66879350#66879350) (否则XMLHttpRequest出错)：1. 删除`flutter/bin/cache/flutter_tools.stamp`，2. 在`flutter/packages/flutter/tools/lib/src/web/chrome.dart`中，在`--disable--extensions`后增加`--diable-web-security`


Bug
 * 点首页Tab的时候，有时会出这个，但再点一下就好了：
```
[ERROR:flutter/lib/ui/ui_dart_state.cc(209)] Unhandled Exception: Null check operator used on a null value
#0      TextPainter.getPositionForOffset (package:flutter/src/painting/text_painter.dart:901)
#1      RenderParagraph.hitTestChildren (package:flutter/src/rendering/paragraph.dart:444)
#2      RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#3      RenderProxyBoxMixin.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:131)
#4      RenderFractionalTranslation.hitTestChildren.<anonymous closure> (package:flutter/src/rendering/proxy_box.dart:2767)
#5      BoxHitTestResult.addWithRawTransform (package:flutter/src/rendering/box.dart:825)
#6      BoxHitTestResult.addWithPaintTransform (package:flutter/src/rendering/box.dart:750)
#7      RenderTransform.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:2382)
#8      RenderTransform.hitTest (package:flutter/src/rendering/proxy_box.dart:2376)
#9      RenderProxyBoxMixin.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:131)
#10     RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#11     RenderShiftedBox.hitTestChildren.<anonymous closure> (package:flutter/src/rendering/shifted_box.dart:92)
#12     BoxHitTestResult.addWithPaintOffset (package:flutter/src/rendering/box.dart:786)
#13     RenderShiftedBox.hitTestChildren (package:flutter/src/rendering/shifted_box.dart:87)
#14     RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#15     RenderBoxContainerDefaultsMixin.defaultHitTestChildren.<anonymous closure> (package:flutter/src/rendering/box.dart:2774)
#16     BoxHitTestResult.addWithPaintOffset (package:flutter/src/rendering/box.dart:786)
#17     RenderBoxContainerDefaultsMixin.defaultHitTestChildren (package:flutter/src/rendering/box.dart:2769)
#18     RenderFlex.hitTestChildren (package:flutter/src/rendering/flex.dart:1072)
#19     RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#20     RenderShiftedBox.hitTestChildren.<anonymous closure> (package:flutter/src/rendering/shifted_box.dart:92)
#21     BoxHitTestResult.addWithPaintOffset (package:flutter/src/rendering/box.dart:786)
#22     RenderShiftedBox.hitTestChildren (package:flutter/src/rendering/shifted_box.dart:87)
#23     RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#24     RenderProxyBoxMixin.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:131)
#25     RenderProxyBoxWithHitTestBehavior.hitTest (package:flutter/src/rendering/proxy_box.dart:178)
#26     RenderProxyBoxMixin.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:131)
#27     RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#28     RenderProxyBoxMixin.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:131)
#29     RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#30     RenderMouseRegion.hitTest (package:flutter/src/rendering/proxy_box.dart:2958)
#31     RenderProxyBoxMixin.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:131)
#32     RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#33     RenderProxyBoxMixin.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:131)
#34     RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#35     RenderProxyBoxMixin.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:131)
#36     RenderProxyBoxWithHitTestBehavior.hitTest (package:flutter/src/rendering/proxy_box.dart:178)
#37     RenderBoxContainerDefaultsMixin.defaultHitTestChildren.<anonymous closure> (package:flutter/src/rendering/box.dart:2774)
#38     BoxHitTestResult.addWithPaintOffset (package:flutter/src/rendering/box.dart:786)
#39     RenderBoxContainerDefaultsMixin.defaultHitTestChildren (package:flutter/src/rendering/box.dart:2769)
#40     RenderStack.hitTestChildren (package:flutter/src/rendering/stack.dart:620)
#41     RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#42     RenderProxyBoxMixin.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:131)
#43     RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#44     RenderBoxContainerDefaultsMixin.defaultHitTestChildren.<anonymous closure> (package:flutter/src/rendering/box.dart:2774)
#45     BoxHitTestResult.addWithPaintOffset (package:flutter/src/rendering/box.dart:786)
#46     RenderBoxContainerDefaultsMixin.defaultHitTestChildren (package:flutter/src/rendering/box.dart:2769)
#47     RenderFlex.hitTestChildren (package:flutter/src/rendering/flex.dart:1072)
#48     RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#49     RenderShiftedBox.hitTestChildren.<anonymous closure> (package:flutter/src/rendering/shifted_box.dart:92)
#50     BoxHitTestResult.addWithPaintOffset (package:flutter/src/rendering/box.dart:786)
#51     RenderShiftedBox.hitTestChildren (package:flutter/src/rendering/shifted_box.dart:87)
#52     RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#53     RenderProxyBoxMixin.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:131)
#54     RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#55     RenderProxyBoxMixin.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:131)
#56     RenderCustomPaint.hitTestChildren (package:flutter/src/rendering/custom_paint.dart:535)
#57     RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#58     RenderProxyBoxMixin.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:131)
#59     RenderCustomPaint.hitTestChildren (package:flutter/src/rendering/custom_paint.dart:535)
#60     RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#61     RenderProxyBoxMixin.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:131)
#62     RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#63     RenderProxyBoxMixin.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:131)
#64     RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#65     RenderProxyBoxMixin.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:131)
#66     RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#67     RenderPhysicalModel.hitTest (package:flutter/src/rendering/proxy_box.dart:1908)
#68     RenderProxyBoxMixin.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:131)
#69     RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#70     RenderBoxContainerDefaultsMixin.defaultHitTestChildren.<anonymous closure> (package:flutter/src/rendering/box.dart:2774)
#71     BoxHitTestResult.addWithPaintOffset (package:flutter/src/rendering/box.dart:786)
#72     RenderBoxContainerDefaultsMixin.defaultHitTestChildren (package:flutter/src/rendering/box.dart:2769)
#73     RenderCustomMultiChildLayoutBox.hitTestChildren (package:flutter/src/rendering/custom_layout.dart:414)
#74     RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#75     RenderProxyBoxMixin.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:131)
#76     RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#77     RenderProxyBoxMixin.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:131)
#78     RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#79     RenderPhysicalModel.hitTest (package:flutter/src/rendering/proxy_box.dart:1908)
#80     RenderProxyBoxMixin.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:131)
#81     RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#82     RenderProxyBoxMixin.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:131)
#83     RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#84     RenderProxyBoxMixin.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:131)
#85     RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#86     RenderOffstage.hitTest (package:flutter/src/rendering/proxy_box.dart:3428)
#87     RenderProxyBoxMixin.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:131)
#88     RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#89     RenderProxyBoxMixin.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:131)
#90     RenderFractionalTranslation.hitTestChildren.<anonymous closure> (package:flutter/src/rendering/proxy_box.dart:2767)
#91     BoxHitTestResult.addWithPaintOffset (package:flutter/src/rendering/box.dart:786)
#92     RenderFractionalTranslation.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:2761)
#93     RenderFractionalTranslation.hitTest (package:flutter/src/rendering/proxy_box.dart:2747)
#94     RenderProxyBoxMixin.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:131)
#95     RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#96     RenderProxyBoxMixin.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:131)
#97     _RenderFocusTrap.hitTest (package:flutter/src/widgets/routes.dart:2126)
#98     RenderProxyBoxMixin.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:131)
#99     RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#100    RenderProxyBoxMixin.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:131)
#101    RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#102    RenderOffstage.hitTest (package:flutter/src/rendering/proxy_box.dart:3428)
#103    RenderProxyBoxMixin.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:131)
#104    RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#105    _RenderTheatre.hitTestChildren.<anonymous closure> (package:flutter/src/widgets/overlay.dart:767)
#106    BoxHitTestResult.addWithPaintOffset (package:flutter/src/rendering/box.dart:786)
#107    _RenderTheatre.hitTestChildren (package:flutter/src/widgets/overlay.dart:762)
#108    RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#109    RenderProxyBoxMixin.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:131)
#110    RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#111    RenderProxyBoxMixin.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:131)
#112    RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#113    RenderAbsorbPointer.hitTest (package:flutter/src/rendering/proxy_box.dart:3526)
#114    RenderProxyBoxMixin.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:131)
#115    RenderProxyBoxWithHitTestBehavior.hitTest (package:flutter/src/rendering/proxy_box.dart:178)
#116    RenderProxyBoxMixin.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:131)
#117    RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#118    RenderProxyBoxMixin.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:131)
#119    RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#120    RenderProxyBoxMixin.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:131)
#121    RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#122    RenderProxyBoxMixin.hitTestChildren (package:flutter/src/rendering/proxy_box.dart:131)
#123    RenderBox.hitTest (package:flutter/src/rendering/box.dart:2413)
#124    RenderView.hitTest (package:flutter/src/rendering/view.dart:185)
#125    RendererBinding.hitTest (package:flutter/src/rendering/binding.dart:483)
#126    GestureBinding._handlePointerEventImmediately (package:flutter/src/gestures/binding.dart:346)
#127    GestureBinding.handlePointerEvent (package:flutter/src/gestures/binding.dart:338)
#128    GestureBinding._flushPointerEventQueue (package:flutter/src/gestures/binding.dart:296)
#129    GestureBinding._handlePointerDataPacket (package:flutter/src/gestures/binding.dart:279)
#130    _rootRunUnary (dart:async/zone.dart:1444)
#131    _CustomZone.runUnary (dart:async/zone.dart:1335)
#132    _CustomZone.runUnaryGuarded (dart:async/zone.dart:1244)
#133    _invoke1 (dart:ui/hooks.dart:185)
#134    PlatformDispatcher._dispatchPointerDataPacket (dart:ui/platform_dispatcher.dart:293)
#135    _dispatchPointerDataPacket (dart:ui/hooks.dart:98)
```


DONE
 * 改成Web Socket，状态显示变实时
 * 需要增加一个[Animated Progress Bar](https://medium.com/@calebkiage/creating-an-animated-progress-indicator-in-flutter-part-2-5b78b0198a46)来作为播放进度显示
 * 好像中文名的目录浏览有问题
 * 支持横竖屏[自适应](https://docs.flutter.dev/development/ui/layout/adaptive-responsive)
 * `shared_preferences`似乎在flutter-pi下面没有实现的插件，`[ERROR:flutter/lib/ui/ui_dart_state.cc(209)] Unhandled Exception: MissingPluginException(No implementation found for method getAll on channel plugins.flutter.io/shared_preferences)`
 * Album art显示不出来：`MissingPluginException: No implementation found for method getTemporaryDirectory on channel plugins.flutter.io/path_provider`
