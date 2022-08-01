# ARGO Puppet module

## Description

This repository contains a Puppet module used for installation and configuration of ARGO monitoring instances.

## Features

Static files used by most tenants are stored in `files/` directory. It contains Nagios configuration files, and a configuration file for ARC-CE probes (this one is used only by EGI tenant, and therefore the subdirectory name). The Nagios configuration files can be overridden through `argo::mon::nagios` class.

The main manifest of the module is in `manifests/mon.pp`. All the related classes can be found in `manifests/mon/` directory.

Finally, in the `templates/` directory one can find templates for definition of configurations for three services: AMS Publisher, argo-poem-tools and argo-ncg.
