#include <iostream>
#include <cstdio>
#include <cassert>
#include <cstring>
#include <string>
#include <vector>
#include <map>
#include <sstream>
#include <fstream>
#include <regex>
#include <sys/sysinfo.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <sys/wait.h>
#include <dirent.h>

std::string transform_arg(std::string s) {
	assert(!s.empty());
	char last = s[s.size() - 1];
	uint64_t base = 1;
	switch (last) {
		case 'g': base <<= 10;
		case 'm': base <<= 10;
		case 'k': base <<= 10;
			s.pop_back();
		default:
			break;
	}
	return std::to_string(std::stoull(s) * base);
}

std::string get_sys_mem_as_str() {
	struct sysinfo s_info;
	assert(!sysinfo(&s_info));
	return std::to_string(uint64_t(double(s_info.totalram >> 20) * 0.15)) + "m";
}

const std::string dir = "/data1/rocksdb_bench";

const std::map<std::string, std::string> rocksdb_args = {
	{"batch_size",                                  "1"},
	{"cache_size",                                  get_sys_mem_as_str()},
	{"block_size",                                  "64k"},
	{"cache_index_and_filter_blocks",               "1"},
	{"key_size",                                    "16"},
	{"level0_file_num_compaction_trigger",          "4"},
	{"level0_slowdown_writes_trigger",              "20"},
	{"level0_stop_writes_trigger",                  "36"},
	{"max_bytes_for_level_base",                    "512m"},
	{"max_bytes_for_level_multiplier",              "10"},
	{"max_compaction_bytes",                        "2g"},
	{"max_write_buffer_number",                     "5"},
	{"min_write_buffer_number_to_merge",            "1"},
	{"num",                                         "100000"},
	{"pin_l0_filter_and_index_blocks_in_cache",     "1"},
	{"target_file_size_base",                       "8m"},
	{"threads",                                     "1"},
	{"value_size",                                  "100"},
	{"write_buffer_size",                           "128m"},
};

const std::map<std::string, std::map<std::string, std::string>> tests = {
	{"all_rnd_write",     {{"benchmarks", "fillrandom"}, {"threads", "8"}}},
	{"all_seq_write",     {{"benchmarks", "fillseq"}, {"threads", "8"}}},
	{"half_write",       {{"benchmarks", "readwhilewriting"}, {"threads", "2"}}},
	{"one_fifth_write",   {{"benchmarks", "readwhilewriting"}, {"threads", "4"}}},
};

const std::vector<std::string> basic = {
	"rocksdb.block.cache.miss",
	"rocksdb.block.cache.hit",
	"rocksdb.l0.slowdown.micros"
};

const std::vector<std::string> percentile = {
	"rocksdb.db.get.micros",
	"rocksdb.db.write.micros",
	"rocksdb.l0.slowdown.count"
};

void print_args() {
	printf("          name                      encode       decode\n");
	for (auto e : rocksdb_args)
		printf("%-36s %-12s %s\n", e.first.c_str(), e.second.c_str(), transform_arg(e.second).c_str());
}

void print_tests() {
	printf("supported tests:\n");
	for (auto e : tests)
		printf("%s\n", e.first.c_str());
}

std::string get_whole_line(const std::string &pattern, std::string &str) {
	size_t ptr = str.find(pattern);
	assert(ptr != std::string::npos);
	str = str.substr(ptr);
	ptr = str.find('\n');
	std::string sub(str.begin(), str.begin() + ptr);
	str = str.substr(ptr + 1);
	return sub;
}

class Test {
	public:
		Test(std::string name, std::string prefix) {
			prefix_ = prefix;
			std::ifstream file(name);
			assert(file.is_open());

			file >> test_;
			if (tests.find(test_) == tests.end()) {
				print_tests();
				exit(1);
			}
			assert(file.good());

			file >> count_;
			assert(file.good());

			file >> arg_;
			assert(file.good());

			char tmp[128];
			file.getline(tmp, 128);
			file.getline(tmp, 128);
			std::stringstream choice;
			choice << std::string(tmp);
			while (!choice.eof()) {
				std::string tmp;
				choice >> tmp;
				choices_.push_back(tmp);
				assert(choice.good() || choice.eof());
			}

			while (!file.eof()){
				char tmp[128];
				file.getline(tmp, 128);
				std::stringstream choice;
				if (tmp[0] == '\0')
					break;
				choice << std::string(tmp);
				while (!choice.eof()) {
					std::string k;
					choice >> k;
					assert(choice.good());
					std::string v;
					choice >> v;
					assert(choice.good() || choice.eof());
					override_.insert({k, v});
				}
			}
		}

