job "db-esignsante_psc" {
	datacenters = ["${datacenter}"]
	type = "service"
	update {
			stagger = "30s"
			max_parallel = 1
	}
	vault {
		policies = ["esignsante_psc"]
		change_mode = "restart"
	}

	group "mongodb-server" {
		count = "1"
		# install only on "data" nodes
		constraint {
			attribute = "$\u007Bnode.class\u007D"
			value     = "data"
		}
		restart {
			attempts = 3
			delay = "60s"
			interval = "1h"
			mode = "fail"
		}
		network {
			port "db" { to = 27017 }
		}
		
		task "mongodb" {
			driver = "docker"
			config {
				image = "mongo"
				ports  = [ "db" ]
				volumes = [
					"name=esignsante_psc-mongodb, fs=xfs, io_priority=high, size=${esignsantepsc_mongodb_size}, repl=2:/data/db",
					"name=esignsante_psc-mongodb-config, fs=xfs, io_priority=high, size=1, repl=2:/data/configdb"
				]
				volume_driver = "pxd"
			}
		    template {
data = <<EOH
  MONGO_INITDB_ROOT_USERNAME=
  MONGO_INITDB_ROOT_PASSWORD=
EOH
			destination = "secrets/.env"
			env = true
		    }

			resources {
				cpu = 500
				memory = ${esignsantepsc_dbserver_mem_size}
			}
			service {
				name = "esignsante-psc-mongodb-server"
				port = "db"
				check {
					type = "tcp"
					port = "db"
					name = "check_mongodb"
					interval = "120s"
					timeout = "10s"
				}
				check_restart {
					limit = 3
					grace = "120s"
					ignore_warnings = true
				}
			}
		}
	}
}
