AmiAmi
======

![image](https://s3-ap-northeast-1.amazonaws.com/daidoujiminecraft/Daidouji/AmiAmiDemo20140214.gif)

DaidoujiChen

daidoujichen@gmail.com

總覽
======
因為本身平常喜歡逛 amiami (http://www.amiami.jp/) 這個網站, 但是由於這個網站的手機版網頁寫得並不像桌面版這麼好看, 圖片也比較少, 操作也不便利, 於是萌生寫作這個 app 的念頭.

支援
======
- ios7.0 up
- iphone 4" / 3.5"

如果你有 JB
======
可以幫我試試檔案能不能用, 如果不能用, 而且你又很好心的話, 可以發個信告訴我, 我會很感激, 謝謝.

- <a href="https://s3-ap-northeast-1.amazonaws.com/daidoujiminecraft/Daidouji/AmiAmi_20140214.ipa">AmiAmi_20140214</a>
- <a href="https://s3-ap-northeast-1.amazonaws.com/daidoujiminecraft/Daidouji/AmiAmi_20140212.ipa">AmiAmi_20140212</a>


第三方套件
======

- hpple
  - parse html 網頁.

- AFNetworking
  - 因為 amiami 網站很多東西是使用 javascript 後來才 load 出來的, 因而無法使用 afnetworking 直接讀取 html 做 parse.

- SDWebImage
  - 異步讀取網路圖片.

- OSNavigationController
  - 解決 uiviewcontroller 透明背景時, navigationcontroller 造成的延遲.

- FXBlurView
  - 類似 ios7 毛玻璃效果, 不過可以控制模糊程度, 比另一個套件 iOS-blur, 使用上來的靈活.

- PhotoViewer
  - 簡易使用的瀏覽圖片套件.

- SVProgressHUD
  - 網路讀取中使用的 HUD 效果.

- GooglePlus SDK
  - 用於分享到 google plus.

- FastImageCache
  - 提高 Image Load 效能, combo with SDWebImage
