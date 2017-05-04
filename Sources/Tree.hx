package ;

class Tree {
	public var x:Float = 30;
	public var name:String;
	var leaf:kha.Color;
	var stem:kha.Color;
	var tid:Int;
	public function new (x:Int,name:String){
		this.x = x;
		this.name = name;
		tid = Math.floor(Math.random()*16);
	}
	public function render(g:kha.graphics2.Graphics){
		
		g.drawSubImage(kha.Assets.images.trees,x,(kha.System.windowHeight())/4 - (32),tid*16,0,16,32);
		
	}
}