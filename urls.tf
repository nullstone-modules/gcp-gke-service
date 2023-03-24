locals {
  // Private and public URLs are shown in the Nullstone UI
  // Typically, they are created through capabilities attached to the application
  // If this module has URLs, add them here as list(string)
  additional_private_urls = []
  additional_public_urls  = []

  private_urls = concat([for url in try(local.capabilities.private_urls, []) : url["url"]], local.additional_private_urls)
  public_urls  = concat([for url in try(local.capabilities.public_urls, []) : url["url"]], local.additional_public_urls)
}

locals {
  uri_matcher = "^(?:(?P<scheme>[^:/?#]+):)?(?://(?P<authority>[^/?#]*))?"
}

locals {
  authority_matcher = "^(?:(?P<user>[^@]*)@)?(?:(?P<host>[^:]*))(?:[:](?P<port>[\\d]*))?"
  // These tests are here to verify the authority_matcher regex above
  // To verify, uncomment the following lines and issue "echo 'local.tests' | terraform console"
  /*
  tests = tomap({
    "nullstone.io" : regex(local.authority_matcher, "nullstone.io"),
    "brad@nullstone.io" : regex(local.authority_matcher, "brad@nullstone.io"),
    "brad:password@nullstone.io" : regex(local.authority_matcher, "brad:password@nullstone.io"),
    "nullstone.io:9000" : regex(local.authority_matcher, "nullstone.io:9000"),
    "brad@nullstone.io:9000" : regex(local.authority_matcher, "brad@nullstone.io:9000"),
    "brad:password@nullstone.io:9000" : regex(local.authority_matcher, "brad:password@nullstone.io:9000"),
  })
  */
}

locals {
  private_hosts = [for url in local.private_urls : lookup(regex(local.authority_matcher, lookup(regex(local.uri_matcher, url), "authority")), "host")]
  public_hosts  = [for url in local.public_urls : lookup(regex(local.authority_matcher, lookup(regex(local.uri_matcher, url), "authority")), "host")]
}
