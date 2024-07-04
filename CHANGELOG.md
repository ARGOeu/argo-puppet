# argo-puppet changelog

Release notes for argo-puppet module

### 1.8.2 - 4 Jul 2024

* AO-986 Include tenant entry in argo-sensu-tools.conf.erb template

### 1.8.1 - 27 Jun 2024

* AO-985 Include repo for HTCondor packages on Rocky 9
* AO-983 Add nordugrid-arc-nagios-plugins-egi to Puppet configuration files regarding arc

### 1.8.0 - 17 Jun 2024

* AO-972 Change argo-poem-tools.conf.erb template to work with the changes in the tool

### 1.7.1 - 5 Jun 2024

* ARGO-4662 Update scg.conf.erb template

### 1.7.0 - 19 Mar 2024

* AO-935 Install python-argo-ams-library only on el7

### 1.6.0 - 13 Mar 2024

* AO-918 Modify module so that it does not include unnecessary repos

### 1.5.0 - 1 Feb 2024

* AO-898 Install assets for CPU and memory monitoring
* AO-894 Include skipped_metrics entry in scg.conf configuration
* AO-882 Create arc manifest

### 1.4.0 - 9 Jan 2024

* AO-877 Update README file to reflect the changes in the module
* AO-871 Create manifest for condor
* AO-870 Add 'agents_configuration' option in scg.conf.erb template

### 1.3.0 - 3 Jan 2024

* AO-868 Add "subscription" option to configuration file template

### 1.2.0 - 22 Nov 2023

* AO-855 Update scg.conf.erb template
* AO-853 Ensure existence of /var/nagios directory when setting up argo-sensu-tools
* AO-851 Add directive to reload service when argo-sensu-tools configuration has been changed
* AO-850 Handle argo-sensu-tools with ARGO Puppet module

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