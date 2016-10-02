#!/bin/bash

cd "$(pwd)/src"

rm ../netherknight.love
zip -r9 ../netherknight.love * -x test.*

cd ..
