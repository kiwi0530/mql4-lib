/*
 */
//+-------------------------------------------------------------------+
//|                                                     InitMQL4.mqh  |
//|                                                 Copyright DC2008  |
//|                                              https://www.mql5.com |
//+-------------------------------------------------------------------+
// initmql4 is real in compare to MT5, but it also have declarative effect
// do not include this file in MT4 __MQLBUILD__ environment or will fail
//https://www.mql5.com/en/forum/135535
#ifdef __MQLBUILD__
#property copyright "keiji"
#property copyright "DC2008"
#property link "https://www.mql5.com"
#endif
#include "InitMQL4Declares.mqh"
//+------------------------------------------------------------------+
//|Initialize standard arrays for the MQL4 environment.              |
//+------------------------------------------------------------------+
void InitMql4() {
	ArraySetAsSeries(Open, true);
	ArraySetAsSeries(Close, true);
	ArraySetAsSeries(High, true);
	ArraySetAsSeries(Low, true);
}
//+------------------------------------------------------------------+
//|  Starting the MQL4 environment.                                  |
//+------------------------------------------------------------------+
int MQL4Run(int rates_total, int prev_calculated)  // bars - number of bars for recalculation
{
	int Uncount = rates_total - prev_calculated;
	if (Uncount == 0) {
		GetMQL4Tick();
	} else
		GetMQL4();
	return (ArraySize(Close));
}
//+------------------------------------------------------------------+
//|  Filling the MQL4 environment                                    |
//+------------------------------------------------------------------+
void GetMQL4() {
	datetime endAte = 0;
	datetime startdate = TimeTradeServer();

	CopyOpen(Symbol(), Period(), startdate, endAte, Open);
	CopyHigh(Symbol(), Period(), startdate, endAte, High);
	CopyLow(Symbol(), Period(), startdate, endAte, Low);
	CopyClose(Symbol(), Period(), startdate, endAte, Close);

	MqlTick tick;
	SymbolInfoTick(Symbol(), tick);
	Ask = tick.ask;
	Bid = tick.bid;
	CountedMQL4 = 0;
}
//+------------------------------------------------------------------+
//|Transformation of tick data in the MQL4 environment               |
//+------------------------------------------------------------------+
void GetMQL4Tick() {
	MqlRates rates[1];
	CopyRates(Symbol(), 0, 0, 1, rates);
	Open[0] = rates[0].open;
	Close[0] = rates[0].close;
	High[0] = rates[0].high;
	Low[0] = rates[0].low;
	MqlTick tick;
	SymbolInfoTick(Symbol(), tick);
	Ask = tick.ask;
	Bid = tick.bid;
	CountedMQL4 = ArraySize(Close);
}
//+------------------------------------------------------------------+
//|     Transferring timeframes to the MQL5 environment              |
//+------------------------------------------------------------------+
ENUM_TIMEFRAMES FixTF(int TimeFrame) {
	switch (TimeFrame) {
	case 0:
		return (PERIOD_CURRENT);
	case 1:
		return (PERIOD_M1);
	case 5:
		return (PERIOD_M5);
	case 15:
		return (PERIOD_M15);
	case 30:
		return (PERIOD_M30);
	case 60:
		return (PERIOD_H1);
	case 240:
		return (PERIOD_H4);
	case 1440:
		return (PERIOD_D1);
	case 10080:
		return (PERIOD_W1);
	case 43200:
		return (PERIOD_MN1);

	case 2:
		return (PERIOD_M2);
	case 3:
		return (PERIOD_M3);
	case 4:
		return (PERIOD_M4);
	case 6:
		return (PERIOD_M6);
	case 10:
		return (PERIOD_M10);
	case 12:
		return (PERIOD_M12);
	case 16385:
		return (PERIOD_H1);
	case 16386:
		return (PERIOD_H2);
	case 16387:
		return (PERIOD_H3);
	case 16388:
		return (PERIOD_H4);
	case 16390:
		return (PERIOD_H6);
	case 16392:
		return (PERIOD_H8);
	case 16396:
		return (PERIOD_H12);
	case 16408:
		return (PERIOD_D1);
	case 32769:
		return (PERIOD_W1);
	case 49153:
		return (PERIOD_MN1);
	default:
		return (PERIOD_CURRENT);
	}
}
//+-------------------------------------------------------+
//|Returns index of the greatest found value              |
//|(shift relative to a current bar).                     |
//+-------------------------------------------------------+
int iHighest(string Symb, int TimFrame, int Moode, int Much, int Shift) {
	ENUM_TIMEFRAMES TimFram = FixTF(TimFrame);
	double Array[];
	long VolumeArray[];
	ArrayResize(Array, Much);
	ArrayResize(VolumeArray, Much);
	ArraySetAsSeries(Array, true);
	ArraySetAsSeries(VolumeArray, true);
	int pozition, Copied;
	switch (Moode) {
	case 0:
		Copied = CopyOpen(Symb, TimFram, Shift, Much, Array);
		pozition = ArrayMaximum(Array, 0, WHOLE_ARRAY);
		break;
	case 1:
		Copied = CopyClose(Symb, TimFram, Shift, Much, Array);
		pozition = ArrayMaximum(Array, 0, WHOLE_ARRAY);
		break;
	case 2:
		Copied = CopyHigh(Symb, TimFram, Shift, Much, Array);
		pozition = ArrayMaximum(Array, 0, WHOLE_ARRAY);
		break;
	case 3:
		Copied = CopyLow(Symb, TimFram, Shift, Much, Array);
		pozition = ArrayMaximum(Array, 0, WHOLE_ARRAY);
		break;
	case 4:
		Copied = CopyTickVolume(Symb, TimFram, Shift, Much, VolumeArray);
		pozition = ArrayMaximum(VolumeArray, 0, WHOLE_ARRAY);
		break;
	case 5:
		Copied = CopyRealVolume(Symb, TimFram, Shift, Much, VolumeArray);
		pozition = ArrayMaximum(VolumeArray, 0, WHOLE_ARRAY);
		break;
	}
	return (pozition + Shift);
}
//+------------------------------------------------------------------+
//|Returns index of the least found value                            |
//|(shift relative to a current bar).                                |
//+------------------------------------------------------------------+
int iLowest(string Symb, int TimFrame, int Moode, int Much, int Shift) {
	ENUM_TIMEFRAMES TimFram = FixTF(TimFrame);
	double Array[];
	long VolumeArray[];
	ArrayResize(Array, Much);
	ArrayResize(VolumeArray, Much);
	ArraySetAsSeries(Array, true);
	ArraySetAsSeries(VolumeArray, true);
	int pozition, Copied;
	switch (Moode) {
	case 0:
		Copied = CopyOpen(Symb, TimFram, Shift, Much, Array);
		pozition = ArrayMinimum(Array, 0, WHOLE_ARRAY);
		break;
	case 1:
		Copied = CopyClose(Symb, TimFram, Shift, Much, Array);
		pozition = ArrayMinimum(Array, 0, WHOLE_ARRAY);
		break;
	case 2:
		Copied = CopyHigh(Symb, TimFram, Shift, Much, Array);
		pozition = ArrayMinimum(Array, 0, WHOLE_ARRAY);
		break;
	case 3:
		Copied = CopyLow(Symb, TimFram, Shift, Much, Array);
		pozition = ArrayMinimum(Array, 0, WHOLE_ARRAY);
		break;
	case 4:
		Copied = CopyTickVolume(Symb, TimFram, Shift, Much, VolumeArray);
		pozition = ArrayMinimum(VolumeArray, 0, WHOLE_ARRAY);
		break;
	case 5:
		Copied = CopyRealVolume(Symb, TimFram, Shift, Much, VolumeArray);
		pozition = ArrayMinimum(VolumeArray, 0, WHOLE_ARRAY);
		break;
	}
	return (pozition + Shift);
}
//+------------------------------------------------------------------+
//|Returns value of the price of opening of a specified by the shift |
//|parameter bar from a corresponding chart (symbol, timeframe).     |
//|Returns 0 if an error occurs.                                     |
//+------------------------------------------------------------------+
double iOpen(string Symb, int TimFrame, int Shift) {
	ENUM_TIMEFRAMES TimFram = FixTF(TimFrame);
	double Array[1];
	int Copied = CopyOpen(Symb, TimFram, Shift, 1, Array);
	if (Copied != 1) return (0);
	return (Array[0]);
}
//+------------------------------------------------------------------+
//|Returns value of the price of closing of a specified by the shift |
//|parameter bar from a corresponding chart (symbol, timeframe).     |
//|Returns 0 if an error occurs.                                     |
//+------------------------------------------------------------------+
double iClose(string Symb, int TimFrame, int Shift) {
	ENUM_TIMEFRAMES TimFram = FixTF(TimFrame);
	double Array[1];
	int Copied = CopyClose(Symb, TimFram, Shift, 1, Array);
	if (Copied != 1) return (0);
	return (Array[0]);
}
//+------------------------------------------------------------------+
//|Returns value of the highest price of a specified by the shift    |
//|parameter bar from a corresponding chart (symbol, timeframe).     |
//|Returns 0 if an error occurs.                                     |
//+------------------------------------------------------------------+
double iHigh(string Symb, int TimFrame, int Shift) {
	ENUM_TIMEFRAMES TimFram = FixTF(TimFrame);
	double Array[1];
	int Copied = CopyHigh(Symb, TimFram, Shift, 1, Array);
	if (Copied != 1) return (0);
	return (Array[0]);
}
//+------------------------------------------------------------------+
//|Returns value of the minimum price of a specified with by shift   |
//|parameter bar from a corresponding chart (symbol, timeframe).     |
//|Returns 0 if an error occurs.                                     |
//+------------------------------------------------------------------+
double iLow(string Symb, int TimFrame, int Shift) {
	ENUM_TIMEFRAMES TimFram = FixTF(TimFrame);
	double Array[1];
	int Copied = CopyLow(Symb, TimFram, Shift, 1, Array);
	if (Copied != 1) return (0);
	return (Array[0]);
}
//+------------------------------------------------------------------+
//|Returns value of time of opening of a specified by the shift      |
//|parameter bar from a corresponding chart (symbol, timeframe).     |
//|Returns 0 if an error occurs.                                     |
//+------------------------------------------------------------------+
datetime iTime(string Symb, int TimFrame, int Shift) {
	ENUM_TIMEFRAMES TimFram = FixTF(TimFrame);
	datetime Array[1];
	int Copied = CopyTime(Symb, TimFram, Shift, 1, Array);
	if (Copied != 1) return (0);
	return (Array[0]);
}
//+------------------------------------------------------------------+
//|Returns value of tick volume of a specified by the shift          |
//|parameter bar from a corresponding chart (symbol, timeframe).     |
//|Returns 0 if an error occurs.                                     |
//+------------------------------------------------------------------+
long iVolume(string Symb, int TimFrame, int Shift) {
	ENUM_TIMEFRAMES TimFram = FixTF(TimFrame);
	long Array[1];
	int Copied = CopyTickVolume(Symb, TimFram, Shift, 1, Array);
	if (Copied != 1) return (0);
	return (Array[0]);
}
//+------------------------------------------------------------------+
//|  Calculation of moving average for MQL4 programs.                |
//+------------------------------------------------------------------+
double iMAMql4(string Symb, int TimFrame, int iMAPeriod, int ma_shift, ENUM_MA_METHOD ma_method, ENUM_APPLIED_PRICE applied_price, int Shift) {
	ENUM_TIMEFRAMES TimFram = FixTF(TimFrame);
	double mass[1];
	int handle = iMA(Symb, TimFram, iMAPeriod, ma_shift, ma_method, applied_price);
	if (handle < 0) {
		Print("Failed to create the iMA object: Error ", GetLastError());
		return (0);
	} else if (CopyBuffer(handle, 0, Shift, 1, mass) <= 0)
		return (0);
	return (mass[0]);
}
//+------------------------------------------------------------------------+
//| Calculation of moving average for MQL4 programs on an array.           |
//+------------------------------------------------------------------------+
double iMAOnArrayMql4(double &Array[], int total, int iMAPeriod, int ma_shift, ENUM_MA_METHOD ma_method, int Shift) {
	double buf[];
	if (total > 0 && total <= iMAPeriod) return (0);
	if (total == 0) total = ArraySize(Array);
	if (ArrayResize(buf, total) < 0) return (0);
	switch (ma_method) {
	case MODE_SMA: {
		double sum = 0;
		int i, pos = total - 1;
		for (i = 1; i < iMAPeriod; i++, pos--)
			sum += Array[pos];
		while (pos >= 0) {
			sum += Array[pos];
			buf[pos] = sum / iMAPeriod;
			sum -= Array[pos + iMAPeriod - 1];
			pos--;
		}
		return (buf[Shift + ma_shift]);
	}
	case MODE_EMA: {
		double pr = 2.0 / (iMAPeriod + 1);
		int pos = total - 2;
		while (pos >= 0) {
			if (pos == total - 2) buf[pos + 1] = Array[pos + 1];
			buf[pos] = Array[pos] * pr + buf[pos + 1] * (1 - pr);
			pos--;
		}
		return (buf[Shift + ma_shift]);
	}
	case MODE_SMMA: {
		double sum = 0;
		int i, k, pos;
		pos = total - iMAPeriod;
		while (pos >= 0) {
			if (pos == total - iMAPeriod) {
				for (i = 0, k = pos; i < iMAPeriod; i++, k++) {
					sum += Array[k];
					buf[k] = 0;
				}
			} else
				sum = buf[pos + 1] * (iMAPeriod - 1) + Array[pos];
			buf[pos] = sum / iMAPeriod;
			pos--;
		}
		return (buf[Shift + ma_shift]);
	}
	case MODE_LWMA: {
		double sum = 0.0, lsum = 0.0;
		double price;
		int i, weight = 0, pos = total - 1;
		for (i = 1; i <= iMAPeriod; i++, pos--) {
			price = Array[pos];
			sum += price * i;
			lsum += price;
			weight += i;
		}
		pos++;
		i = pos + iMAPeriod;
		while (pos >= 0) {
			buf[pos] = sum / weight;
			if (pos == 0) break;
			pos--;
			i--;
			price = Array[pos];
			sum = sum - lsum + price * iMAPeriod;
			lsum -= Array[i];
			lsum += price;
		}
		return (buf[Shift + ma_shift]);
	}
	default:
		return (0);
	}
	return (0);
}
//+------------------------------------------------------------------+
//| Exponential Average                                              |
//+------------------------------------------------------------------+
void EMA(double &Array[], int InpMAPeriod) {
	int count = ArraySize(Array) - 1;
	double pr = 2.0 / (InpMAPeriod + 1);
	count--;
	while (count >= 0) {
		Array[count] = Array[count] * pr + Array[count + 1] * (1 - pr);
		count--;
	}
}
//+------------------------------------------------------------------+
//|  Simple Average                                                  |
//+------------------------------------------------------------------+
void SimpleMA(double &price[], double &ExtLineBuffer[], int InpMAPeriod) {
	int rates_total = ArraySize(price);
	int i, ii;
	double Value;

	for (ii = 0; ii < (rates_total - InpMAPeriod); ii++) {
		Value = 0;
		for (i = 0; i < InpMAPeriod; i++) Value += price[ii + i];

		Value /= InpMAPeriod;

		ExtLineBuffer[ii] = Value;
	}
}
//+------------------------------------------------------------------+
//| Smoothed Average                                                 |
//+------------------------------------------------------------------+
void SmoothedMA(double &price[], double &ExtLineBuffer[], int InpMAPeriod) {
	int rates_total = ArraySize(price) - 1;
	int i, limit;
	limit = rates_total - InpMAPeriod;
	double firstValue = 0;

	for (i = rates_total; i > limit; i--) firstValue += price[i];
	firstValue /= InpMAPeriod;

	ExtLineBuffer[limit + 1] = firstValue;

	for (i = limit; i >= 0; i--) ExtLineBuffer[i] = (ExtLineBuffer[i + 1] * (InpMAPeriod - 1) + price[i]) / InpMAPeriod;
	//---
}
//+------------------------------------------------------------------+
//| Linear Weighted Average                                          |
//+------------------------------------------------------------------+
void LWMA(double &price[], double &ExtLineBuffer[], int InpMAPeriod) {
	int rates_total = ArraySize(price) - 1;
	int limit = rates_total - InpMAPeriod;
	int i, weightsum;
	weightsum = 0;
	double sum;

	double firstValue = 0;

	for (i = limit; i <= rates_total; i++) {
		int k = i - limit;
		weightsum += k;
		firstValue += k * price[i];
	}
	firstValue /= weightsum;
	ExtLineBuffer[limit + 1] = firstValue;

	//--- main loop
	for (i = limit; i >= 0; i--) {
		sum = 0;
		for (int j = 0; j < InpMAPeriod; j++) sum += (InpMAPeriod - j) * price[i + j];
		ExtLineBuffer[i] = sum / weightsum;
	}
	//---
}
