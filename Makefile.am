# Визначаємо основний продукт
bin_PROGRAMS = DevOps16
DevOps16_SOURCES = main.cpp

# Вказуємо інсталяційний файл для Debian пакету
DEB_INSTALL = debian/DevOps16.install

# Підготовка до створення пакету
pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = DevOps16.pc

# Додавання правил для створення пакету Debian
# Указуємо, що потрібно додати ці файли до пакету
dist_pkgdata_DATA = $(DEB_INSTALL)

# Вказуємо директиву для побудови Debian пакету
EXTRA_DIST = debian/

# Підключаємо стандартні інструменти для побудови пакету
MAINTAINER_MODE = 1
AUTOMAKE_OPTIONS = foreign