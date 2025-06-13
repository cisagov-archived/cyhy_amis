build {
  sources = ["source.amazon-ebs.dashboard_x86_64"]

  provisioner "ansible" {
    galaxy_file            = "ansible/requirements.yml"
    galaxy_force_install   = var.force_install_ansible_requirements
    galaxy_force_with_deps = var.force_install_ansible_requirements_with_dependencies
    groups                 = ["dashboard"]
    playbook_file          = "ansible/upgrade.yml"
    use_proxy              = false
    use_sftp               = true
  }

  provisioner "ansible" {
    groups        = ["dashboard"]
    playbook_file = "ansible/python.yml"
    use_proxy     = false
    use_sftp      = true
  }

  provisioner "ansible" {
    ansible_env_vars = ["AWS_DEFAULT_REGION=${var.build_region}"]
    extra_arguments = [
      "--extra-vars",
      "cyhy_user_home_directory=${var.cyhy_user_information.home_directory}",
      "cyhy_user_ssh_public_key=${var.cyhy_user_information.ssh_public_key}",
      "cyhy_user_username=${var.cyhy_user_information.username}",
      "cyhy_user_uid=${var.cyhy_user_information.user_id}",
    ]
    groups        = ["cyhy_dashboard"]
    playbook_file = "ansible/playbook.yml"
    use_proxy     = false
    use_sftp      = true
  }
}
