#!/usr/bin/env python
#!coding:utf-8

import shutil

def main():
    shutil.rmtree("no-distinct")
    shutil.rmtree("one-distinct-with-others")
    shutil.rmtree("one-distinct-without-others")
    shutil.rmtree("two-different-distinct-with-others")
    shutil.rmtree("two-different-distinct-without-others")
    shutil.rmtree("two-same-distinct-with-others")
    shutil.rmtree("two-same-distinct-without-others")

if __name__ == "__main__":
    main()
