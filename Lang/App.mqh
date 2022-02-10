/*
 */
//+------------------------------------------------------------------+
//| Module: Lang/App.mqh                                             |
//| This file is part of the mql4-lib project:                       |
//|     https://github.com/dingmaotu/mql4-lib                        |
//|                                                                  |
//| Copyright 2017 Li Ding <dingmaotu@126.com>                       |
//|                                                                  |
//| Licensed under the Apache License, Version 2.0 (the "License");  |
//| you may not use this file except in compliance with the License. |
//| You may obtain a copy of the License at                          |
//|                                                                  |
//|     http://www.apache.org/licenses/LICENSE-2.0                   |
//|                                                                  |
//| Unless required by applicable law or agreed to in writing,       |
//| software distributed under the License is distributed on an      |
//| "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,     |
//| either express or implied.                                       |
//| See the License for the specific language governing permissions  |
//| and limitations under the License.                               |
//+------------------------------------------------------------------+
#ifdef __MQLBUILD__
#property strict
#else
#include <Mql/Lang/Mql4Syntax.mqh>
#endif

#ifndef __APP_MQH__
#define __APP_MQH__

#include "Mql.mqh"
#include "AppParam.mqh"
#include "Pointer.mqh"

/**
 * @brief Abstract base class for a MQL Application
 *
 */
class App {
private:
	ENUM_INIT_RETCODE m_ret;
	// bool m_runtimeControlled;

protected:
	int getDeinitReason() const { return UninitializeReason(); }
	// bool isRuntimeControlled() const { return m_runtimeControlled; }

	//compatibility
	void fail(string message = "", ENUM_INIT_RETCODE ret = ENUM_INIT_RETCODE::INIT_FAILED) {
		if (message != "") Alert(message);
		m_ret = ret;
	}

public:
	//--- members for internal use
	int __init__() const { return m_ret; }

	App() : m_ret(ENUM_INIT_RETCODE::INIT_SUCCEEDED) {
	}

	bool isInitSuccess() const { return m_ret == INIT_SUCCEEDED; }
	static App* current_app;
};
//+------------------------------------------------------------------+

// #define __APP_NEW(_apptype) __APP_NEW_##FORCECHECK(_apptype)

// #define __APP_NEW_true(_apptype)                                               \
// 	AppParamManager::setParamters();                                           \
// 	if (!AppParamManager::app_param.check()) return INIT_PARAMETERS_INCORRECT; \
// 	App::app = new _apptype(AppParamManager::Global);

// #define __APP_NEW_false(_apptype) \
// 	App::app = new _apptype();

#define DECLARE_APP(_apptype)                                                              \
	App* App::current_app = NULL;                                                          \
	int OnInit() {                                                                         \
		AppParamManager::setParamters();                                                   \
		if (!AppParamManager::app_param.check()) return INIT_PARAMETERS_INCORRECT;         \
		App::current_app = new _apptype(AppParamManager::app_param);                       \
		return App::current_app.__init__();                                                \
	}                                                                                      \
	void OnDeinit(const int reason) {                                                      \
		NODE_LOG_INFO(StringFormat("App uninit reason=%s", Mql::getUninitReason(reason))); \
		SafeDelete(App::current_app);                                                      \
	}

#endif	//__APP_MQH__
