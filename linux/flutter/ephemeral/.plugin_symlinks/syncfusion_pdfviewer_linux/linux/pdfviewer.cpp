#include <unordered_map>
#include <glib.h>
#include <fpdfview.h>

#include "pdfviewer.h"

namespace pdfviewer
{
  struct GStringHash
  {
    std::size_t operator()(const GString *gs) const
    {
      return g_str_hash(gs->str);
    }
  };

  struct GStringEqual
  {
    bool operator()(const GString *a, const GString *b) const
    {
      return g_str_equal(a->str, b->str);
    }
  };

  // Repository to store active PDF documents
  std::unordered_map<GString *, PdfDocument *, GStringHash, GStringEqual> documentRepo;

  // Function to retrieve a PDF document by ID
  PdfDocument *GetPdfDocument(const gchar *doc_id)
  {
    if (!doc_id)
      return nullptr;

    GString tmp = GString{(gchar *)doc_id, strlen(doc_id), 0};
    auto it = documentRepo.find(&tmp);
    if (it != documentRepo.end())
    {
      return it->second;
    }
    return nullptr;
  }

  // Function to close a PDF document by ID
  gboolean ClosePdfDocument(const gchar *doc_id)
  {
    if (!doc_id)
      return FALSE;

    GString tmp = GString{(gchar *)doc_id, strlen(doc_id), 0};
    auto it = documentRepo.find(&tmp);

    if (it != documentRepo.end())
    {
      FPDF_CloseDocument(it->second->pdfDocument());
      delete it->second;
      g_string_free(it->first, TRUE);
      documentRepo.erase(it);
      if (documentRepo.empty())
      {
        FPDF_DestroyLibrary();
      }
      return TRUE;
    }
    return FALSE;
  }

  // Function to initialize the PDF renderer
  PdfDocument *InitializePdfRenderer(GBytes *data, const gchar *password, const gchar *doc_id)
  {
    if (!data || !doc_id)
      return nullptr;

    if (documentRepo.empty())
    {
      FPDF_InitLibraryWithConfig(nullptr);
    }

    PdfDocument *doc = new PdfDocument(data, password, doc_id);
    if (!doc->pdfDocument())
    {
      delete doc;
      return nullptr;
    }

    documentRepo[g_string_new(doc_id)] = doc;
    return doc;
  }

  // PdfDocument constructor
  PdfDocument::PdfDocument(GBytes *data, const gchar *password, const gchar *id)
      : data_(g_bytes_ref(data)), document_id_(g_strdup(id)), pdf_document_(nullptr)
  {
    gsize data_size;
    const guint8 *data_bytes = static_cast<const guint8 *>(g_bytes_get_data(data, &data_size));
    pdf_document_ = FPDF_LoadMemDocument64(data_bytes, data_size, password);

    if (!pdf_document_)
    {
    }
  }

  // PdfDocument destructor
  PdfDocument::~PdfDocument()
  {
    g_bytes_unref(data_);
    g_free(document_id_);
  }
} // namespace pdfviewer