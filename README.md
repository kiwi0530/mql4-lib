# mql4-lib

MQL Foundation Library For Professional Developers

Hi, it seems original contributors not updating original mql4-lib repo.

Our work depends heavily on this library, but we don't have to add new feature. For original manual please read README_orig.md. thanks to original contributors, it's a great manual.

Major change from original
* Add header guard
* Move function implementation back to class, so cross compatible for both modern c++ compiler and bcc
* Escape #import so get more syntax compatibility
* Add mql/lang/mql4syntax.mqh so vscode c/c++ intellisense can mostly work
* MQL_PROPERTY macro to define simple property in class instead of ObjectAttr macro
* ExpertAdvisor DECLARE_EA related INPUT macro change to INPUT(_type, localname, inputname, defvalue), so still can access to input AppInputSomeInputName
* Disable ExpertAdvisor onTester event handler, use MT4 default
* INPUT macro use extern implementation instead of input, can do read write access to the variable


We will NOT provide work for these issues
* New feature, excepts our projects need it
* Issue from original repository
* MQL5 related issue (sorry that our primary work only depends on MQL4)
* Build error for specific MT4 version, not latest

If you need these help, please file a issue
* Build error on latest MT4
* License issue ... etc, something not mentioned above

