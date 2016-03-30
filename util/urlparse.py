#!/bin/python
import sys, urlparse, json; 


json.dump(urlparse(sys.stdin), sys.stdout, indent=4)


