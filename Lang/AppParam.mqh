/*
 */
//+------------------------------------------------------------------+
//| Module: Lang/AppParam.mqh                                        |
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
#ifndef __APPPARM_MQH__
#define __APPPARM_MQH__

// (Optional) parameters for the App                                |
class AppParam {
public:
	virtual bool check(void) { return true; }
};

/**
 * @brief The base class for dynamically generated setters for parameters
 *
 */
class AppParamManagerBase {
private:
	// int m_index;

protected:
	static AppParamManagerBase* managers[];
	AppParamManagerBase() {
		int count = ArraySize(managers);
		ArrayResize(managers, count + 1, 50);
		managers[count] = GetPointer(this);
	}

public:
	static void setParamters() {
		int s = ArraySize(managers);
		for (int i = 0; i < s; i++)
			managers[i].set();
	}
	static void getParamters() {
		int s = ArraySize(managers);
		for (int i = 0; i < s; i++)
			managers[i].get();
	}
	// static int getNumberOfParameters() { return ArraySize(managers); }

	virtual void set() = 0;	 // set read input to AppParam
	virtual void get() = 0;	 // get update AppParam current value to input
};
AppParamManagerBase* AppParamManagerBase::managers[];

/**
 * @brief BEGIN_INPUT accept a type with default constructor then static create the param
 */
#define BEGIN_INPUT(_paramtype)                          \
	class AppParamManager : public AppParamManagerBase { \
	protected:                                           \
		AppParamManager() {                              \
		}                                                \
                                                         \
	public:                                              \
		~AppParamManager() {}                            \
		static _paramtype app_param;                     \
	};                                                   \
	_paramtype AppParamManager::app_param;

//--- normal input parameter with declaration
#define INPUT(_type, localname, inputname, defvalue)                                \
	class __Set##inputname : public AppParamManager {                               \
	public:                                                                         \
		void set() { AppParamManager::app_param.set_##localname(I##inputname); }    \
		void get() { I##inputname = AppParamManager::app_param.get_##localname(); } \
	} __set##localname;                                                             \
	extern _type I##inputname = defvalue

#define INPUT_READONLY(_type, localname, inputname, defvalue)                    \
	class __Set##inputname : public AppParamManager {                            \
	public:                                                                      \
		void set() { AppParamManager::app_param.set_##localname(I##inputname); } \
		void get() {}                                                            \
	} __set##localname;                                                          \
	extern _type I##inputname = defvalue

//--- Input separator
#define INPUT_SEP(name, content) \
	input string I##name = "||----- " #content " -----||"

//--- Input separator
// #define FIXED_INPUT_SEP(name)

//--- Fixed input only sets the input parameter as default
//--- but does not declare the input parameter for user change
#define LOCAL_PARAM(_type, name, inputname, defvalue)                   \
	class __Set##inputname : public AppParamManager {                   \
	public:                                                             \
		void set() { AppParamManager::app_param.set_##name(defvalue); } \
		void get() {}                                                   \
	} __set##name

#define END_INPUT

#endif	//__APPPARM_MQH__
