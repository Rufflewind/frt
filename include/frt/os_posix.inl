#include <signal.h>
#include <sys/types.h>

#ifndef RF_OFF_MAX
/** Maximum value of the signed integer type `rf_off`. */
# define RF_OFF_MAX ((off_t)1 << (CHAR_BIT * sizeof(rf_off) - 1))
/* WARNING: the above expression gives only a guess */
#endif

#ifndef RF_OFF_MIN
/** Minimum value of the signed integer type `rf_off`. */
# define RF_OFF_MIN (-RF_OFF_MAX - ((off_t)1 & (off_t)-1 && \
                                    ((off_t)3 & (off_t)-1) != (off_t)1))
#endif

typedef off_t rf_off;

typedef int rf_fd;

typedef pid_t rf_pid;

struct rf_sigset { sigset_t value; };
