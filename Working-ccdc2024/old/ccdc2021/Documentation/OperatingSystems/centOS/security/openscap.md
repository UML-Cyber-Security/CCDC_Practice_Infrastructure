# OpenSCAP scanner


## Objective
Use OpenSCAP scanner to detect system settings that do not comply with DISA/NIST STIG standards. Use these findings to learn about security holes and develop our own "STIG".

## Security Analysis
Vocab:
- NIST (National Institute of Standards and Technology): Agency of the DoC. As the name implies, it is in charge of regulating standards for technology. From measurement to security specifications.
- DISA (Defense Information Systems Agency): Basically the DoD's IT department. Supports any individual or system related to defense of the United States
- STIG (Security Technical Implementation Guide): Methodology for standardizing security protocols for computer systems. Essentially a system hardening checklist.
- SCAP (Security Content Automation Protocol): Automation of system hardening procedures required called for by STIGs.
- OpenSCAP: Open source tools which implement SCAP.



### Setup:
If not already installed with `Security Tools` package along with CentOS install:

`sudo yum install openscap-scanners scap-security-guide`

Check what content is available:

`ls /usr/share/xml/scap/ssg/content/`

You can look into the security profile:

`oscap info /usr/share/xml/scap/ssg/content/ssg-rhel7-ds.xml`

The output will look something like this:
```xml
[root@localhost ~]# oscap info /usr/share/xml/scap/ssg/content/ssg-rhel7-ds.xml
Document type: Source Data Stream
Imported: 2019-08-23T10:22:21

Stream: scap_org.open-scap_datastream_from_xccdf_ssg-rhel7-xccdf-1.2.xml
Generated: (null)
Version: 1.2
Checklists:
        Ref-Id: scap_org.open-scap_cref_ssg-rhel7-xccdf-1.2.xml
                Status: draft
                Generated: 2019-08-23
                Resolved: true
                Profiles:
                        Title: Health Insurance Portability and Accountability Act (HIPAA)
                                Id: xccdf_org.ssgproject.content_profile_hipaa
                        Title: DISA STIG for Red Hat Enterprise Linux 7
                                Id: xccdf_org.ssgproject.content_profile_stig-rhel7-disa
                        Title: OSPP - Protection Profile for General Purpose Operating Systems v. 4.2
                                Id: xccdf_org.ssgproject.content_profile_ospp42
                        Title: United States Government Configuration Baseline
                                Id: xccdf_org.ssgproject.content_profile_ospp
                        Title: Red Hat Corporate Profile for Certified Cloud Providers (RH CCP)
                                Id: xccdf_org.ssgproject.content_profile_rht-ccp
                        Title: VPP - Protection Profile for Virtualization v. 1.0 for Red Hat Enterprise Linux Hypervisor (RHELH)
                                Id: xccdf_org.ssgproject.content_profile_rhelh-vpp
                        Title: Criminal Justice Information Services (CJIS) Security Policy
                                Id: xccdf_org.ssgproject.content_profile_cjis
                        Title: PCI-DSS v3.2.1 Control Baseline for Red Hat Enterprise Linux 7
                                Id: xccdf_org.ssgproject.content_profile_pci-dss
                        Title: Standard System Security Profile for Red Hat Enterprise Linux 7
                                Id: xccdf_org.ssgproject.content_profile_standard
                        Title: Unclassified Information in Non-federal Information Systems and Organizations (NIST 800-171)
                                Id: xccdf_org.ssgproject.content_profile_nist-800-171-cui
                        Title: C2S for Red Hat Enterprise Linux 7
                                Id: xccdf_org.ssgproject.content_profile_C2S
                Referenced check files:
                        ssg-rhel7-oval.xml
                                system: http://oval.mitre.org/XMLSchema/oval-definitions-5
                        ssg-rhel7-ocil.xml
                                system: http://scap.nist.gov/schema/ocil/2
                        https://www.redhat.com/security/data/oval/com.redhat.rhsa-RHEL7.xml.bz2
                                system: http://oval.mitre.org/XMLSchema/oval-definitions-5
        Ref-Id: scap_org.open-scap_cref_ssg-rhel7-pcidss-xccdf-1.2.xml
                Status: draft
                Generated: 2019-08-23
                Resolved: true
                Profiles:
                        Title: PCI-DSS v3.2.1 Control Baseline for Red Hat Enterprise Linux 7
                                Id: xccdf_org.ssgproject.content_profile_pci-dss_centric
                Referenced check files:
                        ssg-rhel7-oval.xml
                                system: http://oval.mitre.org/XMLSchema/oval-definitions-5
                        ssg-rhel7-ocil.xml
                                system: http://scap.nist.gov/schema/ocil/2
                        https://www.redhat.com/security/data/oval/com.redhat.rhsa-RHEL7.xml.bz2
                                system: http://oval.mitre.org/XMLSchema/oval-definitions-5
Checks:
        Ref-Id: scap_org.open-scap_cref_ssg-rhel7-oval.xml
        Ref-Id: scap_org.open-scap_cref_ssg-rhel7-ocil.xml
        Ref-Id: scap_org.open-scap_cref_ssg-rhel7-cpe-oval.xml
        Ref-Id: scap_org.open-scap_cref_ssg-rhel7-oval.xml000
        Ref-Id: scap_org.open-scap_cref_ssg-rhel7-ocil.xml000
Dictionaries:
        Ref-Id: scap_org.open-scap_cref_ssg-rhel7-cpe-dictionary.xml
```
To select a scan profile, from the `oscap info` output, select a profile from the output.
The `Id` line is what will get used in the scan command.