		void print() {
			printf("%s\n", test_.c_str());
			printf("%lu\n", count_);
			printf("%s\n", arg_.c_str());
			for (auto e : choices_)
				printf("%s ", e.c_str());
			printf("\n");
		}

		std::string generate_script(size_t i, const std::string &db_dir) {
			auto copy_args = rocksdb_args;
			auto args = tests.at(test_);
			for (auto e : args)
				if (rocksdb_args.find(e.first) != rocksdb_args.end())
					copy_args[e.first] = e.second;

			for (auto e : override_) {
				assert(rocksdb_args.find(e.first) != rocksdb_args.end());
				if (e.first != "threads" || (test_ != "half_write" && test_ != "one_fifth_write"))
					copy_args[e.first] = e.second;
			}

			std::string head = "--";
			std::string tail = " \\\n";
			std::string script = "#! /bin/sh\n\n";
			script += "./db_bench" + tail;
			script += head + "statistics" + tail;
			script += head + "db" + "=" + db_dir + tail;
			script += head + "benchmarks" + "=\"" + args["benchmarks"] + ",stats,levelstats"+ "\"" + tail;
			for (auto e : copy_args) {
				if (e.first == arg_)
					e.second = choices_[i];
				script += head + e.first + "=" + transform_arg(e.second) + tail;
			}
			return script;
		}

		std::string save_script(const std::string &prefix, const std::string& script) {
				std::string path(prefix_ + "/" + prefix + ".script");
				std::ofstream file(path, std::ios::trunc);
				assert(file.is_open());
				file << script;
				file.flush();
				file.close();
				chmod(path.c_str(), S_IXUSR | S_IRUSR | S_IWUSR);
				return path;
		}

		std::string get_prefix(size_t i, size_t j) {
			return std::to_string(i) + "_" + std::to_string(j);
		}

		std::string get_result_file_name(size_t i, size_t j) {
			return prefix_ + "/" + get_prefix(i, j) + ".result";
		}

		void destroy_db(const std::string &db_dir) {
			DIR *dirp;
			struct dirent *direntp;
			if ((dirp = opendir(db_dir.c_str()))) {
				while ((direntp = readdir(dirp))) {
					char file[1024];
					sprintf(file,"%s/%s", db_dir.c_str(), direntp->d_name);
					struct stat statbuf;
					if (stat(file, &statbuf) >= 0 && S_ISREG(statbuf.st_mode)) {
						remove(file);
					}
				}
				rmdir(db_dir.c_str());
			}
		}

		void show_per_test_result(size_t seq, double ops, double mb,
			std::vector<double> &basic_stats,
			std::vector<double> &percentile_stats_p95,
			std::vector<double> &percentile_stats_p99) {
			printf("%s  %s\n", arg_.c_str(), choices_[seq].c_str());
			printf("ops:  %lf\n", ops / count_);
			printf("mb/s: %lf\n", mb / count_);
			size_t i = 0;
			for (auto e : basic) {
				printf("%-30s: %lf\n", e.c_str(), basic_stats[i++] / count_);
			}
			i = 0;
			for (auto e : percentile) {
				printf("%s\np95: %lf\np99: %lf\n", e.c_str(), percentile_stats_p95[i] / count_, percentile_stats_p99[i] / count_);
				++i;
			}
			printf("\n");
		}

