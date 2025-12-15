#include <glib.h>
#include <fpdfview.h>

namespace pdfviewer {

  class PdfDocument {
  public:
    // Constructor initializes the document with data, password and its ID
    PdfDocument(GBytes* data, const gchar *password, const gchar *id);
    ~PdfDocument();

    // Accessor for document ID
    const gchar* documentID() const { return document_id_; }

    // Accessor for document
    FPDF_DOCUMENT pdfDocument() const { return pdf_document_; }

  private:
    GBytes* data_;
    gchar* document_id_;
    FPDF_DOCUMENT pdf_document_;
  };

  PdfDocument* InitializePdfRenderer(GBytes* data, const gchar *password, const gchar *doc_id);
  PdfDocument* GetPdfDocument(const gchar *doc_id);
  gboolean ClosePdfDocument(const gchar *doc_id);

} // namespace pdfviewer