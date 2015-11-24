#
# Cookbook Name:: chef-cookbook
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# zshの設定をclone
user = node["chef-repo"]["username"]
git "/home/#{user}/.zsh.d" do
    repository "https://github.com/okwrtdsh/zsh.git"
    reference "master"
    action :sync
    user "#{user}"
end

# vimの設定をclone
user = node["chef-repo"]["username"]
git "/home/#{user}/.vim" do
    repository "https://github.com/okwrtdsh/vim.git"
    reference "master"
    action :sync
    user "#{user}"
end

# とりあえずzsh, vimのインストール
%w{zsh vim}.each do |pkg|
    package pkg do
        action :install
    end
end

# zshの設定
execute "Set zshrc" do
    command "echo 'source ~/.zsh.d/zshrc' > /home/#{user}/.zshrc"
end
execute "Set zshenv" do
    command "echo 'source ~/.zsh.d/zshenv' > /home/#{user}/.zshenv"
end

# vimの設定
file "/home/#{user}/.vimrc" do
    content IO.read("/home/#{user}/.vim/vimrc")
end
file "/home/#{user}/.vimrc.local" do
    content IO.read("/home/#{user}/.vim/vimrc.local")
end

