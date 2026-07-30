{**
 * TEMPLATE LoA KHUSUS RJME (Revenue Journal: Management and Entrepreneurship)
 * ======================================================================
 * Variable yang tersedia:
 *   {$loa}                   → Object LoA
 *     {$loa->getUniqueCode()}    Kode unik (LOA-1-142-...)
 *     {$loa->getDateGenerated()} Tanggal generate
 *     {$loa->getStatus()}        Status: 'active' / 'revoked'
 *   {$submission}            → Object Submission
 *     {$submission->getId()}     ID submission
 *   {$publication}           → Object Publication
 *     {$publication->getLocalizedTitle()} Judul artikel
 *     {$publication->getData('authors')}  Array penulis
 *   {$context}               → Object Journal
 *     {$context->getLocalizedData('name')} Nama jurnal
 *     {$context->getPath()}              Slug (rjme)
 *   {$editorInChiefName}     → Nama Editor-in-Chief (dari settings plugin)
 *   {$editorInChiefTitle}    → Jabatan Editor-in-Chief (dari settings plugin)
 *   {$baseUrl}               → Base URL website
 *   {$currentLocale}         → Locale (en_US, id_ID)
 *}
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Letter of Acceptance - Revenue Journal</title>
<style>
.ojs-loa-container {
    width: 100%;
    max-width: 800px;
    margin: 0 auto;
    background-color: #f4f5f7;
    padding: 20px 0;
    font-family: 'Segoe UI', Calibri, Arial, sans-serif;
    color: #222;
}

.ojs-loa-page {
    width: 210mm;
    min-height: 297mm;
    margin: 0 auto 30px auto;
    padding: 15mm;
    background: #ffffff;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    position: relative;
    box-sizing: border-box;
}

.ojs-loa-header img {
    width: 100%;
    height: auto;
    display: block;
    margin-bottom: 20px;
}

.ojs-loa-date {
    text-align: right;
    font-size: 14px;
    margin-bottom: 20px;
    color: #333;
}

.ojs-loa-title {
    text-align: center;
    font-size: 20px;
    font-weight: bold;
    color: #0070c0;
    text-decoration: underline;
    margin: 25px 0;
}

.ojs-loa-author {
    font-size: 14px;
    margin-bottom: 15px;
}

.ojs-loa-manuscript-title {
    text-align: center;
    font-weight: bold;
    font-size: 16px;
    color: #d9534f;
    margin: 20px 10px;
    line-height: 1.5;
}

.ojs-loa-text {
    font-size: 14px;
    line-height: 1.6;
    text-align: justify;
    margin-bottom: 15px;
    color: #333;
}

.ojs-loa-signature {
    margin-top: 30px;
    font-size: 14px;
    line-height: 1.6;
}

.ojs-loa-section-title {
    text-align: center;
    font-size: 18px;
    font-weight: bold;
    text-decoration: underline;
    margin: 20px 0 30px 0;
}

.ojs-loa-info-box {
    font-size: 14px;
    line-height: 2;
    margin-bottom: 20px;
}

.ojs-loa-indexed-title {
    font-weight: bold;
    font-size: 14px;
    color: #003366;
    border-bottom: 2px solid #003366;
    display: inline-block;
    margin-top: 25px;
    margin-bottom: 15px;
}

.ojs-loa-index-img img {
    width: 100%;
    height: auto;
    display: block;
    margin-top: 10px;
}

.ojs-loa-footer {
    text-align: center;
    font-size: 12px;
    color: #555;
    text-decoration: underline;
    margin-top: 40px;
    padding-bottom: 10px;
}

.no-print { display: block; }

