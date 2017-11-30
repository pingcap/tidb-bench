#include <iostream>
#include "rocksdb/db.h"
#include <sys/time.h>
#include <random>
#include <gflags/gflags.h>

using namespace std;
using namespace rocksdb;

DEFINE_string(path, "/tmp/store_bench", "the path of the store.");
DEFINE_string(run, "get", "the work type to run, can be get/seek/load/txn/txn2/txn3");
DEFINE_int32(threads, 8, "number of threads to run");
DEFINE_int32(nop, 1024 *16, "number of ops to run for each thread.");
DEFINE_int32(num, 1024*1024*16, "number of key/value pairs.");
DEFINE_int32(vallen, 64, "value length.");

vector<mt19937_64> rgen(24);

DB *db;
vector<ColumnFamilyHandle*> cfh;
ColumnFamilyHandle *lockCF;
ColumnFamilyHandle *writeCF;
ColumnFamilyHandle *dataCF;
ColumnFamilyHandle *oldCF;

struct Params {
    int tid;
    int n;
    char *keyBuf;
    char *valBuf;
    string workType;
};

// fill 16 byte key with id.
void fillKey(Params *p, uint64_t id) {
    *(uint64_t *)(p->keyBuf) = id;
    *(uint64_t *)(p->keyBuf+8) = id;
    // used for seek key that does not match any valid key.
    *(uint32_t *)(p->keyBuf+16) = 1024;
}

// fill 64 bytes value with i.
void fillVal(Params *p, uint64_t id) {
    *(uint64_t *)p->valBuf = id;
    for (int i = 8; i < FLAGS_vallen-7; i+= 8) {
        *(uint64_t *)(p->valBuf+i) = rgen[p->tid]();
    }
}

uint64_t randKeyID(int tid) {
    return uniform_int_distribution<uint64_t>(0,  FLAGS_num)(rgen[tid]);
}

// put data sequentially into db.
void doLoad(Params *p) {
    for (int i = p->tid; i < FLAGS_num; i+=FLAGS_threads) {
        fillKey(p, uint64_t(i));
        fillVal(p, uint64_t(i));
        Slice key(p->keyBuf, 16);
        Slice val(p->valBuf, 64);
        auto batch = WriteBatch();
        batch.Put(writeCF, key, key);
        batch.Put(dataCF, key, val);
        db->Write(WriteOptions(), &batch);
    }
}

// Current transaction flow.
void doTxn(Params *p) {
    for (int i = 0; i < p->n; i++) {
        fillKey(p, randKeyID(p->tid));
        fillVal(p, uint64_t(i));
        Slice key(p->keyBuf, 16);
        Slice val(p->valBuf, 64);
        string oVal;
        // 1. The presume not exists.
        db->Get(ReadOptions(), lockCF, key, &oVal);
        db->Get(ReadOptions(), writeCF, key, &oVal);
        db->Get(ReadOptions(), dataCF, key, &oVal);

        // 2. prewrite.
        db->Get(ReadOptions(), lockCF, key, &oVal);
        db->Get(ReadOptions(), writeCF, key, &oVal);
        auto batch = WriteBatch();
        batch.Put(lockCF, key, key);
        batch.Put(dataCF, key, val);
        db->Write(WriteOptions(), &batch);

        // 3. commit.
        db->Get(ReadOptions(), lockCF, key, &oVal);
        batch.Clear();
        batch.Delete(lockCF, key);
        batch.Put(writeCF, key, val);
        db->Write(WriteOptions(), &batch);
    }
}

// New transaction flow insert.
void doTxn2(Params *p) {
    for (int i = 0; i < p->n; i++) {
        fillKey(p, randKeyID(p->tid));
        fillVal(p, uint64_t(i));
        Slice key(p->keyBuf, 16);
        Slice val(p->valBuf, 64);
        string oVal;
        // 1. Get the latest version.
        db->Get(ReadOptions(), writeCF, key, &oVal);
        db->Get(ReadOptions(), dataCF, key, &oVal);
        // 2. Prewrite
        db->Get(ReadOptions(), writeCF, key, &oVal);
        auto batch = WriteBatch();
        batch.Put(writeCF, key, key);
        batch.Put(dataCF, key, val);
        db->Write(WriteOptions(), &batch);

        // 2. Commit
        db->Get(ReadOptions(), writeCF, key, &oVal);
        db->Put(WriteOptions(), writeCF, key, key);
    }
}

