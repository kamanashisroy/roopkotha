#ifndef QT_WINDOW_H
#define QT_WINDOW_H

#include "core/config.h"
#include "core/decorator.h"
#include "core/txt.h"

#include "qt_graphics.h"
#include "shotodol_gui.h"

C_CAPSULE_START
#include "shotodol_watchdog.h"
#define watchdog_log_string(x) aroop_cl_shotodol_shotodol_watchdog_logString(__FILE__, __LINE__, 10 , x)
int qt_process_mouse_event_helper(int flags, int key_code, int x, int y);
C_CAPSULE_END

#ifdef __cplusplus
#include <QPainter>
#include <QColor>
#include <QGraphicsView>
#include <QPixmap>
#include <QVariant>
#include <QMouseEvent>
class QTRoopkothaWindow: public QWidget {
Q_OBJECT
public:
  QTRoopkothaWindow(QWidget *parent = 0 ):QWidget( parent ) {
    QSizePolicy policy( QSizePolicy::Preferred, QSizePolicy::Preferred );
    policy.setHeightForWidth( true );
    setSizePolicy( policy );
    page = NULL;
  }
  ~QTRoopkothaWindow() {
  }
public:
  void setPage(QPixmap*aPage) {
	  page = aPage;
  }
#if 0
public: // implements QWidget method
  int heightForWidth(int width) const {
    return width;
  }
  QSize sizeHint() const {
    return QSize( 100, 100 );
  }
  QSize minimumSizeHint () const {
      return QSize( 100, 100 );
  }

public  Q_SLOTS: // implements QWidget method
  void 	setVisible ( bool ) {
      return;
  }

protected:
    // Event handlers
    void mousePressEvent(QMouseEvent *) {
    }
    void mouseReleaseEvent(QMouseEvent *) {}
    void mouseDoubleClickEvent(QMouseEvent *) {}
    void mouseMoveEvent(QMouseEvent *){}
#ifndef QT_NO_WHEELEVENT
    void wheelEvent(QWheelEvent *){}
#endif
    void keyPressEvent(QKeyEvent *){}
    void keyReleaseEvent(QKeyEvent *){}
    void focusInEvent(QFocusEvent *){}
    void focusOutEvent(QFocusEvent *){}
    void enterEvent(QEvent *){}
    void leaveEvent(QEvent *){}
    void paintEvent(QPaintEvent *){
		//QPainter p( this );
		page->fill(this, 0, 0);
		//p.drawImage(0, 0, *page);
    }
    void moveEvent(QMoveEvent *){}
    void resizeEvent(QResizeEvent *){}
    void closeEvent(QCloseEvent *){}
#ifndef QT_NO_CONTEXTMENU
    void contextMenuEvent(QContextMenuEvent *){}
#endif
#ifndef QT_NO_TABLETEVENT
    void tabletEvent(QTabletEvent *){}
#endif
#ifndef QT_NO_ACTION
    void actionEvent(QActionEvent *){}
#endif

#ifndef QT_NO_DRAGANDDROP
    void dragEnterEvent(QDragEnterEvent *){}
    void dragMoveEvent(QDragMoveEvent *){}
    void dragLeaveEvent(QDragLeaveEvent *){}
    void dropEvent(QDropEvent *){}
#endif

    void showEvent(QShowEvent *){}
    void hideEvent(QHideEvent *){}

#if defined(Q_WS_MAC)
    bool macEvent(EventHandlerCallRef, EventRef){return false;}
#endif
#if defined(Q_WS_WIN)
    bool winEvent(MSG *message, long *result){return false;}
#endif
#if defined(Q_WS_X11)
    bool x11Event(XEvent *){return false;}
#endif
#if defined(Q_WS_QWS)
    bool qwsEvent(QWSEvent *){return false;}
#endif

    // Misc. protected functions
    void changeEvent(QEvent *){}

