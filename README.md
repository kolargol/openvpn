# OpenVPN with Scramblesuit and DNS server
This [ansible](http://docs.ansible.com/ansible/latest/intro_installation.html) script will allow you to install from scratch your own [OpenVPN](https://openvpn.net/index.php/open-source.html) server with [scramblesuit](https://www.cs.kau.se/philwint/scramblesuit/) and private [DNS](https://www.isc.org/downloads/bind/) server within minutes. Level of knowledge required: **basic**

There is no bul**hit, no unnecessary clunky software, it's based on [OpenBSD](http://www.openbsd.org), simple ansible playbook, easy as any kid can read. 
Once playbook finish, you have ready to use 2 archives with configs and all what is needed to connect to your VPN: one config is for Desktop Viscosity app and second for iPhone OpenVPN app (_ovpn_). You can easily create more keypairs/config for more users and adapt to your needs. Really simple, see below for usage.

## UDP branch
**If you do not care about paranoid privacy mode and internet speed is important to you, please check [udp-noscrable](https://github.com/kolargol/openvpn/tree/udp-noscramble) branch. UDP branch uses same security measures as master branch but remove scramblesuit and use much faster UDP mode**

**WARNING: scramblesuit is currently not maintained, please use [udp-noscrable](https://github.com/kolargol/openvpn/tree/udp-noscramble) instead. If you want to backport changes from udp-noscrable branch, please create pull request - should be fair easy.** 

## Why ?
Because other solutions are crap. So called "_private_" VPNs that are sold are no private - you let **unknown party** to watch _all_ your traffic, they sell it to Ad companies or do what they want with _your_ data. It's really stupid and people are unaware of this.
This playbook guarantee that your data on transit are safe, server _do not_ store anything related with traffic or DNS queries, even in unlikely breach to your VPN server attacker won't be able to do anything that could harm your data (_of course once you realize server was pwned_). Read below why using VPN on your mobile and desktop is important.

## Security

I am using Easy-RSA 3 to setup [PKI](https://en.wikipedia.org/wiki/Public_key_infrastructure), it's easy to manage (*see below*). [ECC](https://en.wikipedia.org/wiki/Elliptic_curve_cryptography) keypairs use *secp521r1* curve (*which is perhaps overkill, and you can safely lower it to more efficient secp256k1*), and RSA uses 2048 bit keys with SHA256 signatures. 

Mobile connections uses **DHE-RSA-AES256-SHA** TLS1.2 for control channel and **AES-256-CBC** for data encryption, also **HMAC** is used for packets authentication.

Desktop connections use **ECDHE-ECDSA-AES256-GCM-SHA384** TLS1.2 for control channel and **AES-256-GCM** for data encryption, in additions openvpn is configured to use **tls-crypt** with symmetric key for packet encryption and authentication.

Additionally *desktop* connections are wrapped with [scramblesuit](https://www.cs.kau.se/philwint/scramblesuit/) tunnel (*part of [Tor project](https://www.torproject.org)*) and although some say that's not needed when useing *tls-crypt* some think otherwise ;) ... anyway, this is how it is done here.

There are other settings that ensure connection is safe, like EKU, CA hash verification and others, see config for details. 

Last thing on the list is **DNS** server that is setup with this playbook. It's **Bind9** with [DNSSEC](https://en.wikipedia.org/wiki/Domain_Name_System_Security_Extensions) resolver enabled. This ensures that your queries do not leak to other providers and you always use legacy (*your own*) DNS server. I *do not use* Google DNS or other crap caching servers like OpenDNS (*who btw strip DNS records from DNSSEC signatures - which simply speaking can be seen as fraudulent itself...*). You can verify DNS leaks on site like: [https://www.dnsleaktest.com](https://www.dnsleaktest.com) and on [https://dnssec.vs.uni-due.de](https://dnssec.vs.uni-due.de) verify if DNSSEC resolver works as expected.

## IPv6 Support (DualStack)

This playbook configures IPv6 as [Dual-Stack](https://en.wikipedia.org/wiki/IPv6#Transition_mechanisms) setup - this means, if server supports IPv6 then you will be able to use IPv6 on your localhost. Although I am using DualStack since long time, this one is not well tested on OpenBSD by me. If you find any problems please report them in [Issues](https://github.com/kolargol/openvpn/issues) section.

Exoscale will support IPv6 at the end of 2017, but you can use IPv6 and this playbook also on: [Vultr](https://www.vultr.com/?ref=7207673) (*tested*), [Azure](https://azure.microsoft.com/en-us/), [AWS](https://aws.amazon.com) or any other cloud where OpenBSD 6.1 is.

## My choose of cloud provider, apps and why

For this playbook I have chosen [exoscale](https://www.exoscale.ch) as cloud provider (*but it will run on any OpenBSD you choose*). 
Why exoscale? Because it's Swiss, it's independent from US influences and obey only Swiss law, also they are nice and simply to use. Also their prices are quite low - or comparable to others like DigitalOcean or AWS. Performance of the single CPU core is sufficient for OpenVPN in [Micro](https://portal.exoscale.ch/register?r=gLrEOdv5hVgv) instance do not use anything bigger than that as long as you do not use it for over 10 users.

If you are going to use **exoscale** please use my **invite code** ( gLrEOdv5hVgv ), or [this link](https://portal.exoscale.ch/register?r=gLrEOdv5hVgv) - you will get **50 CHF** credit after *second* payment - that's amount that will let you use VPN server for free for next 5 months !!


For the desktop client side, i recommend using [Viscosity VPN](https://www.sparklabs.com/viscosity/) - no freebies here ;) - is it easy to use OpenVPN client that works on Windows and MacOS. It is well developed and uses recent openvpn client software.

If you are using iPhone, config is generated for free app [OpenVPN Connect](https://itunes.apple.com/pl/app/openvpn-connect/id590379981?l=pl&mt=8) - only one legacy app. I assume there are some apps for Android as well but i do not have one so cannot recommend any...

## Some cloud providers known to support OpenBSD

Here is list of cloud providers with support for OpenBSD:

* [Exoscale](https://portal.exoscale.ch/register?r=gLrEOdv5hVgv) (*tested*)
* [Vultr](https://www.vultr.com/?ref=7207673) (*tested*)
* [AWS](https://aws.amazon.com) (*works with eu-west-1 **ami-bc78bfc5** and us-east-1 ***ami-5845a022*** : made from [my recipe](https://github.com/kolargol/openbsd-aws)*)
* [Azure](https://azure.microsoft.com/en-us/) (*not tested*)
* [Tilaa](https://www.tilaa.com/en/vps-software) (*not tested*)
* [TransIP](https://www.transip.eu/vps/openbsd/) (*not tested*)
* [Ramnode](https://clientarea.ramnode.com/knowledgebase.php?action=displayarticle&id=48) (*not tested*)
* [Bytemark](https://www.bytemark.co.uk/cloud-hosting/) (*not tested*)


## How to use playbook

Below simple requirements to run your own VPN server

### Requirements
* have [ansible installed](http://docs.ansible.com/ansible/latest/intro_installation.html) on your computer
* have running **OpenBSD 6.1** instance in some cloud provider (*here we use [exoscale](https://portal.exoscale.ch/register?r=gLrEOdv5hVgv) as stated above*)
* allow SSH port 22 for install from your host, and permanently allow TCP 80 and 443 for VPN
* basic knowledge of using terminal and ssh
* pretty much that's all

### Steps to start your own OpenVPN server from ansible playbook:
* Download release from: https://github.com/kolargol/openvpn/tags (*you can also clone but releases are always tested and signed with [my gpg key](http://pgp.mit.edu/pks/lookup?op=vindex&search=0xE83413E79DB62E31), it is recommended way obtaining playbook*)
* edit *private_vpn_inventory* and replace **IP_OF_YOUR_SERVER** with IP of your cloud server (easy?)
* run ansible with command: **ansible-playbook -i private_vpn_inventory openvpn.yml**
* after ansible finish without error your server is ready to use

get your configs, they are in
* **/etc/openvpn/export/archives/privateVPN-Desktop-JohnDoe.tar.gz** - this is for Viscosity DesktopApp
* **/etc/openvpn/export/archives/privateVPN-Mobile-JohnDoe.tar.gz** - this is for iPhone OpenVPN app

you can use: *scp root@SERVER_IP:/etc/openvpn/export/archives/\* .* to copy config files all at once.

Once all is done, you can import above configs into your Viscosity app or/and iPhone OpenVPN app - no changes required all is already set. 

### Generating additional certificates for users

If more users are going to use OpenVPN then you need to generate new key-pairs (*each for each user*). This is simple to do and there are 2 ways of doing it:

* create ansible play - this is more advanced and i will not cover it here
* use **gen_config.sh**, steps below:

on the server, go to: */etc/openvpn/easy-rsa/* and type:

**./easyrsa --use-algo=rsa build-client-full privateVPN-Mobile-USERNAME nopass** - for *Mobile* client, note that part "privateVPN-Mobile-" should be unchanged in certificate name, just add proper USERNAME (*no spaces or crazy stuff here, just a-azA-Z*). *Mobile* is a keyword used later by script.

**./easyrsa --use-algo=ec --curve=secp521r1 build-client-full privateVPN-Desktop-USERNAME nopass** - for *Desktop* client, note that part "privateVPN-Desktop-" should be unchanged in certificate name, just add proper USERNAME, same as above - no crazy characters. *Desktop* is a keyword, do not change it.

**Note:** as you can see private keys are generated *without* password, you can password-protect them by removing **nopass** option. You will be asked for password and this is **recommended** way of generating keypair. I use nopass just for the convenience of the playbook. Also, for god sake **do not send keypairs via email or any other crazy way** without properly encrypting them, best - set password on key and wrap up by some gpg.

Once you understood all, let's generate packages with config, easy like 1,2,3...: go to: */etc/openvpn/export/* and for each user run: **./gen_config.sh privateVPN-Desktop-USERNAME** packages are put into *archives/* folder. Copy to localhosts, share, install, enjoy.

You can also use this crazy loop to create packages for all issued certificates:
```
ls -all /etc/openvpn/easy-rsa/pki/issued/privateVPN-* | cut -d/ -f 7 | cut -d. -f1 | while read cert; do ./gen_config.sh $cert; done
```

That's all. 


### Client Configuration

Desktop config creates **IPv4**: 172.17.200.0/24 and **IPv6**: fdd5:b0c4:f9fb:fa1f::/6 network, access on port 80

Mobile config creates **IPv4**: 172.16.200.0/24 and **IPv6**: fdd5:b0c4:f9fb:fa1e::/6 network, access on port 443

### Known issues and workarounds

#### DNS stop working after when OpenVPN process is restarted
This happens because DNS server process lose bind after openvpn is stopped. To fix this, after restarting OpenVPN process, restart bind with command **rcctl restart isc_named**

#### Ansible fails after waiting for instance restart
Sometimes instance take longer then 2 minutes to restart after applying erratas. Just reply ansible command/playbook or if problem persist alter timeout in playbok in restart task

### Customizations

ToDo

## Legal Warning

Remember: This do not give you privacy in internet, this playbook was made primarily to make connection to the internet more safe - especially on mobile devices. Certainty using VPN do not give you right to break law - when you do - no VPN can save you - you will be found and prosecuted according to the law. Don't be stupid, think and do wise things. Be respectful for other people, do not be a jerk.

#### This doc is work-in-progress
