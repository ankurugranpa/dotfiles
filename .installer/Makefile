NVIM_INSTALL_PATH = $(HOME)/dotfiles/mybin-local/bin
test.o:
	@echo "##########"
	@bash ./install_sh/echo.sh
	@echo "##########"

Ubuntu_x64_86: Buckup.o fzf.o zplug.o vim-plug.o Zsh_Ubuntu_x64_86.o
	@echo "##########"
	@echo "[install] start up app"
	@echo "[Finish] installed start up app"
	@echo "||||||||||"


Zsh_Ubuntu_x64_86.o: 
	@echo "##########"
	@echo "[install] install zsh"
	@bash ./install_sh/Zsh_Ubuntux64_86.sh
	@echo "[Finish] install zsh"
	@echo "||||||||||"


Buckup.o:
	@echo "##########"
	@echo "[Create] Buckup File"
	@bash ./install_sh/Backup.sh
	@echo "[Finish] Buckup File"
	@echo "||||||||||"

NeoVim:
	@echo "##########"
	@echo "[Install] NeoVim"
	@wget "https://github.com/neovim/neovim/archive/refs/tags/stable.tar.gz" \
	       	-O "nvim_install_file.tar.gz"
	@tar -zxvf "nvim_install_file.tar.gz"
	@rm -r "nvim_install_file.tar.gz"
	@echo "てすと"
	@make -f "neovim-stable/Makefile"\
		CMAKE_BUILD_TYPE=Release \
		CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$(HOME)/dotfiles/mybin-local/neovim" \
		&& sudo make -f "neovim-stable" install
	@rm -rf "neovim-stable"
	@echo "[Finish] NeoVim"
	@echo "NeoVim Installed PATH is $(HOME)/dotfiles/mybin-local/neovim"
	@echo "||||||||||"

fzf.o:
	# Install fzf	
	@echo "##########"
	@git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	@~/.fzf/install
	@echo "||||||||||"

zplug.o:
	# install zplug
	@echo "##########"
	@echo "[Install] zplug"
	@curl -sL --proto-redir -all,\
		https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
	@source $(HOME)/.zshrc
	@zplug install
	@echo "[Finish] zplug"
	@echo "||||||||||"

vim-plug: 
	# Install vim-plug
	@echo "[install] vim-plug"
	@curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	@echo "[Finish] vim-plug"
