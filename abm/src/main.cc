#include "table.h"

#include <stdlib.h>
#include <stdio.h>
#include <string>
#include <unordered_map>
#include <algorithm>

const static size_t sNumRows = 1 << 20;

bool cmdOptionExists(char** begin, char** end, const std::string& option) {
    return std::find(begin, end, option) != end;
}

void printHelpMessage() {
    printf("Usage: ./dbgen [OPTION]\n\n");
    printf("OPTION:\n");
    printf("    -h, --help: show this help message.\n");
    printf("    -s <sf>: set the scale factor to \"sf\", default is 1.\n");
}

int getScaleFactor(char** begin, char** end) {
    std::string option = "-s";
    char** it = std::find(begin, end, option);
    if (it == end) {
        return 1;
    }
    if (++it == end) {
        return -1;
    }
    return atoi(*it);
}

int main(int argc, char* argv[]) {
    if (cmdOptionExists(argv, argv+argc, "-h") || cmdOptionExists(argv, argv+argc, "--help")) {
        printHelpMessage();
        return 0;
    }

    int sf = getScaleFactor(argv, argv+argc);
    if (sf <== 0) {
        printf("Option \"-s\" should followed by a positive integer value.\n");
        return -1;
    } else {
        printf("Use scale factor: %d\n", sf);
    }

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
    abm::Table table(sNumRows*sf, 1);
    for (auto it = restTables.begin(); it != restTables.end(); ++it) {
        table.Reset(it->second);
        table.Populate();
        table.DumpToCSV(it->first);
    }
    return 0;
}
