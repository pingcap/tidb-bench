#ifndef _ABM_TABLE_H_
#define _ABM_TABLE_H_

#include "column.h"

#include <unordered_map>
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
    mNumColumns(10), mNumRows(numRows), mNumKeys(numKeys) {
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
    std::unordered_map<size_t, size_t> valColNDV({
        {0, 1 << 0},
        {1, 1 << 1},
        {2, 1 << 2},
        {3, 1 << 3},
        {4, 1 << 4},
        {5, 1 << 5},
        {6, 1 << 6},
        {7, 1 << 7},
    });
    size_t numDiv = mNumRows / mNumKeys;
    size_t numMod = mNumRows % mNumKeys;
    for (size_t groupId = 0, groupBegin = 0; groupId < mNumKeys; ++groupId) {
        size_t groupEnd = groupBegin + numDiv + (groupId < numMod);

        // Populate key column.
        for (size_t i = groupBegin; i < groupEnd; ++i) {
            (*mKeyCol)[i] = groupId+1;
        }

        // Populate val column 0~7
        for (auto it = valColNDV.begin(); it != valColNDV.end(); ++it) {
            size_t colId = it->first;
            size_t ndv = it->second;
            ndv = std::min(ndv, groupEnd-groupBegin);
            mValCols[colId].Populate(groupBegin, groupEnd, ndv);
        }

        // Populate val column 8
        mValCols[8].Populate(groupBegin, groupEnd, groupEnd-groupBegin);

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
