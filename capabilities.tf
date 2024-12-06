provider "ns" {
  capability_id = 11177
  alias         = "cap_11177"
}

module "cap_11177" {
  source  = "api.nullstone.io/nullstone/gcp-redis-access/any"
  version = "0.0.1"

  app_metadata = local.app_metadata

  providers = {
    ns = ns.cap_11177
  }
}
provider "ns" {
  capability_id = 11178
  alias         = "cap_11178"
}

module "cap_11178" {
  source  = "api.nullstone.io/nullstone/gcp-postgres-access/any"
  version = "0.0.3"

  app_metadata = local.app_metadata


  providers = {
    ns = ns.cap_11178
  }
}

module "caps" {
  source  = "nullstone-modules/cap-merge/ns"
  modules = local.modules
}

locals {
  modules      = [module.cap_11177, module.cap_11178]
  capabilities = module.caps.outputs

  cap_modules = [
    {
      id         = 11177
      namespace  = ""
      env_prefix = ""
      outputs    = module.cap_11177
    }
    , {
      id         = 11178
      namespace  = ""
      env_prefix = ""
      outputs    = module.cap_11178
    }
  ]
}

locals {
  cap_env_vars = merge([
    for mod in local.cap_modules : {
      for item in lookup(mod.outputs, "env", []) : "${mod.env_prefix}${item.name}" => item.value
    }
  ]...)

  cap_secrets = merge([
    for mod in local.cap_modules : {
      for item in lookup(mod.outputs, "secrets", []) : "${mod.env_prefix}${item.name}" => item.value
    }
  ]...)
}
