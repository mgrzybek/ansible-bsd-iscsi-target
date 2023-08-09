# ansible-bsd-iscsi-target

This role creates zpools and publishes zvolumes through iSCSI.

## Requirements

- A FreeBSD based system
- Enough disks to create some storage zpools

## Role Variables

Default variables:

```yaml

# By default, we do not monitorservices using consul
bsd_iscsi_target_config_consul: false

# Path oh the consul configuration files
bsd_iscsi_target_consul_services_path: /usr/local//etc/consul.d

# Description of the services to monitor
bsd_iscsi_target_consul:
- service:
    name: "ctld"
    tags: [ "iscsi" ]
    port: 3260
    checks:
    - args: [ "service", "ctld", "status" ]
      interval: "60s"
```

Main variables to set:

```yaml
bsd_iscsi_target:
  target_iqn:  # IQN of the targets as explained there: https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.vsphere.storage.doc/GUID-686D92B6-A2B2-4944-8718-F1B74F6A2C53.html
  zpools:
  - name:       # Name of the zpool
    arrays:     # List of arrays within the zpool
    - type:     # Type of redondancy (raidz, raidz2, mirror… on nothing for stripe)
      disks: [] # A list of disks to use
```

## Dependencies

N.A.

## Example Playbook

- Create two raidz2-based zpools using NVMe and HDD devices.
- Create two zvolumes using these zpools.

``` yaml
- hosts: servers
  vars:
    bsd_iscsi_target:
      target_iqn: iqn.2023-08.com.example
      zpools:
      - name: nvme
        arrays:
        - type: raidz2
          disks:
          - /dev/nda0
          - /dev/nda1
          - /dev/nda2
          - /dev/nda3
      - name: hdd
        arrays:
        - type: raidz2
          disks:
          - /dev/da0
          - /dev/da1
          - /dev/da2
          - /dev/da3

      zvolumes:
      - pool: nvme
        name: minio-hot
        size: 2T
      - pool: hdd
        name: minio-cold
        size: 20T

  roles:
  - role: ansible-bsd-iscsi-target
```
