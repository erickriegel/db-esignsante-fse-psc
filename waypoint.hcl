project = "cybersante/db-esignsante-fse-psc"

labels = { "domaine" = "esignsante-fse-psc" }

runner {
    enabled = true
    data_source "git" {
        url = "https://github.com/erickriegel/db-esignsante-fse-psc"
        ref = "main"
    }
    poll {
        enabled = true
		interval = "24h"
    }
}

# An application to deploy.
app "cybersante/db-esignsante-fse-psc" {
    build {
        use "docker-pull" {
           image = "mongo"
		   tag = "latest"
        }
    }

	deploy {
		use "nomad-jobspec" {
			jobspec = templatefile("${path.app}/db-esignsante-fse-psc.nomad.tpl", {
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
