
all:
	menu default <x href="velaxecute://ls" label=Open></x><x href="velaxecute://history -b 99 " label=Quit></x><x href="velafopen://about.vapp" label=About></x>
	menu velaxecute://ls <x href=ls label=Open></x><x href="velaxecute://history -b 99 " label=Quit></x><x href="velafopen://about.vapp" label=About></x>
	menu velafopen://about.vapp <x href="velaxecute://history -b 1" label=Back></x>
