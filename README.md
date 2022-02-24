# mql4-lib

MQL Foundation Library For Professional Developers

Hi, it seems original contributors not updating original mql4-lib repo.

Our work depends heavily on this library, but we don't have to add new feature. For original manual please read README_orig.md. thanks to original contributors, it's a great manual.

Major change from original
* Add VSCode c++ intellisense help
* Add ObjectArrray so any object like complex type (include struct) can put in, but have to implement bool ObjectArrayCompareElement(T& src, T& dst) comparator by yourself, primitive type can always use Array class
* Fix Array push minor issue
* NOTE dll with tester issues: how to put dll while using tester to prevent dll not found or not loaded issue
  * check Options -> Expert Advisors -> Allow DLL Imports
  * for 32 bit mt4, get a genuine 32 bit dll from a legit source (like windll.com), not from anyone who told you to download
  * for 64 bit mt5, copy from Windows/System32
  * dll must put in "DataFolder" with terminal.exe, terminal require restart. not "tester" folder or any others
* INPUT macro use extern implementation instead of input
* Disable ExpertAdvisor onTester event handler, use MT4 default
* ExpertAdvisor DECLARE_EA related INPUT macro change to INPUT(_type, localname, inputname, defvalue), so still can access to input AppInputSomeInputName
* MQL_PROPERTY macro to define simple property in class instead of ObjectAttr macro
* Add mql/lang/mql4syntax.mqh so vscode c/c++ intellisense can mostly work
* Escape #import so get more syntax compatibility
* Move function implementation back to class, so cross compatible for both modern c++ compiler and bcc
* Add header guard

A Note of VSCode c++ intellisense support
You can still complete your work with some of intellisense feature, better than none
Requirement
* A valid VC++ compiler, get it from choco will be easy: choco install visualstudio2019buildtools
* Install vscode extensions: C/C++, MQL-syntax-over-cpp. suggested to install Doxygen Documentation Generator
* Add a c_cpp_properties.json in .vscode folder
  * Add to includePath
  * "C:/Program Files (x86)/Windows Kits/10/Include/<windows kit version>/ucrt",
  * "C:/Program Files (x86)/Windows Kits/10/Include/<windows kit version>/um",
  * "C:/Program Files (x86)/Windows Kits/10/Include/<windows kit version>/shared",
  * "C:/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools/VC/Tools/MSVC/<vc version>/include",
  * path to your "MQL4/Include",
  * "compilerPath": "C:/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools/VC/Tools/MSVC/<vc version>/bin/Hostx64/x64/cl.exe",
  * "intelliSenseMode": "msvc-x64"
  * my windows kit version currently is "10.0.19041.0" and VC is "14.29.30133"
  * Other info you can refer to https://www.mql5.com/en/blogs/post/719548 and vscode c_cpp_properties.json related help
* Add like these in your mhq file
  * Suggested to add header guard
```
#ifndef __MY_CODE_MQH__
#define __MY_CODE_MQH__

#ifdef __MQLBUILD__
#property strict
#any_other_mql_supported_preprocessor
#else
#include <Mql/Lang/Mql4Syntax.mqh>
#include <mylib/macro.mqh>
#endif

int my_code_start_here;

#endif	// __MY_CODE_MQH__
```
Known issue
* Preprocessor like #import and #property cannot work on vc
* Template syntax related
* Anything cannot identified as a type or function, but metaeditor compiler will still work
* string related
* Array construction like Type array[];
* Static variable init may confuse with namespace ::
* Pointer manipulation related
* If you get more and more in problem panel, vscode intellisense will stop to work, sometimes you have to separate your code.

## Contributing

We will NOT provide work for these issues
* New feature, excepts our projects need it
* Issue from original repository
* MQL5 related issue (sorry that our primary work only depends on MQL4)
* Build error for specific MT4 version, not latest

If you need these help, please file a issue
* Build error on latest MT4
* License issue ... etc, something not mentioned above

