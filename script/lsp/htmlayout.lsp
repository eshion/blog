(context 'htmlayout)

(define (import-list library flist)
    (dolist (fname flist) (import library (string fname))))

(import-list "htmlayout.dll" '(HTMLayoutSetOption HTMLayoutDataReady))
(import-list "htmlayout.dll" '(HTMLayoutEnumResources HTMLayoutGetMinHeight HTMLayoutGetMinWidth))
(import-list "htmlayout.dll" '(HTMLayoutLoadFile HTMLayoutLoadHtmlEx HTMLayoutProcND HTMLayoutUpdateWindow HTMLayoutUpdateWindow))
(import-list "htmlayout.dll" '(HTMLayoutSetCallback ))
(import-list "htmlayout.dll" '(HTMLayoutSetHttpHeaders HTMLayoutSetMediaType HTMLayoutSetMode HTMLayoutGetRootElement))
(import-list "htmlayout.dll" '(HTMLayoutGetFocusElement HTMLayoutFindElement HTMLayoutGetElementByUID))
(import-list "htmlayout.dll" '(HTMLayoutSetCSS HTMLayoutSetMasterCSS HTMLayoutAppendMasterCSS))
(import-list "htmlayout.dll" '(HTMLayoutTraverseUIEvent HTMLayoutWindowAttachEventHandler HTMLayoutWindowDetachEventHandler))

