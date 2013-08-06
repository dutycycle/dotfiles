(require 'package)
(package-initialize)
(setq package-archives
      '(("ELPA" . "http://tromey.com/elpa/")
	("gnu" . "http://elpa.gnu.org/packages/")
	("marmalade" . "http://marmalade-repo.org/packages/")))

(require 'ess-site)
(setq inferior-R-program-name "/usr/local/bin/R")
