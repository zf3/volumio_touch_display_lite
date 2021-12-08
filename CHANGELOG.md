## TODO for 1.0
 * 好像中文名的目录浏览有问题
 * 支持横竖屏自适应
 * 通过flutter-pi运行，然后打包成Volumio plugin的zip
 * 点击一首歌时，应该把整个目录加到queue中，然后从点击这首歌开始播放

## More TODO
 * 浏览音乐库时增加回到上一层的按钮，要显示在App Bar上面
 * 参考Apple Music
   * 正在播放页变成卡片式
   * 正在播放页加入模糊背景（album art主题色？）

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


DONE
 * 改成Web Socket，状态显示变实时
 * 需要增加一个[Animated Progress Bar](https://medium.com/@calebkiage/creating-an-animated-progress-indicator-in-flutter-part-2-5b78b0198a46)来作为播放进度显示
