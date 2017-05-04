package;

import kha.System;

class Main {
	public static function main() {
		System.init({title: "Project", width: 800, height: 140}, function () {
			kha.Assets.loadEverything(function (){
				new Project();
			});
		});
	}
}
