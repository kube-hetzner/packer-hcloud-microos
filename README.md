# SuSE MicroOS image snapshot on Hetzner Cloud

Create an MicroOS-based snapshot on [Hetzner Cloud](https://www.hetzner.com/cloud) using [packer](https://www.packer.io).

## Installing

On macOS just use [brew](https://brew.sh):

```bash
brew install packer
```

For other OSes and more details see the [packer documentation](https://developer.hashicorp.com/packer).

## Building

Get an API token for your hcloud project (see [here](https://docs.hetzner.com/cloud/api/getting-started/generating-api-token/)) and run `packer build`.

```bash
export HCLOUD_TOKEN=<redacted>
packer build hcloud-microos-snapshot.pkr.hcl
```

The snapshot is created in your project and can then be used.

## Using the snapshot

You can refere to the snapshot by using it's ID.

```bash
# list the snapshot by using it's label
> hcloud image list -l microos-snapshot
ID         TYPE       NAME   DESCRIPTION        IMAGE SIZE   DISK SIZE   CREATED                        DEPRECATED
88945574   snapshot   -      microos-snapshot   0.38 GB      40 GB       Sat Nov 12 14:28:08 CET 2022   -

# retrieve just the ID 
> hcloud image list -o noheader -o "columns=id" -l microos-snapshot
88945574

# create a server based on this snapshot. Ensure you provide an SSH-Key as
# MicroOS does not allow login via password
> hcloud server create --image 88945574 --type cx21 --name MicroOS-test --ssh-key k3s
1m1s [===================================] 100.00%
Waiting for server 25527457 to have started
 ... done
Server 25527457 created
IPv4: 95.217.214.186
IPv6: 2a01:4f9:c010:3e1c::1
IPv6 Network: 2a01:4f9:c010:3e1c::/64

```