    void inputMethodEvent(QInputMethodEvent *){}
public:
    QVariant inputMethodQuery(Qt::InputMethodQuery) const {
      return QVariant();
    }

protected:
    bool focusNextPrevChild(bool ) {
        return false;
    }
protected:
    void styleChange(QStyle&) {} // compat
    void enabledChange(bool) {}  // compat
    void paletteChange(const QPalette &) {}  // compat
    void fontChange(const QFont &) {} // compat
    void windowActivationChange(bool) {} // compat
    void languageChange() {} // compat
#endif
protected:
    void paintEvent(QPaintEvent *){
        if(page) {
            QPainter p( this );
            p.drawPixmap(0, 0, 200, 400, *page);
            //page->fill(this, 0, 0);
            //watchdog_log_string("Filling with pixmap\n");
        }
        //p.drawImage(0, 0, *page);
    }
    void keyPressEvent(QKeyEvent *event){
    	//watchdog_log_string("Key event\n");
        QString text = event->text();
        int x = 0;
        int key = 0;
        switch(event->key()) {
        case Qt::Key_Up:
            x = ENUM_ROOPKOTHA_ACTION_INPUT_KEY_KEY_UP;
        break;
        case Qt::Key_Down:
            x = ENUM_ROOPKOTHA_ACTION_INPUT_KEY_KEY_DOWN;
        break;
        case Qt::Key_Right:
            x = ENUM_ROOPKOTHA_ACTION_INPUT_KEY_KEY_RIGHT;
        break;
        case Qt::Key_Left:
            x = ENUM_ROOPKOTHA_ACTION_INPUT_KEY_KEY_LEFT;
        break;
        case Qt::Key_Enter:
            x = ENUM_ROOPKOTHA_ACTION_INPUT_KEY_KEY_ENTER;
        break;
        case Qt::Key_Return:
            x = ENUM_ROOPKOTHA_ACTION_INPUT_KEY_KEY_RETURN;
        break;
        case Qt::Key_F1:
            x = ENUM_ROOPKOTHA_ACTION_INPUT_KEY_KEY_F1;
        break;
        case Qt::Key_F2:
            x = ENUM_ROOPKOTHA_ACTION_INPUT_KEY_KEY_F2;
        break;
        case Qt::Key_Escape:
            x = ENUM_ROOPKOTHA_ACTION_INPUT_KEY_KEY_ESCAPE;
        break;
        }
        if(text.length()) {
            key = text[0].toAscii();
        }
        qt_process_mouse_event_helper(ENUM_ROOPKOTHA_ACTION_INPUT_KEYBOARD_EVENT, key, x, 0);
    }
    void mouseReleaseEvent(QMouseEvent *event) {
    	if (event->button() == Qt::LeftButton) {
    		printf("Mouse event\n");
            qt_process_mouse_event_helper(ENUM_ROOPKOTHA_ACTION_INPUT_SCREEN_EVENT, ENUM_ROOPKOTHA_ACTION_INPUT_KEY_KEY_ENTER, event->x(), event->y());
		}
    }
public:
    QPixmap*page;
};
#else
typedef void QTRoopkothaWindow;
#endif

C_CAPSULE_START

typedef int (*qt_window_handle_event_cb_t)(void*cb_data, int flags, int key_code, int x, int y);
typedef struct {
	void*aroop_closure_data;
	qt_window_handle_event_cb_t aroop_cb;
} qt_window_handle_event_t;

int qt_impl_window_set_event_handler(QTRoopkothaWindow*UNUSED_VAR(qw), qt_window_handle_event_t handler);
void qt_impl_window_show(QTRoopkothaWindow*qwin);
void qt_impl_window_paint_end(QTRoopkothaWindow*qw, QTRoopkothaGraphics*qtg);
QTRoopkothaWindow*qt_impl_window_create();
void qt_impl_window_destroy(QTRoopkothaWindow*qw);
C_CAPSULE_END

#endif // QT_WINDOW_H
