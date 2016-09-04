AC_INIT([gschem3],[0.0],[http://github.com/ehennes775/gschem3/issues],[gschem3],[http://github.com/ehennes775/gschem3])
AC_PREREQ([2.64])

AC_CONFIG_HEADERS([config.h])
AM_INIT_AUTOMAKE([foreign])
AC_PROG_CC
AC_PROG_RANLIB
AM_PROG_VALAC([0.27.0])

GLIB_GSETTINGS

AC_CONFIG_FILES([
    Makefile
    src/Makefile
    tests/Makefile
    ])

PKG_CHECK_MODULES([DEPS], [
    gee-0.8 >= 0.18
    glib-2.0 >= 2.40
    gtk+-3.0 >= 3.10
    libgeda >= 0.26
    ])

AC_OUTPUT

