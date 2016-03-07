(setq default-major-mode 'text-mode) ;;把文本模式设置成默认的主模式
(add-hook 'text-mode-hook 'turn-on-auto-fill) ;; 只要在文件模式里,就启用自动换行

(setq make-backup-files nil)  ;; 禁止自动产生备份

(setq-default transient-mark-mode t) ;; 自动启用临时标记,被mark的部分会高亮

(global-linum-mode t)  ;; 显示行号
(set-default-font "monaco-14")  ;; 设置字体
(tool-bar-mode 0)      ;; 隐藏工具栏
;;(scroll-bar-mode 0)    ;; 隐藏滚动条

(setq org-startup-indented t) ;; 打开org文件默认都indent,切换的命令为 M-x org-indent-mode

;;;;;;;;; el-get start;;;;;;;;;;;;;;;;;;;;
;; 具体查看: https://github.com/dimitri/el-get
;; 常用命令:
;;  M-x el-get-install
;;  M-x el-get-remove
;;  M-x el-get-reinstall
;;  M-x el-get-self-update
;;  M-x el-get-update
;;  M-x el-get-update-all 等等
;;  M-x el-get-list-packages  查看所有的包
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")
(el-get 'sync)
;;;;;;;;; el-get end;;;;;;;;;;;;;;;;;;;;
