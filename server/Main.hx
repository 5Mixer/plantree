package ;
import mphx.connection.IConnection;
import mphx.server.impl.FlashServer; //Use if hosting flash policy files.
import mphx.server.impl.Server;
import mphx.server.room.Room;

class Main {
	public function new (){
		//Allow the changing of the server host IP through a command line argument.
		var ip = "127.0.0.1";
		if (Sys.args()[0] != null) ip = Sys.args()[0];

		//var s = new FlashServer(ip, 8000); // use this if you use a flash connection (using an policy files servers for flash socket)
		var s = new FlashServer(ip, 8383);

		s.onConnectionAccepted = onConnectOrDisconnect;
		s.onConnectionClose = onConnectOrDisconnect;

		//Room allow grouping of connections to allow for group specific messaging. Useful for chat room/game seperation.
		var room = new Room();
		//Register the room with the server.
		s.rooms.push(room);

		s.events.on("join",function(data:Dynamic,sender:mphx.connection.IConnection){
			var id = Math.floor(Math.random()*999999);
			sender.data = {id:id,x:0};
			sender.send("assignid",id);
			s.broadcast("join",id);

		});
		s.events.on("move",function(data:Dynamic,sender:mphx.connection.IConnection){
			sender.data.x = data;
			s.broadcast("move",{id:sender.data.id,x:data});
		});
		s.events.on("plant",function(data:Dynamic,sender:mphx.connection.IConnection){
			s.broadcast("plant",{name:data.name,x:data.x});
		});

		s.onConnectionClose = function (reason, connection:IConnection){
			trace("Goodbye planter");
			// s.broadcast("exit",connection.data.id);
		}


		//Start the server. Connections won't actually be accepted until start is called.
		s.start();
	}

	private function onConnectOrDisconnect(info : String, cnx : IConnection) : Void
	{
		trace(info);
	}

	public static function main (){
		new Main();
	}
}