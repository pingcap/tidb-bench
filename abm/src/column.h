#ifndef _ABM_COLUMN_H_
#define _ABM_COLUMN_H_

#include <stdint.h>
#include <stddef.h>
#include <assert.h>

namespace abm {

template<class T>
class Column {
public:
    explicit Column(size_t size);
    ~Column();

    T& operator [] (size_t idx);
    size_t Size() { return mSize; }
    void Populate(size_t begin, size_t end, size_t ndv);

private:
    T*     mData;
    size_t mSize;
};

template<class T>
Column<T>::Column(size_t size) :
    mData(NULL), mSize(size) {
    if (mSize == 0) {
        return;
    }
    mData = new T[mSize];
}

template<class T>
Column<T>::~Column() {
    if (mData != NULL) {
        delete []mData;
        mData = NULL;
    }
}

template<class T>
T& Column<T>::operator [] (size_t idx) {
    assert(idx < mSize);
    return mData[idx];
}

template<class T>
void Column<T>::Populate(size_t begin, size_t end, size_t ndv) {
}

template<>
void Column<int64_t>::Populate(size_t begin, size_t end, size_t ndv) {
    assert(ndv > 0);
    assert(ndv <= end - begin);
    size_t numDiv = (end - begin) / ndv;
    size_t numMod = (end - begin) % ndv;

    for (size_t groupId = 0, groupBegin = begin; groupId < ndv; ++groupId) {
        size_t groupEnd = groupBegin + numDiv + (groupId < numMod);
        for (size_t i = groupBegin; i < groupEnd; ++i) {
            mData[i] = groupId+1;
        }
        groupBegin = groupEnd;
    }
}

template<>
void Column<double>::Populate(size_t begin, size_t end, size_t ndv) {
    assert(end - begin >= ndv);
    size_t numDiv = (end - begin) / ndv;
    size_t numMod = (end - begin) % ndv;

    for (size_t groupId = 0, groupBegin = begin; groupId < ndv; ++groupId) {
        size_t groupEnd = groupBegin + numDiv + (groupId < numMod);
        for (size_t i = groupBegin; i < groupEnd; ++i) {
            mData[i] = groupId+1.1;
        }
        groupBegin = groupEnd;
    }
}

} // end of namespace abm

#endif
