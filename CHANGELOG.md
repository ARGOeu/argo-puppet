# argo-puppet changelog

Release notes for argo-puppet module

### 1.1.4 - 5 Oct 2023

* AO-842 Set directory owner to sensu for /etc/sensu/certs

### 1.1.3 - 3 Aug 2023

* AO-826 Define different cron command for argo-poem-tools for Nagios and Sensu boxes

### 1.1.2 - 25 May 2023

* AO-798 Update scg.conf.erb template

### 1.1.1 - 1 Mar 2023

* AO-764 Make AMS publisher optional on Sensu backend

### 1.1.0 - 30 Jan 2023

* AO-756 Puppet configuration for Sensu

### 1.0.3 - 6 Sep 2022

* AO-702 Handle httpd and nagios services through Puppet

### 1.0.2 - 6 Sep 2022

* AO-678 Change name of packages in the puppet files

### 1.0.1 - 1 Sep 2022

* AO-674 Fix puppet files for production mon boxes for the new version of publisher
* AO-673 Make sure that argo-probe-poem-tools package is installed on every monbox
* AO-672 Ensure that latest argo-ams-library is installed on monboxes

### 1.0.0 - 8 Aug 2022

* Initial release