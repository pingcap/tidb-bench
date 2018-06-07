#!/usr/bin/env python
#!coding:utf-8

import argparse
import subprocess
import time

class SQLFileRunner:
    def __init__(self, args, sessionVariables):
        self.__runTimes = args.count
        self.__outputResult = args.output
        self.__mysqlCommand = self.__create_mysql_command(args)
        self.__sessionVariables = sessionVariables
        self.__stdInFile  = "/tmp/stdin.txt"
        self.__stdOutFile = "/dev/null"
        self.__stdErrFile = "/tmp/stderr.txt"

    def run(self, userInFile):
        if self.__outputResult:
            self.__run_test(userInFile)
        else:
            self.__run_bench(userInFile)

    def __run_test(self, userInFile):
        errFile = open(self.__stdErrFile, "w+")
        for i in range(0, self.__runTimes):
            inFile  = self.__create_stdin_file(userInFile)
            try:
                output = subprocess.check_output(self.__mysqlCommand, stdin=inFile, stderr=errFile)
            except subprocess.CalledProcessError as e:
                inFile.close()
                errFile.close()
                errFile = open(self.__stdErrFile, "r")
                errMsg = errFile.read()
                print("{}: {}".format(userInFile, errMsg))
                break

            print("result of {} is:\n{}".format(userInFile, output))
            inFile.close()
        errFile.close()

    def __run_bench(self, userInFile):
        outFile = open(self.__stdOutFile, "w")
        errFile = open(self.__stdErrFile, "w+")

        for i in range(0, self.__runTimes):
            inFile  = self.__create_stdin_file(userInFile)
            try:
                startTime = time.time()
                subprocess.check_call(self.__mysqlCommand, stdin=inFile, stdout=outFile, stderr=errFile)
                stopTime = time.time()
            except subprocess.CalledProcessError as e:
                inFile.close()
                errFile.close()
                errFile = open(self.__stdErrFile, "r")
                errMsg = errFile.read()
                print("{}: {}".format(userInFile, errMsg))
                break

            print("{}: {}s".format(userInFile, stopTime-startTime))
            inFile.close()

        outFile.close()
        errFile.close()

    def __create_mysql_command(self, args):
        command = ["mysql"]
        command = command + ["-h", args.host]
        command = command + ["-P", args.port]
        command = command + ["-u", args.user]
        command = command + ["-D", args.database]
        command = command + ["--connect-timeout", "1"]
        if args.passwd != "":
            command = command + ["-p{}".format(args.passwd)]
        return command

    def __create_stdin_file(self, userInFile):
        if len(self.__sessionVariables) == 0:
            inFile = open(userInFile, "r")
            return inFile

        with open(userInFile, "r") as f:
            originContent = f.read()
        with open(self.__stdInFile, "w+") as f:
            for variable in self.__sessionVariables:
                f.write("{}\n".format(variable))
            f.write(originContent)
        inFile  = open(self.__stdInFile,  "r")
        return infile

def main():
    args = parse_args()
    sessionVariables = [
        #"set @@tidb_max_chunk_size=4096;",
        #"set @@tidb_distsql_scan_concurrency=100;",
    ]
    runner = SQLFileRunner(args, sessionVariables)
    runner.run(args.file)

def parse_args():
    parser = argparse.ArgumentParser(description="Run SQLs in the provided file and count the total running time.")
    parser.add_argument("--host",     dest="host",     type=str,  help="Server address. DEFAULT: 127.0.0.1", default="127.0.0.1")
    parser.add_argument("--port",     dest="port",     type=str,  help="Server port. DEFAULT: 4000",         default="4000")
    parser.add_argument("--user",     dest="user",     type=str,  help="User for login. DEFAULT: root",      default="root")
    parser.add_argument("--passwd",   dest="passwd",   type=str,  help="Passwd for the user. DEFAULT: ''",   default="")
    parser.add_argument("--database", dest="database", type=str,  help="Database to use. DEFAULT: test",     default="test")
    parser.add_argument("--count",    dest="count",    type=int,  help="Times to run. DEFAULT: 1",           default=1)
    parser.add_argument("--output",   dest="output",   type=bool, help="Output the result. DEFAULT: False",  default=False)
    parser.add_argument("file", help="SQL file to run")
    args = parser.parse_args()
    return args

if __name__ == "__main__":
    main()
