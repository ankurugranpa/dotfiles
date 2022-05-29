function venv {
	source venv/bin/activate
}
autoload -Uz venv

function  ygit {
	cd /mnt/e/yamadai/yamadai-2
	git add .
	git commit -m "update"
	git push origin mastar
	cd -
	echo "END"
}
autoload -Uz ygit
