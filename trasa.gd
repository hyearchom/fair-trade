class_name Trasa
extends Node

@export_category('Podminka')
#@export var telo: Node
@export var cesta: Curve3D: set = nastaveni
var vychozi_pozice: Vector3
#var pozice: Vector3

var prubeh: float
var cileny_prubeh: float
var smer := int(1)
@export_category('Moznosti')
@export var rychlost := float(1.5)

var zacykleni: Array
@export_range(1, 99) var delitel_zastavky = int(2)

signal cesta_zvolena
signal zacatek_pohybu
signal zmena_smeru
signal konec_pohybu

func nastaveni(krivka):
	if not vychozi_pozice:
		vychozi_pozice = owner.global_transform.origin
	cesta = krivka
	emit_signal("cesta_zvolena")

func _ready():
	aktivace_pohybu(false)

func presun(konec: float, zacatek: float = cileny_prubeh):
	await overit_cestu()
	prubeh = zacatek
	cileny_prubeh = konec
	urceni_smeru(zacatek, konec)
	aktivace_pohybu(true)

func overit_cestu():
	if not cesta:
		await cesta_zvolena

func urceni_smeru(zacatek, konec):
	if zacatek < konec:
		smer = 1
	else:
		smer = -1
	emit_signal("zmena_smeru", smer)

func smycka():
	await overit_cestu()
	zacykleni = [cesta.point_count -1, 0]
	while zacykleni:
		for bod in zacykleni:
			if zacykleni:
				presun(bod)
				await konec_pohybu

func aktivace_pohybu(stav):
	set_physics_process(stav)
	match stav:
		true:
			emit_signal('zacatek_pohybu')
		false:
			emit_signal('konec_pohybu')

func _physics_process(delta):
	prubeh += rychlost *smer *delta
	owner.position = ziskat_pozici()
	overit_konec()

func ziskat_pozici():
	return vychozi_pozice + cesta.samplef(prubeh)

func overit_konec():
	if abs(cileny_prubeh -prubeh) < 0.01:
		#printt(cileny_prubeh, prubeh)
		aktivace_pohybu(false)

func zastavit():
	var nejblizsi_bod
	match smer:
		1:
			nejblizsi_bod = ceili(prubeh)
		-1:
			nejblizsi_bod = floori(prubeh)
	cileny_prubeh = snapped(nejblizsi_bod, delitel_zastavky)
	zacykleni.clear()

func nahle_zastavit():
	zacykleni.clear()
	aktivace_pohybu(false)
	
