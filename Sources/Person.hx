package ;

class Person {
	public var x:Float = 30;
	public var movingLeft = false;
	public var movingRight = false;
	public var name:String;
	var tid:Int;
	public function new (name:String){
		this.name = name;
		tid = Math.floor(Math.random()*7);
	}
	public function render(g:kha.graphics2.Graphics){
		
		g.drawSubImage(kha.Assets.images.people,x,(kha.System.windowHeight())/4 - (8),tid*8,0,8,8);
		

		if (movingLeft)
			x-=1;
		if (movingRight)
			x+=1;
	}
}