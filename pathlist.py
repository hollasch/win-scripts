#!python3
#---------------------------------------------------------------------------------------------------
# pathlist
#
# Prints out an ordered list of all directories in the current search path environment variable.
# Duplicate entries and non-existent directories are flagged.
#---------------------------------------------------------------------------------------------------

import os

foundDuplicates = False
foundNonexistent = False

pathVar = os.environ['PATH']
pathList = pathVar.split(';')

for n, path in enumerate(pathList):
    if path == "":
        continue

    # Check for duplicate entries.
    if pathList.count(path) > 1:
        dupMarker = "+"
        foundDuplicates = True
    else:
        dupMarker = " "

    # Check for non-existent paths.
    if not os.path.exists(path):
        existMarker = "!"
        foundNonexistent = True
    else:
        existMarker = " "

    print ("{:2d}: {}{}{}" .format(n, existMarker, dupMarker, path))

if foundDuplicates or foundNonexistent:
    print()

    if foundDuplicates:
        print ("+ Duplicate entries")

    if foundNonexistent:
        print ("! Non-existent directories")
