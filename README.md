# Froprepro of Frop

Frop is een preprocessor voor de YAML in front matter. Frop kan met behulp van
stringformatering, waarden binnen een YAML-document vervangen.

De YAML-keys van het eerste niveau zijn de variabelen. Deze kunnen in diepere
lagen van de front matter worden hergebruikt als waarde of om een string mee
samen te stellen.

Zie het voorbeeld hieronder:

```markdown
---
title: Dit is een blog
categorie: Programmeertalen
datum: 15 augustus 2019
metainformatie:
  abstract: $FORMAT Dit blog is geschreven op {datum} in de categorie '{categorie}'.
  file_name_pdf: $FORMAT /Users/mipmip/{datum}-{title}.pdf
---

Een blog over programmeertalen ...
```

Nadat de preprocessor is uitgevoerd ziet het markdown-bestand er zo uit:

```markdown
---
title: Dit is een blog
categorie: Programmeertalen
datum: 15 augustus 2019
metainformatie:
  abstract: Dit blog is geschreven op 15 augustus 2019 in de categorie 'Programmeertalen'.
  file_name_pdf: /Users/mipmip/15 augustus 2019-Dit is een blog.pdf
---

Een blog over programmeertalen ...
```

# Gebruik

```
frop file_in.md > file_out.md
```

## Integratie in Vim met Pandocomatic

```
nmap ,t :AsyncRun /usr/bin/frop proc % > /tmp/pandotemp.md && rvm 2.5.1 do pandocomatic -b -i /tmp/pandotemp.md<CR>
```

# froprepro

TODO: Write a description here

## Installation

TODO: Write installation instructions here

## Usage

## Syntax

| Tag     | Arguments     | Example             | Description                                                                                                       |
|---------|---------------|---------------------|-------------------------------------------------------------------------------------------------------------------|
| $FORMAT | Format string | !Format {foo} {bar} | Replaces ````{foo}```` and ````{bar}```` with the values of the 1st level yaml keys ````foo:```` and ````bar:```` |

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/your-github-user/froprepro/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Pim Snel](https://github.com/your-github-user) - creator and maintainer
