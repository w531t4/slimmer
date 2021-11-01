# Tracing
To use tracing, ensure '--enable-tracing' is passed at compile time, and a re-compile is performed after a ```make clean```

The following code chunks should be pasted into main.cpp

in include section of main.cpp
```
#include <unicode/brkiter.h>
#include <unicode/errorcode.h>
#include <unicode/localpointer.h>
#include <unicode/utrace.h>
```

Anywhere within main.cpp
```
static void U_CALLCONV traceData(
        const void *context,
        int32_t fnNumber,
        int32_t level,
        const char *fmt,
        va_list args) {
    char        buf[1000];
    const char *fnName;

    fnName = utrace_functionName(fnNumber);
    utrace_vformat(buf, sizeof(buf), 0, fmt, args);
    std::cout << fnName << " " << buf << std::endl;
}
```

In body of main()
```
    icu::ErrorCode status;
    const void* context = nullptr;
    utrace_setFunctions(context, nullptr, nullptr, traceData);
    utrace_setLevel(UTRACE_VERBOSE);
    icu::LocalPointer<icu::BreakIterator> brkitr(
        icu::BreakIterator::createWordInstance("us-EN", status));

# Outcome
```
Oct 31 15:48:41 raspberrypi slimmer[10225]: ucnv_close close converter ISO-8859-1 at 010896d0, isCopyLocal=00
Oct 31 15:48:41 raspberrypi slimmer[10225]: ucnv_open open converter ISO-8859-1
Oct 31 15:48:41 raspberrypi slimmer[10225]: ucnv_close close converter ISO-8859-1 at 010896d0, isCopyLocal=00
Oct 31 15:48:42 raspberrypi slimmer[10225]: ucnv_open open converter ISO-8859-1
```
