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
git "/home/#{user}/.vim" do
    repository "https://github.com/okwrtdsh/vim.git"
    reference "master"
    action :sync
    user "#{user}"
end

# zsh, vimのインストール
%w{zsh vim}.each do |pkg|
    package pkg do
        action :install
    end
end

# zshrc, zshenvの設置
execute "set zshrc" do
    command "echo 'source ~/.zsh.d/zshrc' > /home/#{user}/.zshrc"
end
execute "set zshenv" do
    command "echo 'source ~/.zsh.d/zshenv' > /home/#{user}/.zshenv"
end


# vimrc vimrc.localを設置
execute "set vimrc" do
    command "cp /home/#{user}/.vim/vimrc /home/#{user}/.vimrc"
end
execute "set vimrc.local" do
    command "cp /home/#{user}/.vim/vimrc.local /home/#{user}/.vimrc.local"
end

# ubuntuのみ適用
if node['platform'] == 'ubuntu'
    %w{guake pgadmin3}.each do |pkg|
        package pkg do
            action :install
        end
    end
    # ホームディレクトリ以下を英語に
    bash "change Japanese directory name" do
        cwd "/home/#{user}"
        user "#{user}"
        code <<-EOC
            LANG=C xdg-user-dirs-update --force
            rm -rf テンプレート ドキュメント ピクチャ 公開 ダウンロード デスクトップ ビデオ ミュージック
        EOC
        only_if {File.exists?("/home/#{user}/デスクトップ") }
    end
end

