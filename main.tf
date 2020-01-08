

provider "google" {
  region      = "${var.region}"
  project     = "${var.project_name}"
  credentials = "${file("${var.credentials_file_path}")}"
}


resource "google_compute_instance" "etcdinstance1" {
  #count = 3

  name         = "etcd-1"
  machine_type = "${var.machine_type}"
  zone         = "${var.region_zone}"
  tags         = ["etcd-node"]

  boot_disk {
    initialize_params {
      image = "centos-7-v20191210"
      #image = "coreos-stable-2303-3-0-v20191203"
    }
  }

  network_interface {
    network = "default"

    access_config {
      # Ephemeral
    }
  }

  metadata = {
    ssh-keys = "ozal.bakmaz:${file("${var.public_key_path}")}"
    #startup-script = file("config.yml")
  }

 provisioner "file" {
		source      = "script.sh"
		destination = "/tmp/script.sh"
    
	}
 provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/script.sh",
      "/tmp/script.sh",
    ]
  }

connection {
      #host        = "tf-docker-${count.index}"
      host        = "${google_compute_instance.etcdinstance1.network_interface[0].access_config[0].nat_ip}"
      type        = "ssh"
      #user        = "terraform"
      user        = "ozal.bakmaz"
      private_key = "${file("${var.private_key_path}")}"
      agent       = false
    }
  service_account {
    scopes = ["https://www.googleapis.com/auth/compute.readonly"]
  }
}

#2
resource "google_compute_instance" "etcdinstance2" {
  

  name         = "etcd-2"
  machine_type = "${var.machine_type}"
  zone         = "${var.region_zone}"
  tags         = ["etcd-node"]

  boot_disk {
    initialize_params {
      image = "centos-7-v20191210"
      #image = "coreos-stable-2303-3-0-v20191203"
    }
  }

  network_interface {
    network = "default"

    access_config {
      # Ephemeral
    }
  }

  metadata = {
    ssh-keys = "ozal.bakmaz:${file("${var.public_key_path}")}"
    #startup-script = file("config.yml")
  }

 provisioner "file" {
		source      = "script.sh"
		destination = "/tmp/script.sh"
    
	}
 provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/script.sh",
      "/tmp/script.sh",
    ]
  }

connection {
      #host        = "tf-docker-${count.index}"
      host        = "${google_compute_instance.etcdinstance2.network_interface[0].access_config[0].nat_ip}"
      type        = "ssh"
      #user        = "terraform"
      user        = "ozal.bakmaz"
      private_key = "${file("${var.private_key_path}")}"
      agent       = false
    }
  service_account {
    scopes = ["https://www.googleapis.com/auth/compute.readonly"]
  }
}

#3

resource "google_compute_instance" "etcdinstance3" {
  #count = 3

  name         = "etcd-3"
  #machine_type = "f1-micro"
  machine_type = "${var.machine_type}"
  zone         = "${var.region_zone}"
  tags         = ["etcd-node"]

  boot_disk {
    initialize_params {
      #image = "centos-7-v20191210"
      image = "${var.os_image}"
      
    }
  }

  network_interface {
    network = "default"

    access_config {
      # Ephemeral
    }
  }

  metadata = {
    ssh-keys = "ozal.bakmaz:${file("${var.public_key_path}")}"
    #startup-script = file("config.yml")
  }

 provisioner "file" {
		source      = "script.sh"
		destination = "/tmp/script.sh"
    
	}
 provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/script.sh",
      "/tmp/script.sh",
    ]
  }

connection {
      #host        = "tf-docker-${count.index}"
      host        = "${google_compute_instance.etcdinstance3.network_interface[0].access_config[0].nat_ip}"
      type        = "ssh"
      #user        = "terraform"
      user        = "ozal.bakmaz"
      private_key = "${file("${var.private_key_path}")}"
      agent       = false
    }
  service_account {
    scopes = ["https://www.googleapis.com/auth/compute.readonly"]
  }
}

resource "google_compute_firewall" "default" {
  name    = "tf-www-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80","2379","2378"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["etcd-node"]
}


/* output "name" {

  value = "${google_compute_instance.docker[0].name}"
}

output "ip" {

  value = "${google_compute_instance.docker[0].network_interface[0].access_config[0].nat_ip}"
} */