#!/bin/bash
# For Debian/Ubuntu/Mint add repository
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
# Install
export GITLAB_RUNNER_DISABLE_SKEL=true; sudo -E apt-get install -y gitlab-runner
sudo gitlab-runner restart
echo "Файл сервиса runner (сделать запуск от root)"
echo "sudo nano /etc/systemd/system/gitlab-runner.service"
echo "sudo systemctl daemon-reload"
echo "sudo gitlab-runner restart"
