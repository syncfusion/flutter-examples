#include "include/desktop_window/desktop_window_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <map>
#include <memory>
#include <sstream>

namespace {

LRESULT CALLBACK MyWndProc(HWND hWnd,UINT iMessage,WPARAM wParam,LPARAM lParam);
WNDPROC oldProc;

int maxWidth = 0;
int maxHeight = 0;
int minWidth = 0;
int minHeight = 0;

class DesktopWindowPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  DesktopWindowPlugin();

  virtual ~DesktopWindowPlugin();

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

// static
void DesktopWindowPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "desktop_window",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<DesktopWindowPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));

  HWND handle = GetActiveWindow();
  oldProc = reinterpret_cast<WNDPROC>(GetWindowLongPtr(handle, GWLP_WNDPROC));
  SetWindowLongPtr(handle, GWLP_WNDPROC, (LONG_PTR)MyWndProc);
  
}

DesktopWindowPlugin::DesktopWindowPlugin() {}

DesktopWindowPlugin::~DesktopWindowPlugin() {}

void DesktopWindowPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  // Replace "getPlatformVersion" check with your plugin's method.
  // See:
  // https://github.com/flutter/engine/tree/master/shell/platform/common/cpp/client_wrapper/include/flutter
  // and
  // https://github.com/flutter/engine/tree/master/shell/platform/glfw/client_wrapper/include/flutter
  // for the relevant Flutter APIs.
  if (method_call.method_name().compare("getPlatformVersion") == 0) {
    std::ostringstream version_stream;
    version_stream << "Windows ";
    if (IsWindows10OrGreater()) {
      version_stream << "10+";
    } else if (IsWindows8OrGreater()) {
      version_stream << "8";
    } else if (IsWindows7OrGreater()) {
      version_stream << "7";
    }
    result->Success(flutter::EncodableValue(version_stream.str()));
    
  } else if (method_call.method_name().compare("getWindowSize") == 0) {
    HWND handle = GetActiveWindow();
    RECT rect;

    GetWindowRect(handle, &rect);
    LONG lWidth = rect.right - rect.left;
    LONG lHeight = rect.bottom - rect.top;

    double width = lWidth * 1.0f;
    double height = lHeight * 1.0f;
    result->Success(flutter::EncodableValue(flutter::EncodableList{flutter::EncodableValue(width), flutter::EncodableValue(height)}));

  } else if (method_call.method_name().compare("setWindowSize") == 0) {
    double width = 0;
    double height = 0;
    const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
    if (arguments) {
      auto width_it = arguments->find(flutter::EncodableValue("width"));
      if (width_it != arguments->end()) {
        width = std::get<double>(width_it->second);
      }    
      auto height_it = arguments->find(flutter::EncodableValue("height"));
      if (height_it != arguments->end()) {
        height = std::get<double>(height_it->second);
      }
    }
    if (width == 0 || height == 0) {
      result->Error("argument_error", "width or height not provided");
      return;
    }

    HWND handle = GetActiveWindow();

    int iWidth = int(width+0.5);
    int iHeight = int(height+0.5);

    SetWindowPos(handle, HWND_TOP, 0, 0, iWidth, iHeight, SWP_NOMOVE);

    result->Success(flutter::EncodableValue(true));

  } else if (method_call.method_name().compare("setFullScreen") == 0) {
    const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
    bool fullscreen = false;
    if (arguments) {
      auto fs_it = arguments->find(flutter::EncodableValue("fullscreen"));
      if (fs_it != arguments->end()) {
        fullscreen = std::get<bool>(fs_it->second);
      }   
    } 
    HWND handle = GetActiveWindow();

    WINDOWPLACEMENT placement;

    GetWindowPlacement(handle, &placement);

    if (fullscreen) {
      placement.showCmd = SW_MAXIMIZE;
      SetWindowPlacement(handle, &placement);
    } else {
      placement.showCmd = SW_NORMAL;
      SetWindowPlacement(handle, &placement);
    }
    result->Success(flutter::EncodableValue(true));

  } else if (method_call.method_name().compare("getFullScreen") == 0) {
    HWND handle = GetActiveWindow();

    WINDOWPLACEMENT placement;
    GetWindowPlacement(handle, &placement);

    if (placement.showCmd == SW_MAXIMIZE) {
      result->Success(flutter::EncodableValue(true));
    } else {
      result->Success(flutter::EncodableValue(false));
    }

  } else if (method_call.method_name().compare("toggleFullScreen") == 0) {
    HWND handle = GetActiveWindow();

    WINDOWPLACEMENT placement;
    GetWindowPlacement(handle, &placement);

    if (placement.showCmd == SW_MAXIMIZE) {
      placement.showCmd = SW_NORMAL;
      SetWindowPlacement(handle, &placement);
    } else {
      placement.showCmd = SW_MAXIMIZE;
      SetWindowPlacement(handle, &placement);
    }
    result->Success(flutter::EncodableValue(true));

  } else if (method_call.method_name().compare("resetMaxWindowSize") == 0) {

    maxWidth = 0;
    maxHeight = 0;

    result->Success(flutter::EncodableValue(true));

  } else if (method_call.method_name().compare("setMinWindowSize") == 0) {
    double width = 0;
    double height = 0;
    const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
    if (arguments) {
      auto width_it = arguments->find(flutter::EncodableValue("width"));
      if (width_it != arguments->end()) {
        width = std::get<double>(width_it->second);
      }    
      auto height_it = arguments->find(flutter::EncodableValue("height"));
      if (height_it != arguments->end()) {
        height = std::get<double>(height_it->second);
      }
    }
    if (width == 0 || height == 0) {
      result->Error("argument_error", "width or height not provided");
      return;
    }

    minWidth = int(width+0.5);
    minHeight = int(height+0.5);

    result->Success(flutter::EncodableValue(true));

  } else if (method_call.method_name().compare("setMaxWindowSize") == 0) {
    double width = 0;
    double height = 0;
    const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
    if (arguments) {
      auto width_it = arguments->find(flutter::EncodableValue("width"));
      if (width_it != arguments->end()) {
        width = std::get<double>(width_it->second);
      }    
      auto height_it = arguments->find(flutter::EncodableValue("height"));
      if (height_it != arguments->end()) {
        height = std::get<double>(height_it->second);
      }
    }
    if (width == 0 || height == 0) {
      result->Error("argument_error", "width or height not provided");
      return;
    }

    maxWidth = int(width+0.5);
    maxHeight = int(height+0.5);

    result->Success(flutter::EncodableValue(true));

  } else {
    result->NotImplemented();
  }
}

LRESULT CALLBACK MyWndProc(HWND hWnd,UINT iMessage,WPARAM wParam,LPARAM lParam) {
  if(iMessage == WM_GETMINMAXINFO) {
    // OutputDebugString(L"WM_GETMINMAXINFO called");

    bool changed = false;

    if (maxWidth != 0 && maxHeight != 0) {
      ((MINMAXINFO *)lParam)->ptMaxTrackSize.x = maxWidth;
      ((MINMAXINFO *)lParam)->ptMaxTrackSize.y = maxHeight;
      changed = true;
    }
    if (minWidth != 0 && minHeight != 0) {
      ((MINMAXINFO *)lParam)->ptMinTrackSize.x = minWidth;
      ((MINMAXINFO *)lParam)->ptMinTrackSize.y = minHeight;
      changed = true;
    }
    if (changed) {
      return FALSE;
    }
  }

  return oldProc(hWnd, iMessage, wParam, lParam);
}

}  // namespace


void DesktopWindowPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  DesktopWindowPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}