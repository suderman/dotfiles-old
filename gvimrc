if has("gui_macvim")

  " Favourite font of the moment
  set guifont=monofur:h18

  " Enable option key
  set macmeta

  " MacVim shift+arrow-keys behavior
  let macvim_hig_shift_movement = 1

  " Only show MacVim right scrollbar
  set guioptions=r

  " Hide MacVim toolbar
  set guioptions-=T

 " GUI tabs
  set guioptions+=e

  " Grey menu items
  set guioptions+=g

  map <D-]> :bnext<CR>
  map <D-[> :bprev<CR>

  an 10.310 File.New\ File :NewFile <CR>
  macm File.New\ File key=<D-M-n>

  macmenu Edit.Find.Find\.\.\. key=<nop>
  map <D-f> /

  an 25 View.Project\ Drawer :maca openFileBrowser:<CR>
  macm View.Project\ Drawer key=<D-d>

  an 30 View.Go\ To\ File :CommandT<CR>
  macmenu &Edit.Find.Find\ Next key=<nop>
  macmenu View.Go\ To\ File key=<D-g>

  an 30 View.Buffer\ List :Buffers<CR>
  macmenu &Tools.Make key=<nop>
  macmenu View.Buffer\ List key=<D-b>

endif
