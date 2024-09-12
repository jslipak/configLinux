vim.opt.backup = false -- crea una copia de respaldo
vim.opt.clipboard = "unnamedplus" -- permite a neovim tener acceso al portapapeles del sistema
vim.opt.cmdheight = 1 -- más espacio en la línea de comandos de neovim para mostrar mensajes
vim.opt.colorcolumn = "99999" -- arregla la línea de identación por ahora
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.conceallevel = 0 -- para que `` sea visible en los archivos de markdown
vim.opt.fileencoding = "utf-8" -- la codificación escrita a un archivo
vim.opt.guifont = "monospace:h17" -- la fuente usada para aplicaciones graficas de neovim
vim.opt.hidden = true -- necesario para guardar y abrir multiples buffers
vim.opt.hlsearch = true -- resalta todas las coincidencias de la busqueda por patron anterior
vim.opt.ignorecase = true -- ignora entre mayúsculas y minusculas durante las busquedas por patron
vim.opt.mouse = "a" -- permite user el mouse dentro de neovim
vim.opt.pumheight = 10 -- cambia el alto del menu emergente
vim.opt.showmode = false -- no necesitamos ver cosas como -- INSERT -- nunca más
vim.opt.smartcase = true -- habilita el modo inteligente de identificación para patrones con mayúsculas y minusculas
vim.opt.smartindent = true -- habilita el modo de identación inteligente
vim.opt.splitbelow = true -- fuerza todas las divisiones horizontales a ir debajo de la ventana actual
vim.opt.splitright = true -- fuerza todas las divisiones verticales a ir a la derecha de la ventana actual
vim.opt.swapfile = false -- crea un archivo de intercambio
vim.opt.termguicolors = true -- habilita una gama de colores extendida (la mayoria de terminales soportan esto)
vim.opt.timeoutlen = 100 -- tiempo a esperar para que se complete el mapeo de una secuencia (en milisegundos)
vim.opt.title = true -- establece el titulo de la ventan al valor de titlestring
vim.opt.titlestring = "%<%F%=%l/%L - nvim" -- patrón para colocar el valor del titulo de la ventana
vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"
vim.opt.undofile = true -- habilita el deshacer con persistencia
vim.opt.updatetime = 300 -- completado más rapido
vim.opt.writebackup = false -- si un archivo se comienza a editar por otro programa (o se modifica por otro programa) entonces no se permite realizar esta edición
vim.opt.expandtab = true -- convierte tabs a espacios
vim.opt.shiftwidth = 2 -- el numero de espacios que se agregan en una identación
vim.opt.tabstop = 2 -- inserta 2 espacios por cada tab
vim.opt.cursorline = true -- resalta la línea actual
vim.opt.cursorcolumn = false -- resalta la Columna actual
vim.opt.number = true -- activa las líneas enumeradas
vim.opt.relativenumber = false -- activa los numeros relativos a la línea actual
vim.opt.numberwidth = 4 -- establece el ancho de una columna a 4
vim.opt.signcolumn = "yes" -- siempre muestra el signo de la columna, de lo contrario, cambiaría el texto en cada línea
vim.opt.wrap = false -- muestra las líneas como una sola línea larga
vim.opt.spell = false
vim.opt.spelllang = "es" -- importante para editar escritos en español
vim.opt.scrolloff = 8 -- cambia la cantidad de líneas del scroll
vim.opt.sidescrolloff = 8
vim.opt.showmatch = true
vim.opt.completeopt = { "menu", "menuone", "noselect" }
-- vim.wo.relativenumber = true

if vim.g.vscode then
-- VSCode extension
else
	--vim.cmd.colorscheme("kanagawa-wave")
	-- Python3 Virtual Environment one for Mac and other for Linux
if vim.fn.has("mac") == 1 then
   vim.g.python3_host_prog = "/opt/homebrew/bin/python3.9"
   vim.g.python_host_prog = "/opt/homebrew/bin/python3.9"
else
   vim.g.python3_host_prog = "/bin/python"
   vim.g.python_host_prog = "/bin/python"
end

	-- Codi configuration
	vim.g.codi_virtual_text = 0
	vim.g.codi_width = 20
	vim.g.codi_rightsplit = 0
	vim.g.codi_rightalign = 0

	-- Comment in the same buffer
	-- vim.g.codi_virtual_text_prefix = '🎯➔'
	-- vim.g.codi_virtual_text_pos = 60
end
