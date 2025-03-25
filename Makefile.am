# Define the executable and its sources
bin_PROGRAMS = devops16
devops16_SOURCES = main.cpp

# Files for installation and packaging
DEB_INSTALL = debian/devops16.install

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = devops16.pc
dist_pkgdata_DATA = $(DEB_INSTALL)

# Additional files to distribute
EXTRA_DIST = debian/

# Automake options
AUTOMAKE_OPTIONS = foreign
