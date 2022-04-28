/*
 */
//+-------------------------------------------------------------------+
//|                                                     InitMQL4.mqh  |
//|                                                 Copyright DC2008  |
//|                                              https://www.mql5.com |
//+-------------------------------------------------------------------+
// initmql4 is real in compare to MT5, but it also have declarative effect
// do not include this file in MT4 __MQLBUILD__ environment or will fail
// https://www.mql5.com/en/forum/135535
#ifdef __MQLBUILD__
#property copyright "keiji"
#property copyright "DC2008"
#property link "https://www.mql5.com"
#endif
//--- Declaration of constants
#define OP_BUY 0		// Buy
#define OP_SELL 1		// Sell
#define OP_BUYLIMIT 2	// Pending order of BUY LIMIT type
#define OP_SELLLIMIT 3	// Pending order of SELL LIMIT type
#define OP_BUYSTOP 4	// Pending order of BUY STOP type
#define OP_SELLSTOP 5	// Pending order of SELL STOP type
//---
#define MODE_OPEN 0
#define MODE_CLOSE 3
#define MODE_VOLUME 4
#define MODE_REAL_VOLUME 5
#define MODE_TRADES 0
#define MODE_HISTORY 1
#define SELECT_BY_POS 0
#define SELECT_BY_TICKET 1
//---
#define DOUBLE_VALUE 0
#define FLOAT_VALUE 1
#define LONG_VALUE INT_VALUE
//---
#define CHART_BAR 0
#define CHART_CANDLE 1
//---
#define MODE_ASCEND 0
#define MODE_DESCEND 1
//---
#define MODE_LOW 1
#define MODE_HIGH 2
#define MODE_TIME 5
#define MODE_BID 9
#define MODE_ASK 10
#define MODE_POINT 11
#define MODE_DIGITS 12
#define MODE_SPREAD 13
#define MODE_STOPLEVEL 14
#define MODE_LOTSIZE 15
#define MODE_TICKVALUE 16
#define MODE_TICKSIZE 17
#define MODE_SWAPLONG 18
#define MODE_SWAPSHORT 19
#define MODE_STARTING 20
#define MODE_EXPIRATION 21
#define MODE_TRADEALLOWED 22
#define MODE_MINLOT 23
#define MODE_LOTSTEP 24
#define MODE_MAXLOT 25
#define MODE_SWAPTYPE 26
#define MODE_PROFITCALCMODE 27
#define MODE_MARGINCALCMODE 28
#define MODE_MARGININIT 29
#define MODE_MARGINMAINTENANCE 30
#define MODE_MARGINHEDGED 31
#define MODE_MARGINREQUIRED 32
#define MODE_FREEZELEVEL 33
//---
#define EMPTY -1
#define FALSE false
#define TRUE true
// predefined vars
int _Digits;
double _Point;
int _LastError;
int _Period;
int _RandomSeed;
bool _StopFlag;
string _Symbol;
int _UninitReason;
double Digits;
double Point;
double Open[];
double Close[];
double High[];
double Low[];
datetime Time[];
int Volume[];
double Ask, Bid;
int Bars;
int CountedMQL4;
