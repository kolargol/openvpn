# OpenVPN with ScrambleSuit and DNS
This ansible script will allow you to install from scratch your own OpenVPN server with scramblesuit and private DNS server within minutes. Level of knowledge required: **basic**
There is no bul**hit, no unessesery clunky software, it's based on OpenBSD, simple ansible playbook, easy as any kid can read. 
Once playbook finish, you have ready to use 2 archives with configs and all what is needed to connect to your VPN: one config is for Desktop Viscosity app and second for iPhone OpenVPN app (_ovpn_). You can easly create more keypairs/config for more users and adapt to your needs. Really simple, see below for usage.

## Why ?
Becouse other solutions are crap. So called "_private_" VPNs that are sold are no private - you let **unknown party** to watch _all_ your traffic, they sell it to Ad companies or do what they want with _your_ data. It's really stupid and people are unaware of this.
This playbook guaranetee that your data on transit are safe, server _do not_ store anything related with traffic or DNS queries, even in unlikely breach to your VPN server attacker wont be able to do anything that could harm your data (_of course once you realize server was pwned_). Read below why using VPN on your mobile and desktop is important.

## Security

ToDo

## My choose of cloud provider, apps and why

ToDo

## How to use playbook

Below simple requirements to run your own VPN server

#### Requirements
* have ansible installed on your computer
* have running newly created OpenBSD instance in some Cloud Provider (here we use ExoScale as stated above)
* basic knowledge of using terminal and ssh
* pretty much that's all

#### Steps to start your own OpenVPN server from ansible playbook:
* edit *private_vpn_inventory* and replace **IP_OF_YOUR_SERVER** with IP of your cloud server (easy?)
* run ansible with command: **ansible-playbook -i private_vpn_inventory openvpn.yml**
* after ansible finish without error your server is ready to use

get your configs, they are in
* **/etc/openvpn/export/archives/privateVPN-Desktop-JohnDoe.tar.gz** - this is for Viscosity DesktopApp
* **/etc/openvpn/export/archives/privateVPN-Mobile-JohnDoe.tar.gz** - this is for iPhone OpenVPN app

#### Client Configuration

ToDo

#### Customizations

ToDo

## Legal Warning

Remember: This do not give you privacy in internet, this playbook was made primarly to make connection to the internet more safe - especially on mobile devices. Certainty using VPN do not give you right to break law - when you do - no VPN can save you - you will be found and prosecuted according to the law. Don't be stupid, think and do wise things. Be repectfull for other people, do not be a jerk.

#### This doc is work-in-progress
