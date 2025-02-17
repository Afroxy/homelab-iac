# Ansible Role Install OMV
A ansible role for openmediavault installation on a remote server running Debian.


## Prerequisites 
This role is working for [debian bullseye](https://www.debian.org/releases/bullseye/).

This role require debian is installed using the without any gui or web-server, only ssh with sudo privileges required. OMV will create the admin user in the installation process, so you do not need to create a user beforehand. 

This role depends on no other roles.

## Configuration
Manage the ovm version:
```
omv_version: sandworm
```

Repopulate database after first run, set:
```
omv_repopulate_db: true
```


## Next Steps
After you run the installation role:

Option 1:
* Open the browser to `http://ip/` and use the default credentials `admin:openmediavault` to login
* configure you nas as you desire

Option 2:
* Use my ansible role ????? to configure OMV with ansible


## License:
This project is licensed under the MIT License - see [License.md](LICENSE) for details.

## Acknowledgments
This ansible role was inspired by [Stefano Prina’s](https://github.com/stethewwolf) repo [ansible-role-omv](https://github.com/stethewwolf/ansible-role-omv) and heavily adapted to work with OMV 7 (Sandworm).

## References
* [OpenMediaVault](https://openmediavault.org)
* [OpenMediaVault - Debian installation](https://docs.openmediavault.org/en/stable/installation/on_debian.html)

