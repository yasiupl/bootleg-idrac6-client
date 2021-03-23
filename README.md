# bootleg-idrac6-client
Remixed, M610-specific iDRAC 6 client

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
