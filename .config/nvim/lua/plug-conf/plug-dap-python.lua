local venv = os.getenv('VIRTUAL_ENV')
command = string.format('%s/bin/python', venv)

require('dap-python').setup(command)
