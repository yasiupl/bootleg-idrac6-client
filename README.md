# bootleg-idrac6-client
Remixed, M610-specific iDRAC ~~6~~ 5 client

## Prerequisites

1. Dell M1000e Blade Chassis
2. Any number of Dell PowerEdge M610 blade servers
3. Java7 OpenJDK installed on your managment PC

## Usage

### To connect directly:
```IDRAC_HOST=10.10.10.10 IDRAC_USER=root IDRAC_PASSWORD=calvin ./kvm.sh```

### To connect via proxy:

First run:

```./proxy.sh 10.10.10.10 jump.host.io```

In another terminal run:

```IDRAC_HOST=localhost:8000 IDRAC_USER=root IDRAC_PASSWORD=calvin ./kvm.sh```

### "No Free Slots Available" error
Just use the latest cookie from the cookies file, or run:

```IDRAC_HOST=10.10.10.10 IDRAC_USER=root IDRAC_PASSWORD=calvin COOKIE=$(tail -1 cookies) ./kvm.sh```

## How & Why?

If you have problem with your iDRAC version, try decompiling the firmware file using `binwalk` and extract any `sqashfs` partitions. One of them will contain the catalog structure (albeit with the files encrypted) of your specific iDRAC implementation. With this information you can try downloading the .jar files from the web panel, and run them using any of the already available scripts.

In the case of M610, the "iDRAC 6" is in fact iDRAC 5 .jars placed under Applications/dellUI/Java/release catalog.

## Sources / Inspirations

https://gist.github.com/TheJJ/2394cd76d3e2c34d02e3da1bd3e489b2

https://github.com/DomiStyle/docker-idrac6

https://github.com/Informatic/idrac-kvmclient
