{
  disk0UUID,
  disk1UUID,
  tank0Name ? "tank0",
  ...
}:
{
  disko.devices = {
    disk = {
      sda = {
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
                pool = "tank0";
              };
            };
          };
        };
      };
      sdb = {
        type = "disk";
        device = "/dev/disk/by-uuid/${disk1UUID}";
        content = {
          type = "gpt";
          partitions = {
            primary = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "tank1";
              };
            };
          };
        };
      };
    };
    zpool = {
      tank0 = {
        type = "zpool";
        datasets = {
          "tank0" = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };
          "tank0/root" = {
            type = "zfs_fs";
            mountpoint = "/mnt";
          };
          "tank0/nix" = {
            type = "zfs_fs";
            mountpoint = "/mnt/nix";

            options.mountpoint = "legacy";
            options."com.sun:auto-snapshot" = "true";
          };
        };
      };

      tank1 = {
        type = "zpool";
        datasets = {
          "tank1/home" = {
            type = "zfs_fs";
            mountpoint = "/mnt/home";

            options.mountpoint = "legacy";
            options."com.sun:auto-snapshot" = "true";
          };
        };
      };
    };
  };
}