// New transaction flow update.
void doTxn3(Params *p) {
    for (int i = 0; i < p->n; i++) {
        fillKey(p, randKeyID(p->tid));
        fillVal(p, uint64_t(i));
        Slice key(p->keyBuf, 16);
        Slice val(p->valBuf, 64);
        string oVal;
        // 1. Get the latest version.
        db->Get(ReadOptions(), writeCF, key, &oVal);
        db->Get(ReadOptions(), dataCF, key, &oVal);
        // 2. Prewrite
        db->Get(ReadOptions(), writeCF, key, &oVal);
        auto batch = WriteBatch();
        batch.Put(writeCF, key, key);
        batch.Put(dataCF, key, val);
        batch.Put(oldCF, key, key);
        db->Write(WriteOptions(), &batch);

        // 2. Commit
        db->Get(ReadOptions(), writeCF, key, &oVal);
        db->Put(WriteOptions(), writeCF, key, key);
    }
}


// get data randomly.
void doGet(Params *p) {
    for (int i = 0; i < p->n; i++) {
        fillKey(p, randKeyID(p->tid));
        Slice key(p->keyBuf, 16);
        string val;
        db->Get(ReadOptions(), key, &val);
        assert(val.size() == 64);
    }
}

// seek randomly
void doSeek(Params *p) {
    Iterator *it = db->NewIterator(ReadOptions());
    for (int i = 0; i < p->n; i++) {
        fillKey(p, randKeyID(p->tid));
        Slice key(p->keyBuf, 20);
        string val;
        it->Seek(key);
        it->key();
        assert(it->key().size() == 16);
        assert(it->value().size() == 64);
    }
    delete it;
}

void doWork(Params *p) {
    if (p->workType == "load") {
        doLoad(p);
    } else if (p->workType == "get") {
        doGet(p);
    } else if (p->workType == "seek") {
        doSeek(p);
    } else if (p->workType == "txn") {
        doTxn(p);
    } else if (p->workType == "txn2") {
        doTxn2(p);
    } else if (p->workType == "txn3") {
        doTxn3(p);
    }
}

void *work(void *params) {
    auto *p = (Params *)params;
    struct timeval start;
    struct timeval end;
    long dur;
    gettimeofday(&start, nullptr);
    doWork(p);
    gettimeofday(&end, nullptr);
    dur = 1000000 * (end.tv_sec-start.tv_sec)+ end.tv_usec-start.tv_usec;
    cout << double(dur)/(p->n) << " us/op" << endl;
}

void openDB() {
    Options options;
    if (FLAGS_run == "load") {
        options.create_if_missing = true;
        options.create_missing_column_families = true;
    }
    vector<ColumnFamilyDescriptor> cfs;
    cfs.emplace_back(kDefaultColumnFamilyName, ColumnFamilyOptions());
    cfs.emplace_back("lock", ColumnFamilyOptions());
    cfs.emplace_back("data", ColumnFamilyOptions());
    cfs.emplace_back("old", ColumnFamilyOptions());
    Status s = DB::Open(options, FLAGS_path, cfs, &cfh, &db);
    assert(s.ok());
    writeCF = cfh[0];
    lockCF = cfh[1];
    dataCF = cfh[2];
    oldCF = cfh[3];
}

void run() {
    string workType = FLAGS_run;
    int32_t nthreads = FLAGS_threads;
    struct timeval start, end;
    gettimeofday(&start, nullptr);
    vector<pthread_t> threads((unsigned long)FLAGS_threads);
    for (int i = 0; i < nthreads; i++) {
        auto *params = new(Params);
        params->tid = i;
        params->workType = workType;
        if (workType == "load") {
            params->n = FLAGS_num / nthreads;
        } else {
            params->n = FLAGS_nop;
        }
        params->keyBuf = (char *)malloc(20);
        params->valBuf = (char *)malloc(64);
        pthread_create(&threads[i], nullptr, &work, params);
    };

    for (int i = 0; i < nthreads; i++) {
        pthread_join(threads[i], nullptr);
    };
    gettimeofday(&end, nullptr);
    int totalOps = nthreads * FLAGS_nop;
    if (workType == "load") {
        totalOps = FLAGS_num;
    }
    double dur = double(end.tv_sec-start.tv_sec) + double(end.tv_usec-start.tv_usec)/1000000;
    cout << double(totalOps) / dur << " op/sec" << endl;
}

void initRands() {
    for (unsigned long i=0; i<24; i++) {
        rgen[i] = mt19937_64(i*31);
    }
}

int main(int argc, char** argv) {
    gflags::ParseCommandLineFlags(&argc, &argv, true);
    initRands();
    openDB();
    run();
    for (auto handle : cfh) {
        delete handle;
    }
    delete db;
    return 0;
}
