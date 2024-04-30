<h1>NixOS config</h1>

My configuration for cloud virtual machine. 

[See this for bootstrapping nixos on gce](https://nixos.wiki/wiki/Install_NixOS_on_GCE)


Obtain a NixOS ISO [here.](https://nixos.org/manual/nixos/stable/#sec-obtaining)

---

<h3>How to use (NixOS):</h3>

Clone my repo, and configure your ssh public key for the user.

```bash
git clone git@github.com:AdamCiuris/vm-nixos.git && cd vm-nixos && bash link
```

`bash link` clears everything in your /etc/nixos and remakes.

Use [Remmina](https://gitlab.com/Remmina/Remmina) to create an xrdp over ssh tunnel.

