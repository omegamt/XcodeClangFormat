
## build
- 项目目录下创建子目录./deps/clang-10.0.0 
- 下载新版的LLVM 解压至./deps  重命名 clang-10.0.0 


```objc
  AppDelegate.m
  
  defaults = [[NSUserDefaults alloc] initWithSuiteName:@"XcodeClangFormat2"]; //如何报 CFPrefsPlistSource read error 随便修改名称 XcodeClangFormat2

```

## release

app 破损
sudo xattr -d com.apple.quarantine /Applications/XcodeClangFormat.app

或者 推荐
codesign --force --deep --sign - /Applications/XcodeClangFormat.app

或者用自己的证书重新签名
