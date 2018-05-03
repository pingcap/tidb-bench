#include "column.h"
#include "table.h"
#include <iostream>

const static size_t sNumRows = 1000000;

int main() {
    size_t sf = 1;

    // generate table with only one key firstly.
    abm::Table table(sNumRows*sf, 1);
    table.Populate();
    table.DumpToCSV("tab1.tbl");

    std::string fileNames[] = {"tab10.tbl", "tab20.tbl", "tab30.tbl", "tab40.tbl", "tab50.tbl", "tab60.tbl", "tab70.tbl", "tab80.tbl", "tab90.tbl", "tab100.tbl"};
    // generate table with "ndv" keys.
    for (int i = 0; i < 10; ++i) {
        double ndvRatio = (double (i+1))/(10);
        size_t ndv = ndvRatio*(sNumRows*sf);
        table.Reset(ndv);
        table.Populate();
        table.DumpToCSV(fileNames[i]);
    }
    return 0;
}
