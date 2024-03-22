locals {
  cap_volumes       = lookup(local.capabilities, "volumes", [])
  cap_volume_mounts = lookup(local.capabilities, "volume_mounts", [])

  volume_mounts = {
    for vm in local.cap_volume_mounts : vm.name =>
    {
      name              = vm.name
      mount_path        = vm.mount_path
      mount_propagation = lookup(vm, "mount_propagation", null)
      sub_path          = lookup(vm, "sub_path", null)
      read_only         = tobool(lookup(vm, "read_only", null))
    }
  }

  volumes = {
    for v in local.cap_volumes : v.name =>
    {
      name                    = v.name
      persistent_volume_claim = jsondecode(lookup(v, "persistent_volume_claim", "null"))
      empty_dir               = jsondecode(lookup(v, "empty_dir", "null"))
    }
  }
}
