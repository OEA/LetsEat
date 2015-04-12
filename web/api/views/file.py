__author__ = 'bahadirkirdan'

import datetime
import json
import os


def create_file(requestJSON, responseJSON, method_name, request_method):

    if os.path.exists("log.txt"):
        log_file = open("log.txt", "a+")
    else:
        log_file = open("log.txt", "w")

    log_file.write("\n\n--------------------------\n")
    log_file.write("METHOD NAME: " + method_name + "\n")
    log_file.write("REQUEST METHOD: " + request_method + "\n")
    log_file.write("REQUEST DATE: " + str(datetime.datetime.now()) + "\n")
    log_file.write("RESPONSE: \n")
    json.dump(responseJSON, log_file, indent=4)

    log_file.close()