#include "method_call.h"
#include "borders.h"

namespace DesktopWindowMethodCall
{

    MethodCall::MethodCall(const flutter::MethodCall<flutter::EncodableValue> &Cmethod_call,
                           std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> Cresult): method_call(Cmethod_call)
    {
        result = std::move(Cresult);
    }

    void MethodCall::setFullscreen()
    {
        const auto *arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
        bool fullscreen = false;
        if (arguments)
        {
            auto fs_it = arguments->find(flutter::EncodableValue("fullscreen"));
            if (fs_it != arguments->end())
            {
                fullscreen = std::get<bool>(fs_it->second);
            }
        }
        HWND handle = GetActiveWindow();

        WINDOWPLACEMENT placement;

        GetWindowPlacement(handle, &placement);

        if (fullscreen)
        {
            placement.showCmd = SW_MAXIMIZE;
            SetWindowPlacement(handle, &placement);
        }
        else
        {
            placement.showCmd = SW_NORMAL;
            SetWindowPlacement(handle, &placement);
        }

        result->Success(flutter::EncodableValue(true));
    }

    void MethodCall::getFullscreen()
    {
        HWND handle = GetActiveWindow();

        WINDOWPLACEMENT placement;
        GetWindowPlacement(handle, &placement);

        result->Success(flutter::EncodableValue(placement.showCmd == SW_MAXIMIZE));
    }

    void MethodCall::toggleFullscreen()
    {
        HWND handle = GetActiveWindow();

        WINDOWPLACEMENT placement;
        GetWindowPlacement(handle, &placement);

        if (placement.showCmd == SW_MAXIMIZE)
        {
            placement.showCmd = SW_NORMAL;
            SetWindowPlacement(handle, &placement);
        }
        else
        {
            placement.showCmd = SW_MAXIMIZE;
            SetWindowPlacement(handle, &placement);
        }
        result->Success(flutter::EncodableValue(true));
    }

    void MethodCall::setBorders()
    {
        const auto *arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
        bool border = false;
        if (arguments)
        {
            auto fs_it = arguments->find(flutter::EncodableValue("border"));
            if (fs_it != arguments->end())
            {
                border = std::get<bool>(fs_it->second);
            }
        }

        HWND hWnd = GetActiveWindow();

        Borders::setBorders(&hWnd, border, true);

        result->Success(flutter::EncodableValue(true));
    }

    void MethodCall::hasBorders()
    {
        HWND hWnd = GetActiveWindow();
        result->Success(flutter::EncodableValue(Borders::hasBorders(&hWnd)));
    }

    void MethodCall::toggleBorders()
    {
        HWND hWnd = GetActiveWindow();
        Borders::toggleBorders(&hWnd, true);

        result->Success(flutter::EncodableValue(true));
    }

    void MethodCall::stayOnTop()
    {
        const auto *arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
        bool stayOnTop = false;
        if (arguments)
        {
            auto fs_it = arguments->find(flutter::EncodableValue("stayOnTop"));
            if (fs_it != arguments->end())
            {
                stayOnTop = std::get<bool>(fs_it->second);
            }
        }

        HWND hWnd = GetActiveWindow();

        RECT rect;
        GetWindowRect(hWnd, &rect);
        SetWindowPos(hWnd, stayOnTop? HWND_TOPMOST: HWND_NOTOPMOST, rect.left, rect.top, rect.right-rect.left, rect.bottom -rect.top, SWP_SHOWWINDOW);
        
        result->Success(flutter::EncodableValue(true));
    }

  
    void MethodCall::focus()
    {
        HWND hWnd = GetActiveWindow();
        SetFocus(hWnd);

        result->Success(flutter::EncodableValue(true));
    }

    void MethodCall::getWindowSize() {
        HWND hwnd = GetActiveWindow();
        if (!hwnd) {
            result->Error("WINDOW_ERROR", "Unable to get active window.");
            return;
        }

        RECT rect;
        GetWindowRect(hwnd, &rect);

        LONG lWidth = rect.right - rect.left;
        LONG lHeight = rect.bottom - rect.top;

        double width = lWidth * 1.0f;
        double height = lHeight * 1.0f;

        result->Success(flutter::EncodableValue(flutter::EncodableList{flutter::EncodableValue(width), flutter::EncodableValue(height)}));
    }

    void MethodCall::setWindowSize() {
        double width = 0;
        double height = 0;
        const auto *arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
        if (arguments)
        {
        auto width_it = arguments->find(flutter::EncodableValue("width"));
        if (width_it != arguments->end())
        {
            width = std::get<double>(width_it->second);
        }
        auto height_it = arguments->find(flutter::EncodableValue("height"));
        if (height_it != arguments->end())
        {
            height = std::get<double>(height_it->second);
        }
        }
        if (width == 0 || height == 0)
        {
        result->Error("argument_error", "width or height not provided");
        return;
        }

        HWND handle = GetActiveWindow();

        int iWidth = int(width + 0.5);
        int iHeight = int(height + 0.5);

        SetWindowPos(handle, HWND_TOP, 0, 0, iWidth, iHeight, SWP_NOMOVE);

        result->Success(flutter::EncodableValue(true));
    }

    void MethodCall::resetMaxWindowSize(int &maxWidth, int &maxHeight)
    {
        maxWidth = 0;
        maxHeight = 0;

        result->Success(flutter::EncodableValue(true));
    }

    void MethodCall::setMinWindowSize(int &minWidth, int &minHeight)
    {
        double width = 0;
        double height = 0;
        const auto *arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
        if (arguments)
        {
        auto width_it = arguments->find(flutter::EncodableValue("width"));
        if (width_it != arguments->end())
        {
            width = std::get<double>(width_it->second);
        }
        auto height_it = arguments->find(flutter::EncodableValue("height"));
        if (height_it != arguments->end())
        {
            height = std::get<double>(height_it->second);
        }
        }
        if (width == 0 || height == 0)
        {
        result->Error("argument_error", "width or height not provided");
        return;
        }

        minWidth = int(width + 0.5);
        minHeight = int(height + 0.5);

        result->Success(flutter::EncodableValue(true));
    }

    void MethodCall::setMaxWindowSize(int &maxWidth, int &maxHeight)
    {
        double width = 0;
        double height = 0;
        const auto *arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
        if (arguments)
        {
        auto width_it = arguments->find(flutter::EncodableValue("width"));
        if (width_it != arguments->end())
        {
            width = std::get<double>(width_it->second);
        }
        auto height_it = arguments->find(flutter::EncodableValue("height"));
        if (height_it != arguments->end())
        {
            height = std::get<double>(height_it->second);
        }
        }
        if (width == 0 || height == 0)
        {
        result->Error("argument_error", "width or height not provided");
        return;
        }

        maxWidth = int(width + 0.5);
        maxHeight = int(height + 0.5);

        result->Success(flutter::EncodableValue(true));
    }

}
