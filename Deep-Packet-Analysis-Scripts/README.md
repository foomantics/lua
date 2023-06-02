# Deep-Packet-Analysis-Scripts
Lua scripts for extracting network data from PCAP files. The following are high-level descriptions of these scripts.
  
#### Classify_VLAN()
> Given a network flow with IPv4 addresses in a LAN, return the VLAN ID that each LAN IP address belongs to.
  
#### Code_Family()
> Given HTTP network flow, create a custom Elasticsearch field where the value classifies the family the status response code belongs to e.g. return 'success' for return codes '200', '201', ..., '299'.
  
#### Code_Lookup()
> Given HTTP network flow, create a custom Elasticsearch field where the value classifies the description registered by IETF Review of a status response code e.g. return 'OK' for status code '200'.

#### Display_Hosts()
> Given any network flow, extract the MAC addresses from the Ethernet header and return custom Elasticsearch fields where the values are the host name (not formally assigned) associated to the MAC addresses.	

#### DNSServer_Lookup()
> Given DNS network flow, create a custom Elasticsearch field where the value is the organization name associated with a public DNS server e.g. return 'Google' for '8.8.8.8'.

#### GeoIP_Lookup()
> Given any network flow, create custom Elasticsearch fields where the values are GeoIP outputs for public IPv4 addresses e.g. return 'US, United States' for '8.8.8.8'.

#### GeoReg_Lookup()
> Given any network flow, return a custom Elasticsearch field where the value is the broader subregion associated with a GeoIP lookup e.g. return 'Northern America' for 'US, United States'.

#### Is_EmotetQuery()
> Given DNS network flow, return an Elasticsearch event alarm if the second-level representation of the queried domain is 16 characters long and ends with a top level domain of 'eu' i.e. the Emotet query signature.

#### Is_PrivateIP()
> Given any network flow, create a custom Elasticsearch field where the value is a boolean string classifying the IPv4 addresses as either private or not private e.g. return 'true' for '10.0.0.1'.

#### Method_Lookup()
> Given HTTP network flow, create a custom Elasticsearch field where the value is a description of a HTTP request method e.g. return 'Request data from server with URL parameters.' for method request 'GET'.

#### OUI_Lookup()
> Given any network flow, create a custom Elasticsearch field where the value is the organizationally unique identifier (OUI) associated with the MAC addresses extracted from the Ethernet header e.g. return 'Dell Inc.' for MAC address '00:26:B9'.

#### Parse_DNSQuery()
> Given DNS network flow, create a custom Elasticsearch field where the value is the second-level representation of the default 'Query' field e.g. return 'example.com' for 'www.example.com'.

#### Port_Type()
> Given any network flow, return custom Elasticsearch fields where the values classify the source and destination port numbers e.g. '80' belongs to 'well_known' and '1024' belongs to 'registered'.

#### RegDate_Lookup()
> Given a domain in its second level representaiton e.g. 'google.com' create a custom metadata field for its associated registration date in the following format: '1997-09-15'.

#### ReservedIP_Lookup()
> Given a network flow with IP addresses in IPv4 format verifiy if source or destination IP addresses are included in the IANA IPv4 Special-Purpose Address Registry e.g. return 'multicast' for '224.0.0.251'.