		void compile_result() {
			std::string R = prefix_ + "/" + "final.result";
			assert(freopen(R.c_str(), "w", stdout));
			for (size_t i = 0; i < choices_.size(); ++i) {
				double ops = 0;
				double mb = 0;
				std::vector<double> basic_stats(basic.size(), 0);
				std::vector<double>  percentile_stats_p95(percentile.size(), 0);
				std::vector<double>  percentile_stats_p99(percentile.size(), 0);
				for (size_t j = 0; j < count_; ++j) {
					std::string result = get_result_file_name(i, j);
					auto override = tests.at(test_);
					std::string bench = override["benchmarks"];
					std::ifstream file(result);
					size_t size = 20 * 1024 * 1024;
					std::string str(size, '\0');
					file.read(&str[0], size);
					std::string sub_str = get_whole_line(bench, str);
					// std::cout << sub_str << std::endl;
					std::smatch match;
					std::regex regex("[\.0-9]+");
					std::regex_search(sub_str, match, regex);
					sub_str = match.suffix().str();
					// std::cout << match.begin()->str() << std::endl;
					std::regex_search(sub_str, match, regex); // get ops/sec
					sub_str = match.suffix().str();
					// std::cout << match.begin()->str() << std::endl;
					ops += std::stod(match.begin()->str());
					std::regex_search(sub_str, match, regex); // get MB/s
					// std::cout << match.begin()->str() << std::endl;
					mb += std::stod(match.begin()->str());

					size_t i = 0;
					for (auto e : basic) {
						std::regex regex("[1-9]\d*|0$");
						std::string sub_str = get_whole_line(e, str);
						std::regex_search(sub_str, match, regex);
						// std::cout << sub_str << std::endl;
						// std::cout << match.begin()->str() << std::endl;
						basic_stats[i++] += std::stod(match.begin()->str());
					}

					i = 0;
					for (auto e : percentile) {
						std::string sub_str = get_whole_line(e, str);
						// std::cout << sub_str << std::endl;
						std::regex regex("[0-9]+\.[0-9]+");
						size_t ptr = sub_str.find("95 :");
						sub_str = sub_str.substr(ptr + 1);
						std::regex_search(sub_str, match, regex);
						// std::string p95 = match.begin()->str();
						percentile_stats_p95[i] += std::stod(match.begin()->str());
						sub_str = match.suffix().str();
						ptr = sub_str.find("99 :");
						sub_str = sub_str.substr(ptr + 1);
						std::regex_search(sub_str, match, regex);
						// std::string p99 = match.begin()->str();
						percentile_stats_p99[i++] += std::stod(match.begin()->str());
						// std::cout << p95 << "  " << p99<< std::endl;
					}
				}
				show_per_test_result(i, ops, mb, basic_stats, percentile_stats_p95, percentile_stats_p99);
			}
			rmdir(dir.c_str());
		}

		void run() {
			mkdir(dir.c_str(), S_IXUSR | S_IRUSR | S_IWUSR | S_IRWXO);
			mkdir(prefix_.c_str(), S_IXUSR | S_IRUSR | S_IWUSR | S_IRWXO);
			for (size_t i = 0; i < choices_.size(); ++i) {
				for (size_t j = 0; j < count_; ++j) {
					pid_t pid = fork();
					assert(pid >= 0);
					std::string prefix = get_prefix(i, j);
					std::string db_dir = dir + "/" + arg_ + "_" + prefix;
					std::string result = get_result_file_name(i, j);
					std::string script = save_script(prefix, generate_script(i, db_dir));
					if (pid == 0) {
						assert(freopen(result.c_str(), "w", stdout));
						execl("/bin/sh", "sh", script.c_str(), (char *)0);
					} else {
						int status;
						printf("running test %s  %s  %lu\n", arg_.c_str(), choices_[i].c_str(), j + 1);
						assert(waitpid(pid, &status, 0) > 0);
						printf("running test %s  %s  %lu finished\n", arg_.c_str(), choices_[i].c_str(), j + 1);
						destroy_db(db_dir);
					}
					sleep(120);
				}
			}
			compile_result();
		}

	private:
		std::string                        prefix_;
		std::string                        test_;
		size_t                             count_;
		std::string                        arg_;
		std::vector<std::string>           choices_;
		std::map<std::string, std::string> override_;
};

int main(int argc, char **argv) {
	std::string name = std::string(argv[1]);
	std::string prefix = std::string(argv[2]);
	Test test(name, prefix);
	test.run();
	return 0;
}
