#!/bin/sh

# See https://github.com/flutter/flutter/issues/26279
# and https://github.com/flutter/flutter/issues/28802

export APP_NAME="Connect4"

mkdir -p dist

alias f="flutter"
f clean
f build ios --no-codesign \
&& pushd ios > /dev/null \
&& echo -e '\n* Building archive...\n' \
&& xcodebuild -quiet -workspace Runner.xcworkspace -scheme Runner -sdk iphoneos -configuration Release CODE_SIGNING_ALLOWED="NO" archive -archivePath ../build/ios/Runner.xcarchive \
&& echo -e '\n* Building IPA and signing...\n' \
&& xcodebuild -quiet -exportArchive -archivePath ../build/ios/Runner.xcarchive -exportOptionsPlist exportOptions.plist -exportPath ../build/ios/release \
&& mv ../build/ios/release/Runner.ipa ../dist/$APP_NAME.ipa \
&& popd > /dev/null \
&& echo -e '\n* DONE: dist/'$APP_NAME'.ipa\n' \
&& (ios-deploy --timeout 5 --bundle dist/$APP_NAME.ipa || echo)