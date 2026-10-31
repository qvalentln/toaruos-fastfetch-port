#!/bin/bash
source "$(dirname "$(readlink -f "$0")")/toaru-env.sh"
cd /root/misaka/ports
rsync -a --delete --exclude build-toaru --exclude .git --exclude build.log --exclude configure.log fastfetch-toaru/ ff-build/
./gcc10-compat.sh ff-build
cd ff-build
if ! cmake -S . -B build-toaru -DCMAKE_TOOLCHAIN_FILE=/root/misaka/ports/toaru.cmake -DBUILD_FLASHFETCH=OFF -DENABLE_LTO=OFF > configure.log 2>&1; then
    echo "CONFIGURE FAILED:"
    grep -v "System is unknown\|Platform/ToaruOS" configure.log | grep -i -B2 -A6 "error" | head -30
    exit 1
fi
cmake --build build-toaru -j4 -- -k > build.log 2>&1
echo "errors: $(grep -c -i 'error' build.log)"
grep -i -E "error|undefined reference|multiple definition" build.log | sed -E 's|^/root/misaka/ports/ff-build/||' | sort -u | head -${1:-40}
if [ -f build-toaru/fastfetch ]; then file build-toaru/fastfetch; else echo "NO fastfetch BINARY"; fi
