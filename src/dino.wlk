import wollok.game.*
    
//añadir màs teclas u objetos al juego, nuevos objetos que colisionen, frenar el reloj, etc.

const velocidad = 250

object juego{

	method configurar(){
		game.width(12)
		game.height(8)
		game.title("Dino Game")
		game.addVisual(suelo)
		game.addVisual(cactus)
		game.addVisual(pterodactilo)
		game.addVisual(dino)
		game.addVisual(reloj)
		game.addVisual(puntos)
	
		keyboard.space().onPressDo{ self.jugar()}
		keyboard.f().onPressDo{ game.say(dino, "roarrr")}
		//bloques, encerrar un objeto entre llaves guarda el objeto para cuando la tecla es presionada, 
		//se usa para acciones que no se desea ejectuar aùn
		
		game.onCollideDo(dino,{ obstaculo => obstaculo.chocar()})
		
	} 
	
	method iniciar(){
		dino.iniciar()
		reloj.iniciar()
		cactus.iniciar()
		pterodactilo.iniciar()
	}
	
	method jugar(){
		if (dino.estaVivo()) 
			dino.saltar()
		else {
			game.removeVisual(gameOver)
			self.iniciar()
		}
		
	}
	
	method terminar(){
		game.addVisual(gameOver)
		cactus.detener()
		reloj.detener()
		dino.morir()
	}
	
}

object gameOver {
	method position() = game.center()
	method text() = "GAME OVER"
	

}

object reloj {
	
	var tiempo = 0
	
	method text() = tiempo.toString()
	method position() = game.at(1, game.height()-1)
	
	method pasarTiempo() {
		tiempo = tiempo +1
	}
	method iniciar(){
		tiempo = 0
		game.onTick(100,"tiempo",{self.pasarTiempo()})
	}
	
	method tiempoActual() {
		return tiempo
	}
	
	method detener(){
		game.removeTickEvent("tiempo")
	}
	
}

object cactus {
	 
	var position = self.posicionInicial()

	method image() = "cactus.png"
	method position() = position
	
	method posicionInicial() = game.at(game.width()-1,suelo.position().y())

	method iniciar(){
		position = self.posicionInicial()
		game.onTick(velocidad,"moverCactus",{self.mover()})
	}
	
	method mover(){
		position = position.left(1)
		if (position.x() == -1)
			position = self.posicionInicial()
	}
	
	method chocar(){
		juego.terminar()
	}
    method detener(){
		game.removeTickEvent("moverCactus")
	}
}

object pterodactilo {
	 
	var position = self.posicionInicial()

	method image() = "pterodactilo.png"
	method position() = position
	
	method posicionInicial() = game.at(game.width()-2,suelo.position().y())

	method iniciar(){
		position = self.posicionInicial()
		game.onTick(velocidad,"moverPterodactilo",{self.mover()})
	}
	
	method mover(){
		position = position.left(2)
		if (position.x() == -2)
			position = self.posicionInicial()
	}
	
	method chocar(){
		juego.terminar()
	}
    method detener(){
		game.removeTickEvent("moverPterodactilo")
	}
}

object suelo{
	
	method position() = game.origin().up(1)
	
	method image() = "suelo.png"
}

object puntos {
	
	var puntaje = 0
	
	method text() = puntaje.toString()
	method position() = game.at(6, game.height()-1)
	
	method sumarPuntos() {
		puntaje = reloj.tiempoActual() / 100
	}
}

object dino {
	var vivo = true

	var position = game.at(1,suelo.position().y())
	
	method image() = "dino.png"
	method position() = position
	
	method saltar(){
		if(position.y() == suelo.position().y()) {
			self.subir()
			game.schedule(velocidad*3,{self.bajar()})
		}
	}
	
	method subir(){
		position = position.up(1)
	}
	
	method bajar(){
		position = position.down(1)
	}
	method morir(){
		game.say(self,"¡Auch!")
		vivo = false
	}
	method iniciar() {
		vivo = true
	}
	method estaVivo() {
		return vivo
	}
}