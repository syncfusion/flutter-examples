#include "include/desktop_window/desktop_window_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>

#define DESKTOP_WINDOW_PLUGIN(obj)                                     \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), desktop_window_plugin_get_type(), \
                              DesktopWindowPlugin))

struct _DesktopWindowPlugin
{
  GObject parent_instance;
  GtkWidget *widget;
};

G_DEFINE_TYPE(DesktopWindowPlugin, desktop_window_plugin, g_object_get_type())

// Called when a method call is received from Flutter.
static void desktop_window_plugin_handle_method_call(
    DesktopWindowPlugin *self,
    FlMethodCall *method_call)
{
  g_autoptr(FlMethodResponse) response = nullptr;

  const gchar *method = fl_method_call_get_name(method_call);

  if (!gtk_widget_is_toplevel(self->widget))
  {
    response = FL_METHOD_RESPONSE(fl_method_error_response_new("MAINWINDOW_NOT_FOUND", "GtkWindow not found", fl_value_new_null()));
  }
  else if (strcmp(method, "getWindowSize") == 0)
  {
    gint width;
    gint height;

    gtk_window_get_size((GtkWindow *)self->widget, &width, &height);

    g_autoptr(FlValue) list = fl_value_new_list();
    fl_value_append_take(list, fl_value_new_float((float)width));
    fl_value_append_take(list, fl_value_new_float((float)height));

    response = FL_METHOD_RESPONSE(fl_method_success_response_new(list));
  }
  else if (strcmp(method, "setWindowSize") == 0)
  {
    const float width = fl_value_get_float(fl_value_lookup(fl_method_call_get_args(method_call), fl_value_new_string("width")));
    const float height = fl_value_get_float(fl_value_lookup(fl_method_call_get_args(method_call), fl_value_new_string("height")));

    gtk_window_resize((GtkWindow *)self->widget, (int)width, (int)height);

    response = FL_METHOD_RESPONSE(fl_method_success_response_new(fl_value_new_bool(true)));
  }
  else if (strcmp(method, "setMinWindowSize") == 0)
  {
    const float width = fl_value_get_float(fl_value_lookup(fl_method_call_get_args(method_call), fl_value_new_string("width")));
    const float height = fl_value_get_float(fl_value_lookup(fl_method_call_get_args(method_call), fl_value_new_string("height")));

    GdkGeometry geometry;
    geometry.min_height = (int)height;
    geometry.min_width = (int)width;
    gdk_window_set_geometry_hints(gtk_widget_get_window(self->widget), &geometry, GDK_HINT_MIN_SIZE);

    response = FL_METHOD_RESPONSE(fl_method_success_response_new(fl_value_new_bool(true)));
  }
  else if (strcmp(method, "setMaxWindowSize") == 0)
  {
    const float width = fl_value_get_float(fl_value_lookup(fl_method_call_get_args(method_call), fl_value_new_string("width")));
    const float height = fl_value_get_float(fl_value_lookup(fl_method_call_get_args(method_call), fl_value_new_string("height")));

    GdkGeometry geometry;
    geometry.max_height = ((int)height) == 0 ? INT_MAX : ((int)height);
    geometry.max_width = ((int)width) == 0 ? INT_MAX : ((int)width);
    gdk_window_set_geometry_hints(gtk_widget_get_window(self->widget), &geometry, GDK_HINT_MAX_SIZE);

    response = FL_METHOD_RESPONSE(fl_method_success_response_new(fl_value_new_bool(true)));
  }
  else if (strcmp(method, "resetMaxWindowSize") == 0)
  {
    GdkGeometry geometry;
    geometry.max_height = INT_MAX;
    geometry.max_width = INT_MAX;
    gdk_window_set_geometry_hints(gtk_widget_get_window(self->widget), &geometry, GDK_HINT_MAX_SIZE);

    response = FL_METHOD_RESPONSE(fl_method_success_response_new(fl_value_new_bool(true)));
  }
  else if (strcmp(method, "toggleFullScreen") == 0)
  {
    bool isFullscreen = (bool)(gdk_window_get_state(gtk_widget_get_window(self->widget)) & GDK_WINDOW_STATE_FULLSCREEN);
    if (!isFullscreen)
      gtk_window_fullscreen((GtkWindow *)self->widget);
    else
      gtk_window_unfullscreen((GtkWindow *)self->widget);

    response = FL_METHOD_RESPONSE(fl_method_success_response_new(fl_value_new_bool(true)));
  }
  else if (strcmp(method, "setFullScreen") == 0)
  {
    bool fullscreen = fl_value_get_bool(fl_value_lookup(fl_method_call_get_args(method_call), fl_value_new_string("fullscreen")));

    if (fullscreen)
      gtk_window_fullscreen((GtkWindow *)self->widget);
    else
      gtk_window_unfullscreen((GtkWindow *)self->widget);

    response = FL_METHOD_RESPONSE(fl_method_success_response_new(fl_value_new_bool(true)));
  }
  else if (strcmp(method, "getFullScreen") == 0)
  {
    bool isFullscreen = (bool)(gdk_window_get_state(gtk_widget_get_window(self->widget)) & GDK_WINDOW_STATE_FULLSCREEN);
    response = FL_METHOD_RESPONSE(fl_method_success_response_new(fl_value_new_bool(isFullscreen)));
  }
  else if (strcmp(method, "hasBorders") == 0)
  {
    bool isDecorated = (bool)gtk_window_get_decorated((GtkWindow *)self->widget);
    response = FL_METHOD_RESPONSE(fl_method_success_response_new(fl_value_new_bool(isDecorated)));
  }
  else if (strcmp(method, "setBorders") == 0)
  {
    bool decorated = fl_value_get_bool(fl_value_lookup(fl_method_call_get_args(method_call), fl_value_new_string("border")));
    gtk_window_set_decorated((GtkWindow *)self->widget, decorated);

    response = FL_METHOD_RESPONSE(fl_method_success_response_new(fl_value_new_bool(true)));
  }
  else if (strcmp(method, "toggleBorders") == 0)
  {
    bool isDecorated = (bool)gtk_window_get_decorated((GtkWindow *)self->widget);
    gtk_window_set_decorated((GtkWindow *)self->widget, !isDecorated);

    response = FL_METHOD_RESPONSE(fl_method_success_response_new(fl_value_new_bool(true)));
  } 
  else if (strcmp(method, "focus") == 0)
  {
    gtk_window_present((GtkWindow *) self->widget);
    response = FL_METHOD_RESPONSE(fl_method_success_response_new(fl_value_new_bool(true)));
  }
  else if(strcmp(method, "stayOnTop") == 0){
    bool stayOnTop = !fl_value_get_bool(fl_value_lookup(fl_method_call_get_args(method_call), fl_value_new_string("stayOnTop")));
    gdk_window_set_keep_above(gtk_widget_get_window(self->widget), stayOnTop);
    response = FL_METHOD_RESPONSE(fl_method_success_response_new(fl_value_new_bool(true)));
  }
  

  if (response == nullptr)
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());

  fl_method_call_respond(method_call, response, nullptr);
}

static void desktop_window_plugin_dispose(GObject *object)
{
  G_OBJECT_CLASS(desktop_window_plugin_parent_class)->dispose(object);
}

static void desktop_window_plugin_class_init(DesktopWindowPluginClass *klass)
{
  G_OBJECT_CLASS(klass)->dispose = desktop_window_plugin_dispose;
}

static void desktop_window_plugin_init(DesktopWindowPlugin *self) {}

static void method_call_cb(FlMethodChannel *channel, FlMethodCall *method_call,
                           gpointer user_data)
{
  DesktopWindowPlugin *plugin = DESKTOP_WINDOW_PLUGIN(user_data);
  desktop_window_plugin_handle_method_call(plugin, method_call);
}

void desktop_window_plugin_register_with_registrar(FlPluginRegistrar *registrar)
{

  GtkWidget *toplevel = gtk_widget_get_toplevel((GtkWidget *)fl_plugin_registrar_get_view(registrar));
  DesktopWindowPlugin *plugin = DESKTOP_WINDOW_PLUGIN(
      g_object_new(desktop_window_plugin_get_type(), nullptr));
  plugin->widget = toplevel;

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "desktop_window",
                            FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_object_unref(plugin);
}
