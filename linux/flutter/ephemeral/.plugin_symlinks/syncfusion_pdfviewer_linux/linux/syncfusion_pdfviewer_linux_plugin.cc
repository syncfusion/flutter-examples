#include "include/syncfusion_pdfviewer_linux/syncfusion_pdfviewer_linux_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <vector>
#include <cstring>
#include <glib.h>

#include "pdfviewer.h"
#include "fpdfview.h"

#define SYNCFUSION_PDFVIEWER_LINUX_PLUGIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), syncfusion_pdfviewer_linux_plugin_get_type(), SyncfusionPdfviewerLinuxPlugin))

struct _SyncfusionPdfviewerLinuxPlugin
{
  GObject parent_instance;
};

G_DEFINE_TYPE(SyncfusionPdfviewerLinuxPlugin, syncfusion_pdfviewer_linux_plugin, g_object_get_type())

// Forward declarations for method handlers
FlMethodResponse *InitializePDFRenderer(FlMethodCall *method_call);
FlMethodResponse *GetPagesHeight(FlMethodCall *method_call);
FlMethodResponse *GetPagesWidth(FlMethodCall *method_call);
FlMethodResponse *GetPdfPageImage(FlMethodCall *method_call);
FlMethodResponse *GetPdfPageTileImage(FlMethodCall *method_call);
FlMethodResponse *CloseDocument(FlMethodCall *method_call);

// Helper function for creating error responses
static FlMethodResponse *create_error_response(const gchar *code, const gchar *message)
{
  return FL_METHOD_RESPONSE(fl_method_error_response_new(code, message, nullptr));
}

