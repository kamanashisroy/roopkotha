#-------------------------------------------------
#
# Project created by QtCreator 2011-06-30T00:20:01
#
#-------------------------------------------------

QT       += gui

TARGET = qtguiproject
TEMPLATE = lib

include(.config.pro)

DEFINES += QTGUI_LIBRARY

SOURCES += src/ui/core/qt_graphics.cpp \
    src/ui/core/qt_platform.cpp \
    src/ui/core/qt_window.cpp \
    src/ui/core/qt_font.cpp

#HEADERS += inc/qt_config.h inc/qt_graphics.h inc/qt_window.h inc/qt_logger.h inc/qt_font.h
HEADERS += inc/qt_graphics.h inc/qt_window.h inc/qt_guicore.h inc/qt_font.h

INCLUDEPATH+=inc

LFLAGS = -static-libgcc
CXXFLAGS+=-ggdb3




