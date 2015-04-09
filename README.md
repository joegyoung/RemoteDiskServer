# Macintosh Remote Disc Server


Ruby implication of Apple's Remote Disc 

## Installation 

```
bundler install
```

## Running

Non daemon Mode
 
```
thin start -p 55060 
```
Daemon Mode
 
```
thin start -p 55060 -d
```
 
## Linux

Ubuntu set up for bonjour

```
sudo aptitude install g++ ruby-dev  libavahi-compat-libdnssd-dev avahi-discover avahi-utils
```

## Subversion checkout for me

```
svn checkout "file:///Users/joeyoung/SYNC/SUBVERSION/RemoteDiskServer"
```

## Mount drive via command line

hdiutil mount http://10.0.6.22:55060/WinclonePro3.4.dmg