// Method call handler to map method names to appropriate functions
static void syncfusion_pdfviewer_linux_plugin_handle_method_call(
    SyncfusionPdfviewerLinuxPlugin *self,
    FlMethodCall *method_call)
{
  g_autoptr(FlMethodResponse) response = nullptr;
  const gchar *method = fl_method_call_get_name(method_call);

  if (g_strcmp0(method, "initializePdfRenderer") == 0)
  {
    response = InitializePDFRenderer(method_call);
  }
  else if (g_strcmp0(method, "getPagesHeight") == 0)
  {
    response = GetPagesHeight(method_call);
  }
  else if (g_strcmp0(method, "getPagesWidth") == 0)
  {
    response = GetPagesWidth(method_call);
  }
  else if (g_strcmp0(method, "getPage") == 0)
  {
    response = GetPdfPageImage(method_call);
  }
  else if (g_strcmp0(method, "getTileImage") == 0)
  {
    response = GetPdfPageTileImage(method_call);
  }
  else if (g_strcmp0(method, "closeDocument") == 0)
  {
    response = CloseDocument(method_call);
  }
  else
  {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  fl_method_call_respond(method_call, response, nullptr);
}

// Initialization and disposal methods
static void syncfusion_pdfviewer_linux_plugin_dispose(GObject *object)
{
  G_OBJECT_CLASS(syncfusion_pdfviewer_linux_plugin_parent_class)->dispose(object);
}

static void syncfusion_pdfviewer_linux_plugin_class_init(SyncfusionPdfviewerLinuxPluginClass *klass)
{
  G_OBJECT_CLASS(klass)->dispose = syncfusion_pdfviewer_linux_plugin_dispose;
}

static void syncfusion_pdfviewer_linux_plugin_init(SyncfusionPdfviewerLinuxPlugin *self) {}

static void method_call_cb(FlMethodChannel *channel, FlMethodCall *method_call, gpointer user_data)
{
  SyncfusionPdfviewerLinuxPlugin *plugin = SYNCFUSION_PDFVIEWER_LINUX_PLUGIN(user_data);
  syncfusion_pdfviewer_linux_plugin_handle_method_call(plugin, method_call);
}

// Plugin registration
void syncfusion_pdfviewer_linux_plugin_register_with_registrar(FlPluginRegistrar *registrar)
{
  SyncfusionPdfviewerLinuxPlugin *plugin = SYNCFUSION_PDFVIEWER_LINUX_PLUGIN(
      g_object_new(syncfusion_pdfviewer_linux_plugin_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "syncfusion_flutter_pdfviewer",
                            FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_object_unref(plugin);
}

// Function to initialize PDF renderer
FlMethodResponse *InitializePDFRenderer(FlMethodCall *method_call)
{
  FlValue *args = fl_method_call_get_args(method_call);
  if (args != nullptr && fl_value_get_type(args) == FL_VALUE_TYPE_MAP)
  {
    FlValue *idKey = fl_value_lookup_string(args, "documentID");
    const gchar *documentID = idKey ? fl_value_get_string(idKey) : "";

    FlValue *documentBytesKey = fl_value_lookup_string(args, "documentBytes");
    const uint8_t *bytesValue = documentBytesKey ? fl_value_get_uint8_list(documentBytesKey) : nullptr;
    gsize size = fl_value_get_length(documentBytesKey);

    FlValue *passwordKey = fl_value_lookup_string(args, "password");
    const gchar *password = "";
    if (passwordKey && fl_value_get_type(passwordKey) == FL_VALUE_TYPE_STRING) {
      password = fl_value_get_string(passwordKey);
    }

    if (documentID && bytesValue != nullptr && size > 0)
    {
      g_autoptr(GBytes) data = g_bytes_new(bytesValue, size);
      auto document = pdfviewer::InitializePdfRenderer(data, password, documentID);
      if (document)
      {
        int pageCount = FPDF_GetPageCount(document->pdfDocument());
        FlValue *result = fl_value_new_string(g_strdup_printf("%d", pageCount));
        return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
      }
    }
  }
  return create_error_response("InvalidArguments", "Initialization failed");
}

// Function to get pages' heights
FlMethodResponse *GetPagesHeight(FlMethodCall *method_call)
{
  FlValue *args = fl_method_call_get_args(method_call);
  const gchar *documentID = fl_value_get_string(args) ?: "";

  if (!documentID)
    return create_error_response("InvalidArguments", "Document ID not provided");

  auto documentPtr = pdfviewer::GetPdfDocument(documentID);
  if (!documentPtr)
    return create_error_response("DocumentNotFound", "Document not found");

  int pageCount = FPDF_GetPageCount(documentPtr->pdfDocument());
  FlValue *flPageHeights = fl_value_new_list();

  for (int i = 0; i < pageCount; ++i)
  {
    FPDF_PAGE page = FPDF_LoadPage(documentPtr->pdfDocument(), i);
    if (page)
    {
      double height = FPDF_GetPageHeightF(page);
      fl_value_append_take(flPageHeights, fl_value_new_float(height));
      FPDF_ClosePage(page);
    }
  }
  return FL_METHOD_RESPONSE(fl_method_success_response_new(flPageHeights));
}

// Function to get pages' widths
FlMethodResponse *GetPagesWidth(FlMethodCall *method_call)
{
  FlValue *args = fl_method_call_get_args(method_call);
  const gchar *documentID = fl_value_get_string(args) ?: "";

  if (!documentID)
    return create_error_response("InvalidArguments", "Document ID not provided");

  auto documentPtr = pdfviewer::GetPdfDocument(documentID);
  if (!documentPtr)
    return create_error_response("DocumentNotFound", "Document not found");

  int pageCount = FPDF_GetPageCount(documentPtr->pdfDocument());
  FlValue *flPageWidths = fl_value_new_list();

  for (int i = 0; i < pageCount; ++i)
  {
    FPDF_PAGE page = FPDF_LoadPage(documentPtr->pdfDocument(), i);
    if (page)
    {
      double width = FPDF_GetPageWidthF(page);
      fl_value_append_take(flPageWidths, fl_value_new_float(width));
      FPDF_ClosePage(page);
    }
  }
  return FL_METHOD_RESPONSE(fl_method_success_response_new(flPageWidths));
}

// Function to convert FPDF_BITMAP to FlValue using a raw array
FlValue *ConvertBitmapToFlValue(FPDF_BITMAP bitmap, int width, int height)
{
  // Calculate buffer size: width * height * 4 (for RGBA)
  size_t bufferSize = width * height * 4;

  // Allocate memory for the raw array
  std::vector<uint8_t> imageData(bufferSize);

  // Copy data from the bitmap to the raw array
  std::memcpy(imageData.data(), FPDFBitmap_GetBuffer(bitmap), bufferSize);

  // Create an FlValue from the raw array
  return fl_value_new_uint8_list(imageData.data(), bufferSize);
}

// Function to get a page's image
FlMethodResponse *GetPdfPageImage(FlMethodCall *method_call)
{
  FlValue *args = fl_method_call_get_args(method_call);
  if (args == nullptr || fl_value_get_type(args) != FL_VALUE_TYPE_MAP)
    return create_error_response("InvalidArguments", "Invalid arguments");

  int index = fl_value_get_int(fl_value_lookup_string(args, "index"));
  int width = fl_value_get_int(fl_value_lookup_string(args, "width"));
  int height = fl_value_get_int(fl_value_lookup_string(args, "height"));
  const gchar *documentID = fl_value_get_string(fl_value_lookup_string(args, "documentID"));

  if (!documentID)
    return create_error_response("InvalidArguments", "Document ID not provided");

  auto documentPtr = pdfviewer::GetPdfDocument(documentID);
  if (!documentPtr)
    return create_error_response("DocumentNotFound", "Document not found");

  FPDF_DOCUMENT document = documentPtr->pdfDocument();
  FPDF_PAGE page = FPDF_LoadPage(document, index - 1);
  if (!page)
    return create_error_response("PageNotFound", "Page not found");

  FPDF_BITMAP bitmap = FPDFBitmap_Create(width, height, 0);
  FPDFBitmap_FillRect(bitmap, 0, 0, width, height, 0xFFFFFFFF);
  FPDF_RenderPageBitmap(bitmap, page, 0, 0, width, height, 0, FPDF_LCD_TEXT | FPDF_REVERSE_BYTE_ORDER);

  // Convert and get FlValue
  FlValue *result = ConvertBitmapToFlValue(bitmap, width, height);

  FPDFBitmap_Destroy(bitmap);
  FPDF_ClosePage(page);

  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

// Function to get tile image from a PDF page
FlMethodResponse *GetPdfPageTileImage(FlMethodCall *method_call)
{
  FlValue *args = fl_method_call_get_args(method_call);
  if (args == nullptr || fl_value_get_type(args) != FL_VALUE_TYPE_MAP)
    return create_error_response("InvalidArguments", "Invalid arguments");

  int pageNumber = fl_value_get_int(fl_value_lookup_string(args, "pageNumber"));
  double scale = fl_value_get_float(fl_value_lookup_string(args, "scale"));
  const gchar *documentID = fl_value_get_string(fl_value_lookup_string(args, "documentID"));
  double x = fl_value_get_float(fl_value_lookup_string(args, "x"));
  double y = fl_value_get_float(fl_value_lookup_string(args, "y"));
  int width = static_cast<int>(fl_value_get_float(fl_value_lookup_string(args, "width")));
  int height = static_cast<int>(fl_value_get_float(fl_value_lookup_string(args, "height")));

  if (!documentID)
    return create_error_response("InvalidArguments", "Document ID not provided");

  auto documentPtr = pdfviewer::GetPdfDocument(documentID);
  if (!documentPtr)
    return create_error_response("DocumentNotFound", "Document not found");

  FPDF_DOCUMENT document = documentPtr->pdfDocument();
  FPDF_PAGE page = FPDF_LoadPage(document, pageNumber - 1);
  if (!page)
    return create_error_response("PageNotFound", "Page not found");

  FS_MATRIX matrix = {static_cast<float>(scale), 0, 0, static_cast<float>(scale),
                      static_cast<float>(-x * scale), static_cast<float>(-y * scale)};
  FS_RECTF rect = {0, 0, static_cast<float>(width * scale), static_cast<float>(height * scale)};

  FPDF_BITMAP bitmap = FPDFBitmap_Create(width, height, 0);
  FPDFBitmap_FillRect(bitmap, 0, 0, width, height, 0xFFFFFFFF);
  FPDF_RenderPageBitmapWithMatrix(bitmap, page, &matrix, &rect, FPDF_LCD_TEXT | FPDF_REVERSE_BYTE_ORDER);

  // Convert and get FlValue
  FlValue *result = ConvertBitmapToFlValue(bitmap, width, height);

  FPDFBitmap_Destroy(bitmap);
  FPDF_ClosePage(page);

  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

// Function to close a PDF document
FlMethodResponse *CloseDocument(FlMethodCall *method_call)
{
  FlValue *args = fl_method_call_get_args(method_call);
  const gchar *documentID = args ? fl_value_get_string(args) : "";

  if (documentID)
  {
    pdfviewer::ClosePdfDocument(documentID);
    return FL_METHOD_RESPONSE(fl_method_success_response_new(fl_value_new_string("Success")));
  }

  return create_error_response("Error", "Document ID not provided");
}