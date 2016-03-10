(setq default-major-mode 'text-mode) ;;把文本模式设置成默认的主模式
(add-hook 'text-mode-hook 'turn-on-auto-fill) ;; 只要在文件模式里,就启用自动换行
(setq make-backup-files nil)  ;; 禁止自动产生备份

(setq-default transient-mark-mode t) ;; 自动启用临时标记,被mark的部分会高亮

(global-linum-mode t)  ;; 显示行号
(set-default-font "monaco-14")  ;; 设置字体
(tool-bar-mode 0)      ;; 隐藏工具栏
(scroll-bar-mode 0)    ;; 隐藏滚动条


;;粘贴于光标处,而不是鼠标指针处  
(setq mouse-yank-at-point t)


;;======================================================================  
;;状态栏  
;;======================================================================
(display-time-mode 1);;启用时间显示设置，在minibuffer上面的那个杠上  
(setq display-time-24hr-format t);;时间使用24小时制  
;;(setq display-time-day-and-date t);;时间显示包括日期和具体时间

;;显示标题栏 %f 缓冲区完整路径 %p 页面百分数 %l 行号  
(setq frame-title-format "%f")

;;显示列号  
(setq column-number-mode t)  

;;;;;;;; org-mode ;;;;;;;;;;;;;;;
(setq org-startup-indented t) ;; 打开org文件默认都indent,切换的命令为 M-x org-indent-mode

;; org模式下默认没有自动换行
(add-hook 'org-mode-hook (lambda()(setq truncate-lines nil))) 




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

;;;; 设置一个 color-theme
(color-theme-initialize)
(color-theme-gnome2)

;;; 格式化代码,为了方便,绑定到F7键
(defun indent-buffer ()
  "Indent the whole buffer."
  (interactive)
  (save-excursion
    (indent-region (point-min) (point-max) nil)))
(global-set-key [f7] 'indent-buffer)


;;;;;; 设置一下写C++代码的格式
(defun vlad-cc-style()
  (c-set-style "linux")
  (c-set-offset 'innamespace '0)
  (c-set-offset 'inextern-lang '0)
  (c-set-offset 'inline-open '0)
  (c-set-offset 'label '*)
  (c-set-offset 'case-label '*)
  (c-set-offset 'access-label '/)
  (setq c-basic-offset 4)
  (setq tab-width 4)
  (setq indent-tabs-mode nil)
  )

(add-hook 'c++-mode-hook 'vlad-cc-style)

;;;; window-numbering 全局有效
(window-numbering-mode)

;;;; 自动括号匹配,使用的是 autopair 插件
;;;; 全局有效
(autopair-global-mode)

;;;; Helm 全局有效
(helm-mode 1)

;;;;yasnippets
(yas-global-mode 1)

;;; ace-jump-mode
;; 绑定到快捷键 C-c Space
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

;;; find-file-in-project

;;; 实现类似 vim 里面的 O 和 o 
(defun newline-above-current()
  "Add a line above current line like vim O."
  (interactive)
  (progn (beginning-of-line)
	 (open-line 1)
	 (indent-according-to-mode)))

(defun newline-next-current()
  "Add a line next current line like vim o."
  (interactive)
  (progn (end-of-line)
	 (newline-and-indent)))

(global-set-key (kbd "C-o") 'newline-next-current)
(global-set-key (kbd "C-S-o") 'newline-above-current)


;; 另外，我在这三个函数中都使用back-to-indentation来移动到行首，可以把行首的 
;; 空白排除在外，不喜欢的话可以改成move-beginning-of-line. 
;;;; 实现快速选中一行多行
(defun yp-mark-line (&optional arg) 
  (interactive "P") 
  (if (region-active-p) 
      (progn 
        (goto-char (line-end-position 2))) 
    (progn 
      (back-to-indentation) 
      (set-mark (point)) 
      (goto-char (line-end-position)))) 
  (setq arg (if arg (prefix-numeric-value arg) 
              (if (< (mark) (point)) -1 1))) 
  (if (and arg (> arg 1)) 
      (progn 
        (goto-char (line-end-position arg)))))

(global-set-key (kbd "C-z") 'yp-mark-line) 

;;; 不需要选中的 复制和剪切
(defun yp-copy (&optional arg) 
  "switch action by whether mark is active" 
  (interactive "P") 
  (if mark-active 
      (kill-ring-save (region-beginning) (region-end)) 
    (let ((beg (progn (back-to-indentation) (point)))  
          (end (line-end-position arg))) 
      (copy-region-as-kill beg end)))) 

(defun yp-kill (&optional arg) 
  "switch action by whether mark is active" 
  (interactive "P") 
  (if mark-active 
      (kill-region (region-beginning) (region-end)) 
    (kill-whole-line arg))) 

(global-set-key (kbd "M-w") 'yp-copy) 
(global-set-key (kbd "C-w") 'yp-kill) 

;;;;; smex 插件
;;; 使用 C-s/C-r切换 Return 确定
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)


;;;; bar-cursor
;;;; 将光标设置成竖线
(bar-cursor-mode)

;;切换.h .cpp 切换,绑定到F4
;;open related head/cpp file
(defun switch-source-file (p)
  "open related header file or cpp file"
  (interactive "p")   
  (setq wholename (buffer-file-name))
  (setq nameext (file-name-extension wholename))
  (if (string= nameext "h")
      ( (lambda()
	  (setq namenew (concat (file-name-sans-extension wholename) ".cpp"))
	  ( if(= p 0) (find-file namenew)
	    (find-file-other-window namenew)
	    ))))
  (if (string= nameext "cpp")
      ((lambda()
	 (setq namenew (concat (file-name-sans-extension wholename) ".h"))
	 ( if(= p 0)  (find-file namenew)
	   (find-file-other-window namenew)
	   )))))

(global-set-key [f4] 'switch-source-file)


;;;; 创建.h头文件自动加上预编译头
(defun get-include-guard ()
  "Return a string suitable for use in a C/C++ include guard"
  (let* ((fname (buffer-file-name (current-buffer)))
	 (fbasename (replace-regexp-in-string".*/"""fname))
	 (inc-guard-base (replace-regexp-in-string"[.-]"
						  "_"
						  fbasename)))
    (concat (upcase inc-guard-base)"_")))

(add-hook 'find-file-not-found-hooks
	  '(lambda ()
	     (let ((file-name (buffer-file-name (current-buffer))))
	       (when (string=".h"(substring file-name -2))
		 (let ((include-guard (get-include-guard)))
		   (insert"#ifndef "include-guard)
		   (newline)
		   (insert"#define "include-guard)
		   (newline 4)
		   (insert"#endif")
		   (newline)
		   (previous-line 3)
		   (set-buffer-modified-p nil))))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; auto-compelete-clang
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 设置响应时间 0.5
(setq ac-quick-help-delay 0.5)    
;;(ac-set-trigger-key "TAB")    
;;(define-key ac-mode-map  [(control tab)] 'auto-complete)    
;; 提示快捷键为 M-/  
(define-key ac-mode-map  (kbd "M-/") 'auto-complete)

;;; 这里我设置的应该是 libc++ 的头文件
;;;; /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1
(defun my-ac-config ()    
  (setq ac-clang-flags    
        (mapcar(lambda (item)(concat "-I" item))    
               (split-string    
                " 
 /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/../include/c++/v1
 /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/../lib/clang/6.1.0/include
 /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include
 /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.10.sdk/usr/include
 /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.10.sdk/System/Library/Frameworks  
"  
)))    
  (setq-default ac-sources '(ac-source-abbrev ac-source-dictionary ac-source-words-in-same-mode-buffers))    
  (add-hook 'emacs-lisp-mode-hook 'ac-emacs-lisp-mode-setup)    
  (add-hook 'c-mode-common-hook 'ac-cc-mode-setup)    
  (add-hook 'ruby-mode-hook 'ac-ruby-mode-setup)    
  (add-hook 'css-mode-hook 'ac-css-mode-setup)    
  (add-hook 'auto-complete-mode-hook 'ac-common-setup)    
  (global-auto-complete-mode t))    
(defun my-ac-cc-mode-setup ()    
  (setq ac-sources (append '(ac-source-clang ac-source-yasnippet) ac-sources)))    
(add-hook 'c-mode-common-hook 'my-ac-cc-mode-setup)    
;; ac-source-gtags    
(my-ac-config)    
(ac-config-default)  
;; 结束  
