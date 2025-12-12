#ifndef FLUTTER_PLUGIN_DESKTOP_WINDOW_PLUGIN_WINDOW_BORDERS_
#define FLUTTER_PLUGIN_DESKTOP_WINDOW_PLUGIN_WINDOW_BORDERS_

#include <windows.h>

#define WINDOW_BORDERS (WS_BORDER | WS_CAPTION | WS_DLGFRAME)

namespace Borders
{

    extern long borderStyle;

    const long mapWS_SM(const long *changes, long WS, long SM);

    bool hasBorders(HWND *hWnd);
    void setBorders(HWND *hWnd, bool borders, bool changeThickFrame = false);
    void toggleBorders(HWND *hWnd, bool changeThickframe = false);
}

#endif // FLUTTER_PLUGIN_DESKTOP_WINDOW_PLUGIN_WINDOW_BORDERS_