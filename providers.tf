provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "staging"
  region = var.region_staging
}

provider "aws" {
  alias  = "internal"
  region = var.region_internal
}

provider "aws" {
  alias  = "production"
  region = var.region_production
}
