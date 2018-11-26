#!/usr/bin/env python3
import argparse
import os
import yaml

parser = argparse.ArgumentParser()
parser.add_argument("-l", "--libs-file", help="Add libs.txt file", required=True)
parser.add_argument("--dir-skip", help="Dir skip", required=False)
parser.add_argument("--lib-skip", help="Lib skip", required=False)
parser.add_argument("--file-skip", help="File skip", required=False)
parser.add_argument("--work", help="Files to add to work library", required=False)

args = parser.parse_args()
dir_skip = (args.dir_skip or "").split(" ")
lib_skip = (args.lib_skip or "").split(" ")
file_skip = (args.file_skip or "").split(" ")
work = (args.work or "").split(" ")

work_lib = {
            "name":"work",
            "paths":[]
            }

output_file = {
    "Libraries":[],
    "TypeCheck": True,
    "CheckOnChange": True,
    "Lint":{
        "Threshold": "Warning",
        "DeclaredNotAssigned":{ 
            "enabled":  True,
            "severity": "Warning"
            },
    "DeclaredNotRead": True,
    "ReadNotAssigned": True,
    "SensitivityListCheck": True,
    "ExtraSensitivityListCheck": True,
    "DuplicateSensitivity":   True,
    "LatchCheck":             True,
    "VariableNotRead":        True,
    "VariableNotWritten":     True,
    "PortNotRead":            True,
    "PortNotWritten":         True,
    "NoPrimaryUnit":          True,
    "DuplicateLibraryImport": True,
    "DuplicatePackageUsage":  True,
    "DeprecatedPackages":     True,
    "ImplicitLibraries":      True,
    "DisconnectedPorts":      True
    }
    }
current_lib = None


def apply_for_each(path, function, base_path=''):
    if os.path.exists(path):
        with open(path,'r') as f:
            lines = f.readlines()
            for l in lines:
                l = l.split('#')[0]
                entry = (base_path+'/'+l).strip()
                if os.path.exists(entry) and os.path.abspath(entry)!=os.path.abspath(base_path):
                    function(entry)

def add_source(path):
    if os.path.basename(path) not in file_skip:
        current_lib["paths"].append(path)
    else:
        print('skip file  '+ path)

def parse_package(path):
    if path not in dir_skip and all([d not in path for d in dir_skip]):
        apply_for_each(path+'/vhdlsyn.txt', add_source, path)
    else:
        print('Skip package  '+path)

def parse_lib(lib_path):
    if lib_path not in lib_skip:
        global current_lib
        current_lib = {
            "name":os.path.basename(lib_path),
            "paths":[]
            }
        apply_for_each(lib_path+'/dirs.txt', parse_package, lib_path)
        output_file["Libraries"].append(current_lib)

def main():
    relpath = os.path.dirname(args.libs_file)
    apply_for_each(args.libs_file, parse_lib, relpath)
    work_lib["path"] = work
    output_file["Libraries"].append(work_lib)
    yaml.dump(output_file, open('vhdltool-config.yaml','w'), default_flow_style=False)


if __name__ == "__main__":
    main()
