#ifndef _ABM_TABLE_H_
#define _ABM_TABLE_H_

#include "column.h"
#include <string>
#include <stdio.h>

namespace abm {

class Table {
public:
    Table(size_t numRows, size_t numKeys);
    ~Table();

    void Reset(size_t numKeys) { mNumKeys = numKeys; }
    void Populate();
    void DumpToCSV(const std::string& fileName);

private:
    size_t mNumColumns;
    size_t mNumRows;
    size_t mNumKeys;

    char*            mAllCols;
    Column<int64_t>* mKeyCol;
    Column<int64_t>* mValCols;
};

Table::Table(size_t numRows, size_t numKeys) :
    mNumColumns(11), mNumRows(numRows), mNumKeys(numKeys) {
    assert(mNumKeys > 0);
    assert(mNumKeys <= mNumRows);

    mAllCols = new char[mNumColumns*sizeof(Column<int64_t>)];
    for (int i = 0; i < mNumColumns; ++i) {
        char* colAddr = &mAllCols[i*sizeof(Column<int64_t>)];
        new(colAddr) Column<int64_t>(mNumRows);
    }

    mKeyCol  = reinterpret_cast<Column<int64_t>*>(&mAllCols[0]);
    mValCols = reinterpret_cast<Column<int64_t>*>(&mAllCols[sizeof(Column<int64_t>)]);
}

Table::~Table() {
    for (int i = 0; i < mNumColumns; ++i) {
        char* colAddr = &mAllCols[i*sizeof(Column<int64_t>)];
        reinterpret_cast<Column<int64_t>*>(colAddr)->~Column();
    }
    delete[] mAllCols;
}

void Table::Populate() {
    size_t numDiv = mNumRows / mNumKeys;
    size_t numMod = mNumRows % mNumKeys;
    for (size_t groupId = 0, groupBegin = 0; groupId < mNumKeys; ++groupId) {
        size_t groupEnd = groupBegin + numDiv + (groupId < numMod);
        for (size_t i = groupBegin; i < groupEnd; ++i) {
            (*mKeyCol)[i] = groupId+1;
        }
        //mKeyCol->Populate(groupBegin, groupEnd, 1);
        for (int i = 0; i < mNumColumns-1; ++i) {
            double ndvRatio = (double (i+1))/(double (mNumColumns - 1));
            size_t ndv = ndvRatio*(groupEnd-groupBegin);
            ndv = ndv == 0 ? 1 : ndv;
            mValCols[i].Populate(groupBegin, groupEnd, ndv);
        }
        groupBegin = groupEnd;
    }
}

void Table::DumpToCSV(const std::string& fileName) {
    FILE *fp = fopen(fileName.c_str(), "w+");

    for (int i = 0; i < mNumRows; ++i) {
        fprintf(fp, "%lld|", (*mKeyCol)[i]);
        for (int j = 0; j < mNumColumns - 1; ++j) {
            fprintf(fp, "%lld|", mValCols[j][i]);
        }
        fprintf(fp, "\n");
    }

    fclose(fp);
}

} // end of namespace abm

#endif
