# Fred, a front matter cli editor

[![GitHub release](https://img.shields.io/github/release/mipmip/fred.svg)](https://github.com/mipmip/fred/releases)
[![Build Status](https://travis-ci.org/mipmip/fred.svg?branch=master)](https://travis-ci.org/mipmip/fred)

Fred is a cli utility for precisely editing YAML-nodes inside the front matter
of a markdown file.

## Features

- Unset key
- Rename the key of a scalar node
- Replace string value of scalar node
- Toggle bool value of scalar node
- Scaler node at 1st level are automatically defined as variable
- Substitute variables inside scalar node when it's defined lines earlier
- Recursive mode for processing files inside directories
- Dry run mode

## Installation

### With Homebrew

1. brew tap mipmip/homebrew-crystal
1. brew install fred

### From Source

1. git clone https://github.com/linden-project/fred
1. cd fred
1. make

## Usage

```bash

  Options:

    --help                           Show this help.

  Sub Commands:

    echo                     echo display one node by key
    set_bool_val             Set boolean value for front matter key
    set_string_val           Set string value for front matter key
    unset_key                Remove key from front matter
    replace_key              Find and replace key in front matter
    replace_string_val       Find and replace a string value in front matter
    toggle_bool_val          Toggle a bool value in front matter, if true set false, if false or missing set true
    replace_1st_level_vars   replace variables found on 1st level in other levels in inside front matter
    replace_includes         replace includes inside front matter
    process_functions        replace $FORMAT and $INCLUDE inside front matter
    version                  version
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
