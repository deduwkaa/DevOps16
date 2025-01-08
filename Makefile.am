bin_PROGRAMS = devops16
DevOps16_SOURCES = main.cpp

DEB_INSTALL = debian/devops16.install

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = devops16.pc

dist_pkgdata_DATA = $(DEB_INSTALL)

EXTRA_DIST = debian/

MAINTAINER_MODE = 1
AUTOMAKE_OPTIONS = foreign