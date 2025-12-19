#include "borders.h"

namespace Borders
{
    long borderStyle = NULL;

    const long mapWS_SM(const long *changes, long WS, long SM)
    {
        return ((*changes & WS) > 0) * GetSystemMetrics(SM);
    }

    bool hasBorders(HWND *hWnd)
    {
        return (GetWindowLong(*hWnd, GWL_STYLE) & WINDOW_BORDERS) != 0;
    }

    void setBorders(HWND *hWnd, bool borders, bool changeThickFrame)
    {
        if (hasBorders(hWnd) == borders)
            return;

        RECT rect;
        GetWindowRect(*hWnd, &rect);

        long currentStyle = GetWindowLong(*hWnd, GWL_STYLE);
        if (borderStyle == NULL)
            borderStyle = currentStyle & (WINDOW_BORDERS | WS_THICKFRAME);

        const long lastStyle = currentStyle;

        if (borders)
            currentStyle |= borderStyle & (WINDOW_BORDERS | (changeThickFrame * WS_THICKFRAME));
        else
            currentStyle &= ~(WINDOW_BORDERS | (changeThickFrame * WS_THICKFRAME));

        SetWindowLong(*hWnd, GWL_STYLE, currentStyle);

        const long diff = lastStyle ^ currentStyle;

        const short op = 2 * borders - 1; // gets borders = 1, looses borders = -1

        const long xBorder =
            mapWS_SM(&diff, WS_THICKFRAME, SM_CXSIZEFRAME) +
            mapWS_SM(&diff, WS_BORDER, SM_CXBORDER) +
            mapWS_SM(&diff, WS_DLGFRAME, SM_CXDLGFRAME);
        const long yBorder =
            mapWS_SM(&diff, WS_THICKFRAME, SM_CYSIZEFRAME) +
            mapWS_SM(&diff, WS_BORDER, SM_CYBORDER) +
            mapWS_SM(&diff, WS_DLGFRAME, SM_CYDLGFRAME);

        const long caption = mapWS_SM(&diff, WS_CAPTION & ~WS_BORDER, SM_CYCAPTION);

        const long xPos = rect.left - (op * xBorder);
        const long yPos = rect.top - (op * yBorder) - (op * caption);
        const long width = rect.right - rect.left + (2 * op * xBorder);
        const long height = rect.bottom - rect.top + (2 * op * yBorder) + (op * caption);

        SetWindowPos(*hWnd, HWND_TOP, xPos, yPos, width, height, SWP_SHOWWINDOW);
    }

    void toggleBorders(HWND *hWnd, bool changeThickframe)
    {
        setBorders(hWnd, !hasBorders(hWnd), changeThickframe);
    }

}
