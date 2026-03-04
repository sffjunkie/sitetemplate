{
  disk0UUID,
  disk1UUID,
  disk2UUID,
  tank0Name ? "tank0",
  tank1Name ? "tank1",
  ...
}:
{
  disko.devices = {
    disk = {
      disk0 = {
        type = "disk";
        device = "/dev/disk/by-uuid/${disk0UUID}";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/mnt/boot";
                mountOptions = [
                  "defaults"
                ];
              };
            };
            primary = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "${tank0Name}";
              };
            };
          };
        };
      };
      disk1 = {
        type = "disk";
        device = "/dev/disk/by-uuid/${disk1UUID}";
        content = {
          type = "gpt";
          partitions = {
            primary = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "${tank1Name}";
              };
            };
          };
        };
      };
      disk2 = {
        type = "disk";
        device = "/dev/disk/by-uuid/${disk2UUID}";
        content = {
          type = "gpt";
          partitions = {
            primary = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "${tank1Name}";
              };
            };
          };
        };
      };
    };
    zpool = {
      "${tank0Name}" = {
        type = "zpool";
        datasets = {
          "${tank0Name}" = {
            type = "zfs_fs";
            options = {
              mountpoint = "none";
              compatibility = "grub2";
              ashift = 12;
              autotrim = "on";
              acltype = "posixacl";
              compression = "lz4";
              devices = "off";
              normalization = "formD";
              relatime = "on";
              xattr = "sa";
              checksum = "sha256";
            };
          };

          "${tank0Name}/root" = {
            type = "zfs_fs";
            mountpoint = "/mnt";
          };
          "${tank0Name}/nix" = {
            type = "zfs_fs";
            mountpoint = "/mnt/nix";

            options.mountpoint = "legacy";
            options."com.sun:auto-snapshot" = "true";
          };
        };
      };

      "${tank1Name}" = {
        type = "zpool";
        mode = "mirror";
        options = {
          ashift = "13";
          autotrim = "on";
        };
        datasets = {
          "${tank1Name}" = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };
        };
      };
    };
  };
}
