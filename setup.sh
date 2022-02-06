#!/usr/bin/env bash -eu

read -p "Input git user.name: " git_user_name
git config --global user.name "${git_user_name}"

read -p "Input git user.email: " git_user_email
git config --global user.email "${git_user_email}"

echo "done"

rm $0
