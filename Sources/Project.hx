package;

import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import mphx.client.Client;

class Project {
	var self:Person;
	var people = new Map<Int,Person>();
	var trees:Array<Tree> = [];
	var clientSocket:Client;
	var selfid = 0;

	var ip = "127.0.0.1";

	public function new() {
		System.notifyOnRender(render);
		Scheduler.addTimeTask(update, 0, 1 / 60);
		clientSocket = new Client(ip, 8383);
		clientSocket.events.on("join",function (data){
			people.set(data,new Person("planter."));
		});
		clientSocket.events.on("assignid",function (data){
			self = new Person("Me.");
			selfid = data;
			people.set(data,self);
		});
		clientSocket.events.on("move",function (data){
			if (data.id == selfid) return;
			if (people.exists(data.id) == false){
				var p = new Person("planter.");
				p.x = data.x;
				people.set(data.id,p);
			}
			people.get(data.id).x = data.x;
		});
		clientSocket.events.on("exit",function (data){
			people.remove(data);
		});
		clientSocket.events.on("plant",function (data){
			trees.push(new Tree(data.x,data.name));
		});
		clientSocket.connect();
		clientSocket.send("join");

		kha.input.Keyboard.get().notify(kdown,kup);

		
	}

	function update(): Void {
		
	}

	function render(framebuffer: Framebuffer): Void {
		var g = framebuffer.g2;
		g.begin(true,kha.Color.fromBytes(92, 192, 249));
		g.pushTransformation(kha.math.FastMatrix3.scale(4,4));
		for (tree in trees)
			tree.render(g);
		for (person in people)
			person.render(g);
		g.end();
		g.popTransformation();

		if (selfid == 0) return;
		if (people.get(selfid).movingLeft || people.get(selfid).movingRight)
			clientSocket.send("move",people.get(selfid).x);
	}
	function plantTree(x,name){
		clientSocket.send("plant",{name:"tree",x:x});
	}

	function kdown(key:kha.Key,char:String){
		if (selfid == 0) return;
		var me = people.get(selfid);

		if (char=="a"){
			me.movingLeft = true;
		}
		if (char=="d"){
			me.movingRight = true;
		}
		if (char == " "){
			plantTree(Math.floor(me.x),me.name);	
		}
	}
	function kup(key:kha.Key,char:String){
		if (selfid == 0) return;
		var me = people.get(selfid);
		if (char=="a"){
			me.movingLeft = false;
		}
		if (char=="d"){
			me.movingRight = false;
		}
	}
}
