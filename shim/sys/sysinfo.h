#pragma once
#include <unistd.h>
static inline int get_nprocs(void) {
    long n = sysconf(_SC_NPROCESSORS_ONLN);
    return n > 0 ? (int) n : 1;
}
static inline int get_nprocs_conf(void) {
    long n = sysconf(_SC_NPROCESSORS_CONF);
    return n > 0 ? (int) n : get_nprocs();
}
