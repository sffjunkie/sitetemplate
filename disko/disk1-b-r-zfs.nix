# 1 disk
# - boot ESP vfat
# - `tank0Name` ZFS pool
#   containing
#   - root ZFS dataset
#   - nix ZFS dataset
#   - home ZFS dataset
{
  disk0UUID,
  tank0Name ? "tank0",
  nixDataset ? "${tank0Name}/nix",
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
                pool = "${tank0Name}";
              };
            };
          };
        };
      };
    };
    zpool = {
      "${tank0Name}" = {
        type = "zpool";

        options = {
          ashift = "13";
          autotrim = "on";
        };

        rootFsOptions = {
          atime = "off";
          relatime = "on";
          compression = "zstd";
          mountpoint = "none";
          dnodesize = "auto";
          acltype = "posix";
          xattr = "sa";
          "com.sun:auto-snapshot" = "false";
        };

        datasets = {
          "${tank0Name}" = {
            type = "zfs_fs";
          };
          "${tank0Name}/root" = {
            type = "zfs_fs";
            mountpoint = "/";
            options.mountpoint = "legacy";
          };
          "${nixDataset}" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options.mountpoint = "legacy";
          };
          "${tank0Name}/home" = {
            type = "zfs_fs";
            mountpoint = "/home";
            options.mountpoint = "legacy";
            options."com.sun:auto-snapshot" = "true";
          };
        };
      };
    };
  };
}
