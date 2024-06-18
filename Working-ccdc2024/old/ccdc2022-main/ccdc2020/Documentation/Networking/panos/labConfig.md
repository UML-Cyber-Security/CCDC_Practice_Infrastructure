Features:
- Three interfaces, inside, outside, and management
  - inside connects to the switch via rj45 to usb (`10.0.0.1`)
  - outside connects to the lab via regular rj45 (`192.168.7.224`, in additional to other service IPs)
  - management is on the host only adapter (`192.168.7.128`)
- Two security zones, inside and outside
- Management profile set to ping-only (only allows pings)
- Single virtual router with default route, destination `0.0.0.0/0`, on `ethernet1/1`, next-hop `192.168.7.254`
- Three security policies other than the default allowing outbound web from inside, outbound dns from the firewall, and inbound to different services
- NAT from inside to outside (Dynamic PAT), (`in-out-NAT`)
- NAT for the SSH service (Static PAT), (`out-in-SSH`)
- Syslog forwarding to `10.0.0.27`
- Management interface set send syslogs through `ethernet1/2`

```xml
<?xml version="1.0"?>
<config version="9.0.0" urldb="paloaltonetworks">
  <mgt-config>
    <users>
      <entry name="admin">
        <phash>$1$onyrohjk$9/Bfg03zJtUfKU5QTxfFK0</phash>
        <permissions>
          <role-based>
            <superuser>yes</superuser>
          </role-based>
        </permissions>
        <preferences>
          <saved-log-query>
            <traffic>
              <entry name="Lateral">
                <query>(zone.dst eq inside) and (zone.src eq inside)</query>
              </entry>
              <entry name="ssh-test">
                <query>(addr.src in 192.168.7.60)</query>
              </entry>
              <entry name="logger">
                <query>(addr.dst in 192.168.7.27)</query>
              </entry>
              <entry name="dropped traffic">
                <query>(rule eq interzone-default)</query>
              </entry>
            </traffic>
          </saved-log-query>
        </preferences>
      </entry>
    </users>
    <password-complexity>
      <enabled>yes</enabled>
      <minimum-length>8</minimum-length>
    </password-complexity>
  </mgt-config>
  <shared>
    <application/>
    <application-group/>
    <service/>
    <service-group/>
    <botnet>
      <configuration>
        <http>
          <dynamic-dns>
            <enabled>yes</enabled>
            <threshold>5</threshold>
          </dynamic-dns>
          <malware-sites>
            <enabled>yes</enabled>
            <threshold>5</threshold>
          </malware-sites>
          <recent-domains>
            <enabled>yes</enabled>
            <threshold>5</threshold>
          </recent-domains>
          <ip-domains>
            <enabled>yes</enabled>
            <threshold>10</threshold>
          </ip-domains>
          <executables-from-unknown-sites>
            <enabled>yes</enabled>
            <threshold>5</threshold>
          </executables-from-unknown-sites>
        </http>
        <other-applications>
          <irc>yes</irc>
        </other-applications>
        <unknown-applications>
          <unknown-tcp>
            <destinations-per-hour>10</destinations-per-hour>
            <sessions-per-hour>10</sessions-per-hour>
            <session-length>
              <maximum-bytes>100</maximum-bytes>
              <minimum-bytes>50</minimum-bytes>
            </session-length>
          </unknown-tcp>
          <unknown-udp>
            <destinations-per-hour>10</destinations-per-hour>
            <sessions-per-hour>10</sessions-per-hour>
            <session-length>
              <maximum-bytes>100</maximum-bytes>
              <minimum-bytes>50</minimum-bytes>
            </session-length>
          </unknown-udp>
        </unknown-applications>
      </configuration>
      <report>
        <topn>100</topn>
        <scheduled>yes</scheduled>
      </report>
    </botnet>
    <log-settings>
      <syslog>
        <entry name="default">
          <server>
            <entry name="logger">
              <transport>TCP</transport>
              <port>5000</port>
              <format>BSD</format>
              <server>10.0.0.27</server>
              <facility>LOG_USER</facility>
            </entry>
          </server>
        </entry>
      </syslog>
      <system>
        <match-list>
          <entry name="log forwarder">
            <send-syslog>
              <member>default</member>
            </send-syslog>
            <filter>All Logs</filter>
          </entry>
        </match-list>
      </system>
    </log-settings>
  </shared>
  <devices>
    <entry name="localhost.localdomain">
      <network>
        <interface>
          <ethernet>
            <entry name="ethernet1/1">
              <layer3>
                <ipv6>
                  <neighbor-discovery>
                    <router-advertisement>
                      <enable>no</enable>
                    </router-advertisement>
                  </neighbor-discovery>
                </ipv6>
                <ndp-proxy>
                  <enabled>no</enabled>
                </ndp-proxy>
                <ip>
                  <entry name="192.168.7.224"/>
                  <entry name="192.168.7.225"/>
                </ip>
                <lldp>
                  <enable>no</enable>
                </lldp>
                <interface-management-profile>ping-only</interface-management-profile>
              </layer3>
              <comment>out</comment>
            </entry>
            <entry name="ethernet1/2">
              <layer3>
                <ipv6>
                  <neighbor-discovery>
                    <router-advertisement>
                      <enable>no</enable>
                    </router-advertisement>
                  </neighbor-discovery>
                </ipv6>
                <ndp-proxy>
                  <enabled>no</enabled>
                </ndp-proxy>
                <lldp>
                  <enable>no</enable>
                </lldp>
                <ip>
                  <entry name="10.0.0.1"/>
                </ip>
                <interface-management-profile>ping-only</interface-management-profile>
                <units/>
              </layer3>
            </entry>
          </ethernet>
        </interface>
        <profiles>
          <monitor-profile>
            <entry name="default">
              <interval>3</interval>
              <threshold>5</threshold>
              <action>wait-recover</action>
            </entry>
          </monitor-profile>
          <interface-management-profile>
            <entry name="https-only">
              <https>yes</https>
            </entry>
            <entry name="ping-only">
              <ping>yes</ping>
            </entry>
          </interface-management-profile>
        </profiles>
        <ike>
          <crypto-profiles>
            <ike-crypto-profiles>
              <entry name="default">
                <encryption>
                  <member>aes-128-cbc</member>
                  <member>3des</member>
                </encryption>
                <hash>
                  <member>sha1</member>
                </hash>
                <dh-group>
                  <member>group2</member>
                </dh-group>
                <lifetime>
                  <hours>8</hours>
                </lifetime>
              </entry>
              <entry name="Suite-B-GCM-128">
                <encryption>
                  <member>aes-128-cbc</member>
                </encryption>
                <hash>
                  <member>sha256</member>
                </hash>
                <dh-group>
                  <member>group19</member>
                </dh-group>
                <lifetime>
                  <hours>8</hours>
                </lifetime>
              </entry>
              <entry name="Suite-B-GCM-256">
                <encryption>
                  <member>aes-256-cbc</member>
                </encryption>
                <hash>
                  <member>sha384</member>
                </hash>
                <dh-group>
                  <member>group20</member>
                </dh-group>
                <lifetime>
                  <hours>8</hours>
                </lifetime>
              </entry>
            </ike-crypto-profiles>
            <ipsec-crypto-profiles>
              <entry name="default">
                <esp>
                  <encryption>
                    <member>aes-128-cbc</member>
                    <member>3des</member>
                  </encryption>
                  <authentication>
                    <member>sha1</member>
                  </authentication>
                </esp>
                <dh-group>group2</dh-group>
                <lifetime>
                  <hours>1</hours>
                </lifetime>
              </entry>
              <entry name="Suite-B-GCM-128">
                <esp>
                  <encryption>
                    <member>aes-128-gcm</member>
                  </encryption>
                  <authentication>
                    <member>none</member>
                  </authentication>
                </esp>
                <dh-group>group19</dh-group>
                <lifetime>
                  <hours>1</hours>
                </lifetime>
              </entry>
              <entry name="Suite-B-GCM-256">
                <esp>
                  <encryption>
                    <member>aes-256-gcm</member>
                  </encryption>
                  <authentication>
                    <member>none</member>
                  </authentication>
                </esp>
                <dh-group>group20</dh-group>
                <lifetime>
                  <hours>1</hours>
                </lifetime>
              </entry>
            </ipsec-crypto-profiles>
            <global-protect-app-crypto-profiles>
              <entry name="default">
                <encryption>
                  <member>aes-128-cbc</member>
                </encryption>
                <authentication>
                  <member>sha1</member>
                </authentication>
              </entry>
            </global-protect-app-crypto-profiles>
          </crypto-profiles>
        </ike>
        <qos>
          <profile>
            <entry name="default">
              <class>
                <entry name="class1">
                  <priority>real-time</priority>
                </entry>
                <entry name="class2">
                  <priority>high</priority>
                </entry>
                <entry name="class3">
                  <priority>high</priority>
                </entry>
                <entry name="class4">
                  <priority>medium</priority>
                </entry>
                <entry name="class5">
                  <priority>medium</priority>
                </entry>
                <entry name="class6">
                  <priority>low</priority>
                </entry>
                <entry name="class7">
                  <priority>low</priority>
                </entry>
                <entry name="class8">
                  <priority>low</priority>
                </entry>
              </class>
            </entry>
          </profile>
        </qos>
        <virtual-router>
          <entry name="default">
            <protocol>
              <bgp>
                <enable>no</enable>
                <dampening-profile>
                  <entry name="default">
                    <cutoff>1.25</cutoff>
                    <reuse>0.5</reuse>
                    <max-hold-time>900</max-hold-time>
                    <decay-half-life-reachable>300</decay-half-life-reachable>
                    <decay-half-life-unreachable>900</decay-half-life-unreachable>
                    <enable>yes</enable>
                  </entry>
                </dampening-profile>
                <routing-options>
                  <graceful-restart>
                    <enable>yes</enable>
                  </graceful-restart>
                </routing-options>
              </bgp>
              <rip>
                <enable>no</enable>
              </rip>
              <ospf>
                <enable>no</enable>
              </ospf>
              <ospfv3>
                <enable>no</enable>
              </ospfv3>
            </protocol>
            <interface>
              <member>ethernet1/1</member>
              <member>ethernet1/2</member>
            </interface>
            <ecmp>
              <algorithm>
                <ip-modulo/>
              </algorithm>
            </ecmp>
            <routing-table>
              <ip>
                <static-route>
                  <entry name="Default route">
                    <path-monitor>
                      <enable>no</enable>
                      <failure-condition>any</failure-condition>
                      <hold-time>2</hold-time>
                    </path-monitor>
                    <nexthop>
                      <ip-address>192.168.7.254</ip-address>
                    </nexthop>
                    <bfd>
                      <profile>None</profile>
                    </bfd>
                    <interface>ethernet1/1</interface>
                    <metric>10</metric>
                    <destination>0.0.0.0</destination>
                    <route-table>
                      <unicast/>
                    </route-table>
                  </entry>
                </static-route>
              </ip>
            </routing-table>
          </entry>
        </virtual-router>
        <dhcp>
          <interface>
            <entry name="ethernet1/2">
              <server>
                <option>
                  <dns>
                    <primary>10.0.0.1</primary>
                  </dns>
                  <lease>
                    <timeout>60</timeout>
                  </lease>
                  <gateway>10.0.0.1</gateway>
                  <subnet-mask>255.255.255.0</subnet-mask>
                </option>
                <ip-pool>
                  <member>10.0.0.10-10.0.0.100</member>
                </ip-pool>
                <mode>auto</mode>
              </server>
            </entry>
          </interface>
        </dhcp>
        <dns-proxy>
          <entry name="forwarder">
            <cache>
              <max-ttl>
                <enabled>no</enabled>
              </max-ttl>
              <enabled>yes</enabled>
            </cache>
            <default>
              <primary>8.8.8.8</primary>
              <secondary>192.168.7.11</secondary>
            </default>
            <tcp-queries>
              <enabled>no</enabled>
            </tcp-queries>
            <interface>
              <member>ethernet1/2</member>
            </interface>
          </entry>
        </dns-proxy>
      </network>
      <deviceconfig>
        <system>
          <type>
            <dhcp-client>
              <send-hostname>yes</send-hostname>
              <send-client-id>no</send-client-id>
              <accept-dhcp-hostname>no</accept-dhcp-hostname>
              <accept-dhcp-domain>no</accept-dhcp-domain>
            </dhcp-client>
          </type>
          <update-server>updates.paloaltonetworks.com</update-server>
          <update-schedule>
            <threats>
              <recurring>
                <weekly>
                  <day-of-week>wednesday</day-of-week>
                  <at>01:02</at>
                  <action>download-only</action>
                </weekly>
              </recurring>
            </threats>
          </update-schedule>
          <timezone>America/New_York</timezone>
          <service>
            <disable-telnet>yes</disable-telnet>
            <disable-http>yes</disable-http>
            <disable-ssh>yes</disable-ssh>
          </service>
          <hostname>PA-VM</hostname>
          <route>
            <service>
              <entry name="syslog">
                <source>
                  <address>10.0.0.1</address>
                  <interface>ethernet1/2</interface>
                </source>
              </entry>
            </service>
          </route>
        </system>
        <setting>
          <config>
            <rematch>yes</rematch>
          </config>
          <management>
            <hostname-type-in-syslog>FQDN</hostname-type-in-syslog>
            <disable-predefined-reports>
              <member>spyware-infected-hosts</member>
              <member>top-application-categories</member>
              <member>top-technology-categories</member>
              <member>bandwidth-trend</member>
              <member>risk-trend</member>
              <member>threat-trend</member>
              <member>top-users</member>
              <member>top-attacker-sources</member>
              <member>top-attacker-destinations</member>
              <member>top-victim-sources</member>
              <member>top-victim-destinations</member>
              <member>top-attackers-by-source-countries</member>
              <member>top-attackers-by-destination-countries</member>
              <member>top-victims-by-source-countries</member>
              <member>top-victims-by-destination-countries</member>
              <member>top-sources</member>
              <member>top-destinations</member>
              <member>top-destination-countries</member>
              <member>top-source-countries</member>
              <member>top-connections</member>
              <member>top-ingress-interfaces</member>
              <member>top-egress-interfaces</member>
              <member>top-ingress-zones</member>
              <member>top-egress-zones</member>
              <member>top-applications</member>
              <member>top-http-applications</member>
              <member>top-rules</member>
              <member>top-attacks</member>
              <member>top-spyware-threats</member>
              <member>top-viruses</member>
              <member>top-vulnerabilities</member>
              <member>wildfire-file-digests</member>
              <member>top-websites</member>
              <member>top-url-categories</member>
              <member>top-url-users</member>
              <member>top-url-user-behavior</member>
              <member>top-blocked-websites</member>
              <member>top-blocked-url-categories</member>
              <member>top-blocked-url-users</member>
              <member>top-blocked-url-user-behavior</member>
              <member>blocked-credential-post</member>
              <member>unknown-tcp-connections</member>
              <member>unknown-udp-connections</member>
              <member>top-denied-sources</member>
              <member>top-denied-destinations</member>
              <member>top-denied-applications</member>
              <member>risky-users</member>
              <member>SaaS Application Usage</member>
              <member>gtp-events-summary</member>
              <member>gtp-malicious-wildfire-submissions</member>
              <member>gtp-security-events</member>
              <member>gtp-v1-causes</member>
              <member>gtp-v2-causes</member>
              <member>gtp-users-visiting-malicious-url</member>
              <member>top-gtp-attacker-destinations</member>
              <member>top-gtp-attacker-sources</member>
              <member>top-gtp-victim-destinations</member>
              <member>top-gtp-victim-sources</member>
              <member>sctp-error-causes</member>
              <member>sctp-events-summary</member>
              <member>sctp-security-events</member>
            </disable-predefined-reports>
          </management>
          <auto-mac-detect>yes</auto-mac-detect>
        </setting>
      </deviceconfig>
      <vsys>
        <entry name="vsys1">
          <application/>
          <application-group/>
          <zone>
            <entry name="outside">
              <network>
                <layer3>
                  <member>ethernet1/1</member>
                </layer3>
              </network>
            </entry>
            <entry name="inside">
              <network>
                <layer3>
                  <member>ethernet1/2</member>
                </layer3>
              </network>
            </entry>
          </zone>
          <service/>
          <service-group/>
          <schedule/>
          <rulebase>
            <nat>
              <rules>
                <entry name="out-in-SSH" uuid="40cf3eac-c7dc-48cf-aa74-144f962f1d91">
                  <destination-translation>
                    <translated-port>22</translated-port>
                    <translated-address>10.0.0.27</translated-address>
                  </destination-translation>
                  <to>
                    <member>outside</member>
                  </to>
                  <from>
                    <member>outside</member>
                  </from>
                  <source>
                    <member>any</member>
                  </source>
                  <destination>
                    <member>192.168.7.225</member>
                  </destination>
                  <service>any</service>
                </entry>
                <entry name="in-out-NAT" uuid="173ef7c8-1c4f-4941-a771-70fd7fc8d943">
                  <source-translation>
                    <dynamic-ip-and-port>
                      <interface-address>
                        <ip>192.168.7.224</ip>
                        <interface>ethernet1/1</interface>
                      </interface-address>
                    </dynamic-ip-and-port>
                  </source-translation>
                  <to>
                    <member>outside</member>
                  </to>
                  <from>
                    <member>inside</member>
                  </from>
                  <source>
                    <member>any</member>
                  </source>
                  <destination>
                    <member>any</member>
                  </destination>
                  <service>any</service>
                </entry>
              </rules>
            </nat>
            <security>
              <rules>
                <entry name="workstation-outbound-web" uuid="4be732b2-df13-43ee-92e9-17ef09deeb5e">
                  <to>
                    <member>outside</member>
                  </to>
                  <from>
                    <member>inside</member>
                  </from>
                  <source>
                    <member>any</member>
                  </source>
                  <destination>
                    <member>any</member>
                  </destination>
                  <source-user>
                    <member>any</member>
                  </source-user>
                  <category>
                    <member>any</member>
                  </category>
                  <application>
                    <member>any</member>
                  </application>
                  <service>
                    <member>service-http</member>
                    <member>service-https</member>
                  </service>
                  <hip-profiles>
                    <member>any</member>
                  </hip-profiles>
                  <action>allow</action>
                </entry>
                <entry name="firewall-outbound-dns" uuid="a6759475-6feb-442f-9f83-10181c383794">
                  <to>
                    <member>outside</member>
                  </to>
                  <from>
                    <member>inside</member>
                  </from>
                  <source>
                    <member>10.0.0.1</member>
                  </source>
                  <destination>
                    <member>8.8.8.8</member>
                    <member>192.168.7.11</member>
                  </destination>
                  <source-user>
                    <member>any</member>
                  </source-user>
                  <category>
                    <member>any</member>
                  </category>
                  <application>
                    <member>dns</member>
                  </application>
                  <service>
                    <member>application-default</member>
                  </service>
                  <hip-profiles>
                    <member>any</member>
                  </hip-profiles>
                  <action>allow</action>
                </entry>
                <entry name="services-inbound" uuid="dd744420-3ccc-48e0-b816-389bac2c4cba">
                  <to>
                    <member>inside</member>
                  </to>
                  <from>
                    <member>outside</member>
                  </from>
                  <source>
                    <member>any</member>
                  </source>
                  <destination>
                    <member>192.168.7.225</member>
                  </destination>
                  <source-user>
                    <member>any</member>
                  </source-user>
                  <category>
                    <member>any</member>
                  </category>
                  <application>
                    <member>ssh</member>
                  </application>
                  <service>
                    <member>application-default</member>
                  </service>
                  <hip-profiles>
                    <member>any</member>
                  </hip-profiles>
                  <action>allow</action>
                </entry>
              </rules>
            </security>
            <default-security-rules>
              <rules>
                <entry name="interzone-default" uuid="c36212b7-0776-4e6e-bc15-4390c8d27df8">
                  <action>drop</action>
                  <log-start>no</log-start>
                  <log-end>yes</log-end>
                  <log-setting>default</log-setting>
                </entry>
                <entry name="intrazone-default" uuid="ec4913b1-59d3-4d53-b1c4-dca201272b91">
                  <action>allow</action>
                  <log-start>no</log-start>
                  <log-end>yes</log-end>
                  <log-setting>default</log-setting>
                </entry>
              </rules>
            </default-security-rules>
          </rulebase>
          <address>
            <entry name="192.168.7.224">
              <ip-netmask>192.168.7.224/24</ip-netmask>
            </entry>
            <entry name="10.0.0.1">
              <ip-netmask>10.0.0.1/24</ip-netmask>
            </entry>
            <entry name="0.0.0.0">
              <ip-netmask>0.0.0.0/0</ip-netmask>
            </entry>
            <entry name="192.168.7.254">
              <ip-netmask>192.168.7.254/24</ip-netmask>
            </entry>
            <entry name="10.0.0.18">
              <ip-netmask>10.0.0.18</ip-netmask>
            </entry>
            <entry name="192.168.7.225">
              <ip-netmask>192.168.7.225</ip-netmask>
              <description>Single</description>
            </entry>
            <entry name="8.8.8.8">
              <ip-netmask>8.8.8.8</ip-netmask>
            </entry>
            <entry name="10.0.0.27">
              <ip-netmask>10.0.0.27</ip-netmask>
            </entry>
            <entry name="192.168.7.11">
              <ip-netmask>192.168.7.11</ip-netmask>
            </entry>
          </address>
          <import>
            <network>
              <interface>
                <member>ethernet1/1</member>
                <member>ethernet1/2</member>
              </interface>
            </network>
          </import>
          <log-settings>
            <profiles>
              <entry name="default">
                <match-list>
                  <entry name="traffic">
                    <send-syslog>
                      <member>default</member>
                    </send-syslog>
                    <log-type>traffic</log-type>
                    <filter>All Logs</filter>
                    <send-to-panorama>no</send-to-panorama>
                  </entry>
                </match-list>
              </entry>
            </profiles>
          </log-settings>
        </entry>
      </vsys>
    </entry>
  </devices>
</config>

```
