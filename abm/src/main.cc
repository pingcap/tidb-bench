#include "table.h"

#include <string>
#include <unordered_map>

const static size_t sNumRows = 1 << 20;

int main() {
    size_t sf = 1;
    abm::Table table(sNumRows*sf, 1);

    // generate table with "ndv" keys.
    // table_csv_file_name -> table_key_ndv
    std::unordered_map<std::string, int64_t> restTables({
        {"t0.tbl",   1 << 0},
        {"t2.tbl",   1 << 2},
        {"t4.tbl",   1 << 4},
        {"t6.tbl",   1 << 6},
        {"t8.tbl",   1 << 8},
        {"t10.tbl",  1 << 10},
        {"t12.tbl",  1 << 12},
        {"full.tbl", sNumRows*sf},
    });
    for (auto it = restTables.begin(); it != restTables.end(); ++it) {
        table.Reset(it->second);
        table.Populate();
        table.DumpToCSV(it->first);
    }
    return 0;
}
