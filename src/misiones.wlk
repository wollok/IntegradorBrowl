class MisionImposibleException inherits Exception(message = "Misión no puede comenzar"){}

class Personaje {
	var copas
	
	method copas() = copas
	
	method recibirCopas(cantidad) {
		copas += cantidad
	}
}


class Arquero inherits Personaje{
	var agilidad
	var rango
	
	method destreza() = agilidad * rango
	
	method tieneEstrategia() = rango > 100
}

class Ballestero inherits Arquero{
	override method destreza() = super() * 2
}

class Guerrera inherits Personaje{
	var fuerza
	var property tieneEstrategia
	
	method destreza() = fuerza *1.5 
}

class Mision{
	var modoPremiacion = new Boost(multiplicador = 2)

	method puedeSerSuperada() = self.destrezaSuficiente() || self.estrategiaSuficiente()
	
	method destrezaSuficiente() 
	method estrategiaSuficiente() 

	method repartirCopas() {
		self.validar() 
		self.premiar(self.cantidadDeCopas()* if(self.puedeSerSuperada()) 1 else -1)
//		if (self.puedeSerSuperada())
//			self.premiar(self.cantidadDeCopas())
//		else
//			self.premiar(-self.cantidadDeCopas())
	}
	
	method validar() {
		if (self.noPuedeComenzar())
			throw new MisionImposibleException()
	}
	
	method premiar(cantidad) 
	method noPuedeComenzar()
	
	method cantidadDeCopas() =	modoPremiacion.cantidadCopas(self)
}

class MisionIndividual inherits Mision{
	var personaje
	var dificultad
	
	override method premiar(cantidad) {
		personaje.recibirCopas(cantidad)
	}
		
	method copasBasicas() = dificultad * 2
	
	method cantParticipantes() = 1
	
	override method destrezaSuficiente() = personaje.destreza() > dificultad
	
	override method estrategiaSuficiente() = personaje.tieneEstrategia()
	
	override method noPuedeComenzar() = personaje.copas() < 10
}

class MisionEquipo inherits Mision{
	const personajes = []

	override method premiar(cantidad) {
		personajes.forEach{p => p.darCopas(cantidad)}
	}

	method copasBasicas() = 50 / self.cantParticipantes()
	
	override method estrategiaSuficiente() 
		= self.estrategiaTotal() > self.cantParticipantes() /2
		
	method estrategiaTotal() =
			personajes.count{p=> p.tieneEstrategia()}

	method cantParticipantes() = personajes.size()
		
	override method destrezaSuficiente() = personajes.all{p=>p.destreza() > 400}

	override method noPuedeComenzar() = personajes.sum{p=> p.copas()} < 60
}

object comun {
	method cantidadCopas(mision) = mision.copasBasicas()
}

class Boost {
	var multiplicador 
	method cantidadCopas(mision) = multiplicador * mision.copasBasicas()  
}

object bonus {
	method cantidadCopas(mision) = mision.cantParticipantes() + mision.copasBasicas()
}