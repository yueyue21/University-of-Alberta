# Berkeley DB Example

__author__ = "Bing Xu"
__email__ = "bx3@ualberta.ca"

import bsddb
from ctypes import cdll
lib = cdll.LoadLibrary('./libfoo.so')

# Make sure you run "mkdir /tmp/my_db" first!
DA_FILE = "/tmp/my_db/sample_db"
DB_SIZE = 1000
SEED = 10000000


def main():
    try:
        db = bsddb.btopen(DA_FILE, "w")
    except:
        print "DB doesn't exist, creating a new one"
        db = bsddb.btopen(DA_FILE, "c")
    lib.set_seed(SEED)

    for index in range(DB_SIZE):
        krng = 64 + lib.get_random() % 64
        key = ""
        for i in range(krng):
            key += str(unichr(lib.get_random_char()))
        vrng = 64 + lib.get_random() % 64
        value = ""
        for i in range(vrng):
            value += str(unichr(lib.get_random_char()))
        print key
        print value
        print ""
        db[key] = value
    try:
        db.close()
    except Exception as e:
        print e

if __name__ == "__main__":
    main()
