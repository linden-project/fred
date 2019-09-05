# Fred, a front matter cli editor

[![GitHub release](https://img.shields.io/github/release/mipmip/fred.svg)](https://github.com/mipmip/fred/releases)
[![Build Status](https://travis-ci.org/mipmip/fred.svg?branch=master)](https://travis-ci.org/mipmip/fred)

Fred is a cli utility for precisely editing YAML-nodes inside the front matter
of a markdown file.

## Features
- Rename the key of a scalar node
- Replace value of scalar node
- Scaler node at 1st level are automatically defined as variable
- Substitute variables inside scalar node when it's defined lines earlier

## Installation

### With Homebrew

1. brew tap mipmip/homebrew-crystal
1. brew install fred

### From Source

1. git clone https://github.com/mipmip/fred
1. cd fred
1. make

## Usage

```bash
  Usage:

    fred help

  Options:

    --help                           Show this help.
    -d, --dryrun                     Dry run. Output only [type:Bool]
    -r, --recursive                  Path is a directory. All .md files in the directory will be processed [type:Bool]
    -v, --verbose                    Be verbose [type:Bool]

  Sub Commands:

    version                  version
    replace_1st_level_vars   replace 1st level variables in inside the front matter
    rename_taxo_key          rename a taxo string val
    rename_taxo_val          rename a taxo string val in a single file
```

## Variable usage
Every scalar node as 1st level can be used as replace value inside lower of
deeper scalar values. See example:

You have a file *crystal-rules.md* with the following contents.

```markdown
---
title: Crystal Rules
category: Programming languages
date: "15 august 2019"
meta_info:
  abstract: $FORMAT This post is is written on {date} in the category {category}.
  file_name_pdf: $FORMAT /Users/mipmip/{date}-{title}.pdf
---

Did I tell you ...
```

When you run ````fred replace_1st_level_vars```` the file will look like this:

```markdown
---
title: Crystal Rules
category: Programming languages
date: "15 august 2019"
meta_info:
  abstract: This post is is written on 15 august in the category Programming Languages.
  file_name_pdf: $FORMAT /Users/mipmip/15 august-Crystal Rules.pdf
---

Did I tell you ...
```

## Example integration in Vim with Pandocomatic

```
nmap ,t :AsyncRun /usr/bin/fred replace_1st_level_vars -d % > /tmp/pandotemp.md && rvm 2.5.1 do pandocomatic -b -i /tmp/pandotemp.md<CR>
```

## Syntax

| Tag      | Arguments                  | Example                                    | Description                                                                                                               |
|----------|----------------------------|--------------------------------------------|---------------------------------------------------------------------------------------------------------------------------|
| $FORMAT  | String with vars inside {} | $FORMAT written by {author1} and {author2} | Replaces ```{author1}``` and ```{author2}``` with the values of the 1st level yaml keys ```author1:``` and ```author2:``` |
| $INCLUDE | Include path to YAML file  | $INCLUDE ./blog_layout_config.yml          | Imports external YAML at the include location. Path can be absolute or relative to the markdown file                      |

## Development

### Run Specs

```
make run_spec
make run_coverage
```

### Build

```
make build
```


## Contributing

1. Fork it (<https://github.com/your-github-user/fred/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Pim Snel](https://github.com/mipmip) - creator and maintainer
