#!/bin/bash
# usage: gcc10-compat.sh <fastfetch-source-dir>
# Rewrites C23 constructs that GCC 10.3 can't parse. For local ToaruOS builds only.
set -e
cd "$1"
# enum Name : type {  ->  enum Name {
find src -name '*.[ch]' | xargs sed -E -i \
  's/\benum([[:space:]]+[A-Za-z_0-9]+)?[[:space:]]*:[[:space:]]*[A-Za-z_0-9 ]+\{/enum\1 {/'
# bypass the C23 compiler gate (our shims and sed passes stand in for it)
sed -i 's/if(NOT COMPILER_SUPPORTS_C23)/if(NOT COMPILER_SUPPORTS_C23 AND NOT ToaruOS)/' CMakeLists.txt
# GCC 10 rejects a variadic function with no named parameter
cat > src/common/unused.h <<'EOT'
#pragma once
#define FF_UNUSED(...) (void)(__VA_ARGS__);
EOT
sed -i 's/ffLibraryIterateDynamicLibs(FFLibraryIterateCallback, void\*)/ffLibraryIterateDynamicLibs(FFLibraryIterateCallback cb, void* data)/' src/common/impl/library.c
sed -i 's/ffSettingsGetSQLite3Int(const char\*, const char\*)/ffSettingsGetSQLite3Int(const char* a, const char* b)/' src/common/impl/settings.c
sed -i 's/ffSettingsGetSQLite3String(const char\*, const char\*, FFstrbuf\*)/ffSettingsGetSQLite3String(const char* a, const char* b, FFstrbuf* c)/' src/common/impl/settings.c
# ToaruOS dirent has no d_type: pretend it is always DT_UNKNOWN (code falls back to stat())
find src \( -name '*.c' -o -name '*.cpp' \) | xargs sed -E -i 's/\b[A-Za-z_][A-Za-z_0-9]*->d_type\b/DT_UNKNOWN/g'
