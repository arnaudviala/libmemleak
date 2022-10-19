// Simple program to verify the functionality of `backtrace()` on your system.
//
// It depends on how the binaries are compiled.


/* Build with:
> $CC -g -O0 -U_FORTIFY_SOURCE \
 -funwind-tables -fasynchronous-unwind-tables -fno-omit-frame-pointer \
 check_backtrace.c -o check_backtrace.$($CC -dumpmachine) -lcrypto -lssl -ldl
 */


#include <stdio.h>
#include <string.h>
#define __USE_GNU
#include <dlfcn.h>
#include <execinfo.h>
#include <openssl/evp.h>

static void* (*volatile _libc_malloc)(size_t size) = NULL;
static __thread int inside_backtrace = 0;

void show_backtrace()
{
    #define BT_MAX 40
    void * backtrace_ptr[BT_MAX];
    size_t backtrace_size = backtrace(backtrace_ptr, BT_MAX);
    size_t p;
    printf("---- [sz=%d]\n", backtrace_size);
    for(p=0 ; p<backtrace_size ; p++)
    {
        printf("backtrace[%zu]=%p\n", p, backtrace_ptr[p]);
    }
    backtrace_symbols_fd(backtrace_ptr, backtrace_size, 1);
    printf("----\n");

}

void* malloc(size_t s)
{
    if (!_libc_malloc)
    {
        _libc_malloc = (void* (*)(size_t))dlsym(RTLD_NEXT, "malloc");
    }
    void * m = _libc_malloc(s);

    if (!inside_backtrace)
    {
        inside_backtrace = 1;
        show_backtrace();
        inside_backtrace = 0;
    }

    return m;
}

void header(const char * caption)
{
    printf("\n\n+-----------------------------\n");
    printf("| %s\n", caption);
    printf("+-----------------------------\n");
}
void footer()
{
    printf("+-----------------------------\n");
}

int main(int argc, char* argv)
{
    header("malloc()");
    char* ptr = (char*)malloc(1024);
    printf("malloc() returned %p\n", ptr);
    footer();

    header("strdup()");
    char* ptr2 = strdup("Hello world");
    printf("strdup() returned %p\n", ptr2);
    footer();

    header("EVP_PKEY_new()");
    EVP_PKEY* lost_key = EVP_PKEY_new();
    printf("EVP_PKEY_new() returned %p\n", lost_key);
    footer();

    header("show_backtrace()");
    show_backtrace();
    footer();

    return 0;
}
