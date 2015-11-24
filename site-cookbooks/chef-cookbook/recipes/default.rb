#
# Cookbook Name:: chef-cookbook
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# とりあえずgit, zsh, vimのインストール
%w{git zsh vim}.each do |pkg|
    package pkg do
        action :install
    end
end

# gitの設定
user = node["chef-repo"]["username"]
execute "generate ssh skys for #{user}." do
  user user
  creates "/home/#{user}/.ssh/id_rsa.pub"
  command "ssh-keygen -t rsa -q -f /home/#{user}/.ssh/id_rsa -P \"\""
end

# zshの設定
user = node["chef-repo"]["username"]
git "/home/#{user}/.zsh.d" do
    repository "git://github.com/okwrtdsh/zsh.git"
    reference "master"
    action :sync
    user "#{user}"
end
execute "Set zshrc" do
    command "echo 'source ~/.zsh.d/zshrc' > /home/#{user}/.zshrc"
end
execute "Set zshenv" do
    command "echo 'source ~/.zsh.d/zshenv' > /home/#{user}/. zshenv"
end


# vimの設定
user = node["chef-repo"]["username"]
git "/home/#{user}/.vim" do
    repository "git://github.com/okwrtdsh/vim.git"
    reference "master"
    action :sync
    user "#{user}"
end
file "/home/#{user}/.vimrc" do
    content IO.read("/home/#{user}/.vim/vimrc")
end
file "/home/#{user}/.vimrc.local" do
    content IO.read("/home/#{user}/.vim/vimrc.local")
end

