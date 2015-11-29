Get Server Data
===============
[![Gem Version](https://badge.fury.io/rb/get_server_data.svg)](https://badge.fury.io/rb/get_server_data)
[![Build Status](https://travis-ci.org/seanmalloy/get-server-data.svg?branch=master)](https://travis-ci.org/seanmalloy/get-server-data)
[![Coverage Status](https://coveralls.io/repos/seanmalloy/get-server-data/badge.svg)](https://coveralls.io/r/seanmalloy/get-server-data)
[![Inline Docs](http://inch-ci.org/github/seanmalloy/get-server-data.png?branch=master)](http://inch-ci.org/github/seanmalloy/get-server-data)

Simple command line tool that collects data about servers.

## Installation
```
gem install get_server_data
```

## Usage

### Command dns
```
$ gsd dns www.google.com www.openbsd.org www.spmalloy.com
HOSTNAME         | IP             | DNS
-----------------|----------------|------
www.google.com   | 74.125.225.19  | A
www.openbsd.org  | 129.128.5.194  | A
www.spmalloy.com | 107.170.163.14 | CNAME
```

###  Command help
```
$ gsd help
Commands:
  gsd dns [OPTION...] HOSTNAME...   # Get information about hosts from DNS
  gsd help [COMMAND]                # Describe available commands or one specific command
  gsd ping [OPTION...] HOSTNAME...  # Get information about hosts from ICMP(ping)
  gsd tcp [OPTION...] HOSTNAME...   # Get information about a TCP port for hosts

Options:
  -f, [--format=FORMAT]          # Use FORMAT as the output format. FORMAT can be one of csv, json, or text
                                 # Default: text
  -s, [--sort], [--no-sort]      # Sort output by hostname
                                 # Default: true
  -u, [--unique], [--no-unique]  # Remove duplicate hostnames
                                 # Default: true
```

### Command ping
```
$ gsd ping www.google.com www.openbsd.org www.spmalloy.com
HOSTNAME         | IP             | PING
-----------------|----------------|-----
www.google.com   | 216.58.216.68  | true
www.openbsd.org  | 129.128.5.194  | true
www.spmalloy.com | 107.170.163.14 | true
```

### Command tcp
```
$ gsd tcp www.google.com www.openbsd.org www.spmalloy.com
HOSTNAME         | IP             | PORT | PORT_RESULT
-----------------|----------------|------|------------
www.google.com   | 216.58.216.68  | 22   | false
www.openbsd.org  | 129.128.5.194  | 22   | true
www.spmalloy.com | 107.170.163.14 | 22   | true
```

## Copyright
Copyright (c) 2015 Sean Malloy. See [LICENSE](LICENSE.md) for further details.

