<h1>NixOS config</h1>

My configuration for cloud virtual machine. 

[See this for bootstrapping nixos on gce](https://nixos.wiki/wiki/Install_NixOS_on_GCE)


Obtain a NixOS ISO [here.](https://nixos.org/manual/nixos/stable/#sec-obtaining)

---

<h3>How to use (NixOS):</h3>

Clone my repo, and configure your ssh public key for the user.

First see [this](https://github.com/AdamCiuris/vm-nixos/blob/8d2895c35dd7178d3a06b3288de6b259e3cbd094/flake.nix#L46) line:

```nix
      nixosConfigurations = {
        "nixos" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
```

`"nixos"` is the host but it will be of the form if you create the nixos image with this [guide](https://nixos.wiki/wiki/Install_NixOS_on_GCE) `"INSTANCE.SERVER.PROJECT.internal"`. It will need to be changed, and it will need to be corrected to `"nixos"` after a `nixos-rebuild switch`.

---

Secondly do this: 

```bash
git clone git@github.com:AdamCiuris/vm-nixos.git && cd vm-nixos && bash link
```

`bash link` clears everything in your /etc/nixos and remakes.

---

Lastly do this: 

Use [Remmina](https://gitlab.com/Remmina/Remmina) to create an xrdp over ssh tunnel.

