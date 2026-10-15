# The War of Wings

하준과 하나가 다섯 용 부족의 땅을 여행하는 턴제 RPG. 지역마다 바뀌는 배경음악과 효과음, 자동 저장.

## 바로 해 보기

- **파일로 열기:** `www/index.html` 을 브라우저로 엽니다.
- **Linux Mint에 설치:** 이 폴더에서 실행하면 메뉴 > 게임에 아이콘이 생깁니다.

  ```bash
  sudo apt install chromium   # 주소창 없는 앱 창으로 열기 (선택)
  bash install-linux.sh       # 지울 때: bash uninstall-linux.sh
  ```

- **휴대폰에서 같은 와이파이로 테스트:** `python3 -m http.server 8000 -d www` 후 휴대폰에서 `http://<PC IP>:8000`

## GitHub에 올리기 (Linux Mint)

```bash
sudo apt install git gh
gh auth login -s workflow
cd the-war-of-wings
git init -b main && git add . && git commit -m "The War of Wings 첫 버전"
gh repo create the-war-of-wings --public --source=. --push
```

push 하면 자동으로 두 가지가 실행됩니다 (저장소 > Actions 탭에서 확인).

| 작업 | 결과 |
| --- | --- |
| 게임 공개 (`pages.yml`) | `https://<아이디>.github.io/the-war-of-wings/` — 처음 한 번은 Settings > Pages > Source 를 **GitHub Actions** 로 바꾸고 Re-run |
| 안드로이드 테스트 앱 (`android-apk.yml`) | `https://github.com/<아이디>/the-war-of-wings/releases/download/test-build/the-war-of-wings.apk` |

## 앱으로 만들기 (Capacitor 8)

필요: Node.js 22+, Android Studio (안드로이드), Mac + Xcode (iOS)

```bash
npm install
npm run android:add     # android 폴더 생성
npm run sync            # 게임을 고칠 때마다
npm run android:open    # Android Studio에서 실행·서명·AAB 만들기
npm run ios:add && npm run ios:open   # Mac에서만
```

출시 전에 `capacitor.config.json` 의 `appId` 를 내 것으로 바꾸세요 (예: `com.eunsang.thewarofwings`). 한 번 출시하면 바꿀 수 없어요.
게임 파일을 고친 뒤에는 `www/sw.js` 의 `VERSION` 을 올려야 설치한 사람에게 새 버전이 전달됩니다.