@media print {
    body { background: #fff !important; }
    .ojs-loa-container { background: none; padding: 0; max-width: 100%; }
    .ojs-loa-page { box-shadow: none; margin: 0; width: 100%; height: auto; page-break-after: always; padding: 10mm; }
    .no-print { display: none; }
}

@media screen and (max-width: 768px) {
    .ojs-loa-page { width: 95%; padding: 15px; min-height: auto; }
}

.btn-print { display: block; margin: 20px auto; padding: 10px 30px; font-size: 16px; cursor: pointer; }
</style>
</head>
<body>

<button class="btn-print no-print" onclick="window.print()">Print</button>

<div class="ojs-loa-container">

    <!-- HALAMAN 1 -->
    <div class="ojs-loa-page">
        <div class="ojs-loa-header">
            <img src="https://assyfa.com/storage/uploads/2026/07/DIf1MThgKwuRpGEBpUiKx6GIx61H148xFL7PURnk.png" alt="Header Revenue Journal">
        </div>

        <div class="ojs-loa-date">
            <strong>Dated:</strong> {$loa->getDateGenerated()|date_format:"%d/%m/%Y"}
        </div>

        <div class="ojs-loa-title">
            MANUSCRIPT ACCEPTANCE LETTER
        </div>

        <div class="ojs-loa-author">
            <strong style="color: #558235;">Dear Authors:</strong>
            <span style="color: #d9534f; font-weight: bold;">
            {assign var=authorList value=$publication->getData('authors')}
            {foreach name=authors from=$authorList item=author}
                {$author->getFullName()|escape}{if !$smarty.foreach.authors.last}, {/if}
            {/foreach}
            </span>
        </div>

        <div class="ojs-loa-text">
            We are pleased to inform you that our Editorial Board has received and approved your manuscript entitled:
        </div>

        <div class="ojs-loa-manuscript-title">
            {$publication->getLocalizedTitle()|escape}
        </div>

        <div class="ojs-loa-text">
            to be published in the latest issue of <u><strong>&quot;{$context->getLocalizedData('name')|escape}&quot;</strong></u> after successfully passing the review and revision process conducted by the authors. The manuscript has also been checked with the iThenticate tool and shows an acceptable similarity index (SI) (SI &lt; 25%) where all similarities in the manuscript are oriented to comparative or international perspectives, for conceptual contributions to contemporary issues.
        </div>

        <div class="ojs-loa-text">
            All manuscripts accepted in this journal will undergo further editing in Indonesian by our experienced editors. Authors will also receive a gallery proof of the final revision after all quality control checks and before the article is published.
        </div>

        <div class="ojs-loa-text">
            Thank you for choosing to publish in our Journal.
        </div>

        <div class="ojs-loa-signature">
            Best Regards,<br><br>
            <div>{$editorInChiefTitle|escape}</div>
            <strong>{$editorInChiefName|escape}</strong><br>
            <span>Universitas Nahdlatul Ulama Pasuruan, Indonesia</span>
        </div>

        <div class="ojs-loa-footer">
            <u>Copyright &copy; 2026 {$context->getLocalizedData('name')|escape}</u>
        </div>
    </div>

    <!-- HALAMAN 2 -->
    <div class="ojs-loa-page">
        <div class="ojs-loa-header">
            <img src="https://assyfa.com/storage/uploads/2026/07/DIf1MThgKwuRpGEBpUiKx6GIx61H148xFL7PURnk.png" alt="Header Revenue Journal">
        </div>

        <div class="ojs-loa-section-title">
            Manuscript Information
        </div>

        <div class="ojs-loa-info-box">
            <div><strong>Your manuscript ID is</strong> <strong>{$loa->getUniqueCode()|escape}</strong></div>
            <div><strong>Status Date:</strong> {$loa->getDateGenerated()|date_format:"%d/%m/%Y"}</div>
            <div><strong>Status in Editorial Manager:</strong> Accepted for Publication</div>
            <div><u><strong>ISSN:</strong> 3026-1058</u></div>
        </div>

        <div class="ojs-loa-text" style="font-size: 13px;">
            A distinct DOI has been assigned to your manuscript and will appear in the &quot;Article in Press&quot; section once the payment procedures are completed. Please be aware that the Editorial Board reserves the right to make additional edits or refinements to any portion of the article if deemed necessary.
        </div>

        <div class="ojs-loa-indexed-title">
            This Journal is Indexed in the Following:
        </div>

        <div class="ojs-loa-index-img">
            <img src="https://assyfa.com/storage/uploads/2026/07/B9qWS9uLoged5Jul7e0Hv7ZySeNpCyZ3X0AWfoU6.png" alt="Indexing Logos">
        </div>

        <div class="ojs-loa-footer">
            <u>Copyright &copy; 2026 {$context->getLocalizedData('name')|escape}</u>
        </div>
    </div>

</div>

</body>
</html>