From the last command, we'll be using:
```
Title: PCI-DSS v3.2.1 Control Baseline for Red Hat Enterprise Linux 7
                                Id: xccdf_org.ssgproject.content_profile_pci-dss
```

This is the command used for scanning with a selected profile and generating a `html` report named `report.html` in `/tmp`:

`oscap xccdf eval --profile xccdf_org.ssgproject.content_profile_pci-dss --report /tmp/report.html /usr/share/xml/scap/ssg/content/ssg-centos7-ds.xml`

You will get a long list of results:

```

Title   Ensure gpgcheck Enabled In Main yum Configuration
Rule    xccdf_org.ssgproject.content_rule_ensure_gpgcheck_globally_activated
Result  pass

Title   Enable GNOME3 Screensaver Idle Activation
Rule    xccdf_org.ssgproject.content_rule_dconf_gnome_screensaver_idle_activation_enabled
Result  notapplicable

Title   Set GNOME3 Screensaver Inactivity Timeout
Rule    xccdf_org.ssgproject.content_rule_dconf_gnome_screensaver_idle_delay
Result  notapplicable

Title   Implement Blank Screensaver
Rule    xccdf_org.ssgproject.content_rule_dconf_gnome_screensaver_mode_blank
Result  notapplicable

Title   Enable GNOME3 Screensaver Lock After Idle Period
Rule    xccdf_org.ssgproject.content_rule_dconf_gnome_screensaver_lock_enabled
Result  notapplicable

Title   Make sure that the dconf databases are up-to-date with regards to respective keyfiles
Rule    xccdf_org.ssgproject.content_rule_dconf_db_up_to_date
Result  notapplicable

Title   Ensure Logrotate Runs Periodically
Rule    xccdf_org.ssgproject.content_rule_ensure_logrotate_activated                                                                                        Result   fail

Title   Ensure Log Files Are Owned By Appropriate Group
Rule    xccdf_org.ssgproject.content_rule_rsyslog_files_groupownership
Result  pass

Title   Ensure Log Files Are Owned By Appropriate User
Rule    xccdf_org.ssgproject.content_rule_rsyslog_files_ownership
Result  pass

Title   Ensure System Log Files Have Correct Permissions
Rule    xccdf_org.ssgproject.content_rule_rsyslog_files_permissions                                                                                         Result   pass

Title   Install libreswan Package
Rule    xccdf_org.ssgproject.content_rule_package_libreswan_installed
Result  fail
```

### Resources:
http://static.open-scap.org/openscap-1.3/oscap_user_manual.html

### Todo:


- [x] Go over failing checks and make a list of essential configurations.

- ~~Compare with other STIG configurations~~

- ~~Find automatic STIG remediator~~

- [x] Write hardening script for identified essential configurations

        - Set up logging procedures
