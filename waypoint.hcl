project = "cybersante/db-esignsante-psc"

labels = { "domaine" = "esignsante-psc" }

runner {
    enabled = true
    data_source "git" {
        url = "https://github.com/ansforge/db-esignsante-psc"
        ref = "var.datacenter"
    }
    poll {
        enabled = true
		interval = "24h"
    }
}

# An application to deploy.
app "cybersante/db-esignsante-psc" {
    build {
        use "docker-pull" {
           image = "mongo"
		   tag = "latest"
        }
    }

	deploy {
		use "nomad-jobspec" {
			jobspec = templatefile("${path.app}/db-esignsante-psc.nomad.tpl", {
				datacenter = var.datacenter
				esignsantepsc_mongodb_size = var.esignsantepsc_mongodb_size
				esignsantepsc_dbserver_mem_size = var.esignsantepsc_dbserver_mem_size
			})
		}
	}
}

variable datacenter {
    type = string
    default = "test"
}

variable "esignsantepsc_mongodb_size" {
  type = string
  default = "3"
}

variable "esignsantepsc_dbserver_mem_size" {
  type = string
  default = "2048"
}