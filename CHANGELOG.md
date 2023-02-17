# CHANGELOG
## Fred 0.4.0 - vr 17 feb 2023
- rename taxo to front-matter everywhere
- feature: set_key_val
- make empty yaml if not exists

## Fred 0.3.4 - vr 06 sep 2019
- function to import yaml templates in front matter using $INCLUDE

## Fred 0.3.3 - Sep 3
- always output when executed with dryrun

## Fred 0.3.2 - Sep 2
- fix malformed frontmatter
- spec to test valid front matter

## Fred 0.3.1 - Sep 1
- brew formula

## Fred 0.3.0 - Sep 1
- remame to Fred
- travis ci
- documentation in Engels
- update readme

## Froprepro 0.2.2-0.2.5 - Sep 1
- only write modified files
- report changes
- init FS_processor with file (in plaats van per method)
- port prepocess function to new refactoring
- los problemen vreemde tekens op: zie [[SHELL grep "\\\x" -r ~/Dropbox/Apps/KiwiApp]]
- maak issue op crystal github met voorbeeld
- workaround def uitbreiden met alle reguliere speciale tekens éèëê ûüú ïî âáäà óóöô ç © &@$€
- vreemde tekens in key functie testen

## Froprepro 0.2.1 - Aug 29
- implement verbose option
- testing & coverage

## Froprepro 0.2.0 - Aug 16 2019
- usage for rename keys
- rename taxo_key
- rename taxo_val
- big refactor
- use options
- dryrun
- recursive for directories

## Froprepro 0.1.0 - Aug 15 2019
- choose programming language: becase crystal
- cli framework
- options define
- replace function
- loop function
- preprocess
  - load frontmatter from markdown
  - while replacements > 0 replace keyvalues in variables
  - write output



