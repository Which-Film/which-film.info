#! /bin/sh
echo "Deleting the build/ directory ..."
rm -rf build
pub build
surge -d which-film.info -p build/web
