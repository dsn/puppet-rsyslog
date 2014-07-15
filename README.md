rsyslog [![Build Status](https://travis-ci.org/dsn/puppet-rsyslog.svg?branch=master)](https://travis-ci.org/dsn/puppet-rsyslog)
======
####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with rsyslog](#setup)
    * [What rsyslog affects](#what-rsyslog-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with rsyslog](#beginning-with-rsyslog)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

This module provides quick and easy management of rsyslog.

##Module Description

Puppet module to manage rsyslog.

##Setup

###What puppet affects

* package/service/configuration files for rsyslog

###Setup Requirements

This module requires the Puppet Labs stdlib module which you can install with

```puppet module install puppetlabs-stdlib```

###Beginning with puppet

Clone the repo and use the PMT to install the module or clone directly into your $modulepath

##Usage

### rsyslog

The `rsyslog` class is intended as a high-level abstraction to help simplify the process of managing your rsyslog configurations.

```puppet
class { 'rsyslog': }
```

**Parameters within `rsyslog`:**

####`sample_param`

Sample Description.

##Reference

Below are various sample uses for the module.

###TCP Syslog Server

```puppet
class { 'rsyslog':
  enable_tcp_server => true  
}
```

###UDP Syslog Server

```puppet
class { 'rsyslog':
  enable_udp_server => true  
}```

####Hiera Samples

###TCP Server on a Custom Port
```yaml
---
classes:
  - rsyslog

rsyslog::enable_tcp_server: true
rsyslog::tcp_server_port: 5140
```

###Client forwarding to multiple hosts

```yaml
---
classes:
  - rsyslog
  
rsyslog::forwarding_rules:
  'host01': {
    protocol => 'tcp',
	rule     => '*.*'
  },
  'host02': {
    protocol => 'upd',
	rule     => 'kern.*'
  }
```
##Limitations

Currently rsyslog is compatible with

```Puppet Version: 2.7+```

Platforms:
* CentOS 6
* Fedora 18
* RHEL 6

##Development

Rake tasks have been created to assist in testing your module during development. To run the unit tests you might have to install some ruby gems.

```bundle install```

Tasks:

* test      - Run Lint, Syntax Tests
* spec_prep - Setup Fixtures for Testing
* spec      - Run Unit Tests (RSpec)
* bump      - Bump Module Version