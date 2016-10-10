#!/bin/bash

# NOTE: only run this when your bash/shell section is on the project's root folder

cd "$(pwd)"/src

rm ../netherknight.love
zip -r9 ../netherknight.love * -x test*

cd ..

