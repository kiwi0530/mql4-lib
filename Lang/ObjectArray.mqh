
/*
 */
//+------------------------------------------------------------------+
//| Module: Lang/ObjectArray.mqh                                           |
//| This file is part of the mql4-lib project:                       |
//|     https://github.com/dingmaotu/mql4-lib                        |
//|                                                                  |
//| Copyright 2016 Li Ding <dingmaotu@126.com>                       |
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
#ifndef __OBJECTARRAY_MQH__
#define __OBJECTARRAY_MQH__

#include "Native.mqh"

#property strict

// template <typename T>
// bool ObjectArrayCompareElement(T& src, T& dst) {
// 	//we have native.mhq memcpy, so use it
// 	int src2 = 1;
// 	int dst2 = 2;
// 	intptr_t p_src;
// 	ValueToPointer(src2, p_src);
// 	intptr_t p_dst;
// 	ValueToPointer(dst2, p_dst);
// 	Print("p_src=", p_src);
// 	Print("p_dst=", p_dst);
// 	uchar bytes_src[];
// 	uchar bytes_dst[];
// 	ArrayResize(bytes_src, sizeof(T));
// 	ArrayResize(bytes_dst, sizeof(T));
// 	ArrayFromPointer(bytes_src, p_src);
// 	ArrayFromPointer(bytes_dst, p_dst);
// 	int result = ArrayCompare(bytes_src, bytes_dst);
// 	ArrayFree(bytes_src);
// 	ArrayFree(bytes_dst);
// 	return result == 0;
// }

template <typename T>
void ObjectArrayInsert(T& array[], int index, T& value, int extraBuffer = 10) {
	int size = ArraySize(array);
	if (index < 0 || index > size) return;
	ArrayResize(array, size + 1, extraBuffer);
	for (int i = size; i > index; i--) {
		array[i] = array[i - 1];
	}
	array[index] = value;
}

template <typename T>
void ObjectArrayDelete(T& array[], int index) {
	int size = ArraySize(array);
	if (index < 0 || index >= size) return;

	for (int i = index; i < size - 1; i++) {
		array[i] = array[i + 1];
	}
	ArrayResize(array, size - 1);
}

template <typename T>
int ObjectArrayDeleteAll(T& array[], T& value) {
	int s = ArraySize(array);
	int i = 0;
	for (int j = 0; j < s; j++) {
		if (!ObjectArrayCompareElement(array[j], value)) {
			if (i != j) {
				array[i] = array[j];
			}
			i++;
		}
	}
	if (i < s) ArrayResize(array, i);
	return s - i;
}
// template <typename T>
// int ObjectArrayFind(const T& array[], const T value) {
// 	int s = ArraySize(array);
// 	int index = -1;
// 	for (int i = 0; i < s; i++) {
// 		if (value == array[i]) {
// 			index = i;
// 			break;
// 		}
// 	}
// 	return index;
// }
// template <typename T>
// int BinarySearch(const T& array[], T value) {
// 	int size = ArraySize(array);
// 	int begin = 0, end = size - 1, mid = 0;
// 	while (begin <= end) {
// 		mid = (begin + end) / 2;
// 		if (array[mid] < value) {
// 			mid++;
// 			begin = mid;
// 			continue;
// 		} else if (array[mid] > value) {
// 			end = mid - 1;
// 			continue;
// 		} else {
// 			break;
// 		}
// 	}
// 	return mid;
// }
// template <typename T>
// bool ArrayFindMatch(const T& a[], const T& b[], T& result) {
// 	int sizeA = ArraySize(a);
// 	int sizeB = ArraySize(b);
// 	if (sizeA == 0 || sizeB == 0) return false;

// 	for (int i = 0; i < sizeA; i++)
// 		for (int j = 0; j < sizeB; j++)
// 			if (a[i] == b[j]) {
// 				result = a[i];
// 				return true;
// 			}
// 	return false;
// }
template <typename T>
int ObjectArrayBatchRemove(T& array[], const int& removed[]) {
	int s = ArraySize(array);
	int i = 0;
	int k = 0;
	for (int j = 0; j < s; j++) {
		if (k >= ArraySize(removed) || j != removed[k]) {
			if (i != j) {
				array[i] = array[j];
			}
			i++;
		} else
			k++;
	}
	if (i < s) {
		ArrayResize(array, i);
		return s - i;
	} else
		return 0;
}
//+------------------------------------------------------------------+
//| This kind of array specialized to store class like element, pointer please use Array
//+------------------------------------------------------------------+
template <typename T>
class ObjectArray {
private:
	int m_extraBuffer;
	T m_array[];

protected:
	void clearArray();

public:
	ObjectArray(int extraBuffer = 10) : m_extraBuffer(extraBuffer) { resize(0); }
	~ObjectArray() {
		clearArray();
		ArrayFree(m_array);
	}

	bool isSeries() const { return ArrayIsSeries(m_array); }
	void setSeries(bool value) { ArraySetAsSeries(m_array, value); }

	int size() const { return ArraySize(m_array); }
	void resize(int size) {
		bool s = isSeries();
		setSeries(false);
		ArrayResize(m_array, size, m_extraBuffer);
		setSeries(s);
	}

	void setExtraBuffer(int value) {
		m_extraBuffer = value;
		resize(size());
	}
	int getExtraBuffer() const { return m_extraBuffer; }

	void clear() {
		clearArray();
		resize(0);
	}
	T pop() {
		T value = m_array[size() - 1];
		removeAt(size() - 1);
		return value;
	}
	T operator[](const int index) { return m_array[index]; }
	void set(const int index, T& value) { m_array[index] = value; }
	void insertAt(int index, T& value) { ObjectArrayInsert(m_array, index, value, m_extraBuffer); }
	void removeAt(int index) { ObjectArrayDelete(m_array, index); }
	int removeAll(T& value) { return ObjectArrayDeleteAll(m_array, value); }
	int removeBatch(const int& removed[]) { return ObjectArrayBatchRemove(m_array, removed); }
	void push(T& value) { insertAt(size() == 0 ? 0 : size() - 1, value); }
	int index(T& value) const;
};
template <typename T>
void ObjectArray::clearArray() {
	ArrayFree(m_array);
}

template <typename T>
int ObjectArray::index(T& value) const {
	int s = ArraySize(m_array);
	int index = -1;
	for (int i = 0; i < s; i++) {
		if (ObjectArrayCompareElement(value, m_array[i])) {
			index = i;
			break;
		}
	}
	return index;
}

#endif	// __OBJECTARRAY_MQH__
