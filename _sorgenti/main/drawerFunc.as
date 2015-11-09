class main.drawerFunc extends MovieClip {
	var txt:TextFormat;
	var colTvBig:TextFormat;
	var colFocusBig:TextFormat;
	var colClubBig:TextFormat;
	var colFocusH:TextFormat;
	var colClub:TextFormat;
	var colClubH:TextFormat;
	var colTv:TextFormat;
	var colFocus:TextFormat;
	var colFocusS:TextFormat;
	var colFocusMain:TextFormat;
	var calDay:TextFormat;
	var calDayW:TextFormat;
	var colAcc:TextFormat;
	var colServ:TextFormat;
	var nero:TextFormat;
	var hi:TextFormat;
	var myFormFields:TextFormat;
	var myFormFieldsPrivacy:TextFormat;
	var myT;
	var myT1;
	var myT2;
	var myT3;
	//
	function drawerFunc() {
	}
	function textDrawer(trgt, myName, txt, x, y, w, h, ss, sel) {
		trgt.createEmptyMovieClip(myName, trgt.getNextHighestDepth());
		trgt[myName]._x = x;
		trgt[myName]._y = y;
		if (h == null) {
			var hh = 30;
		} else {
			var hh = h;
		}
		trgt[myName].createEmptyMovieClip("myText", trgt.getNextHighestDepth());
		trgt[myName]["myText"].createTextField("myText", trgt.getNextHighestDepth(), 0, 0, w, hh+3);
		trgt[myName]["myText"]._alpha = 0;
		with (trgt[myName]["myText"]["myText"]) {
			background = false;
			//border = true;
			html = true;
			multiline = true;
			selectable = sel;
			wordWrap = true;
			embedFonts = true;
			styleSheet = ss;
			htmlText = txt;
		}
		trgt[myName].abilitaRoll = true;
		var css = txt.attributes["class"];
		if (trgt[myName]["myText"]["myText"].textHeight+3<hh-3 && ss._css["."+txt.attributes["class"]+"2"] != undefined) {
			txt.attributes["class"] = txt.attributes["class"]+"2";
			trgt[myName]["myText"]["myText"].htmlText = txt;
		}
		if (trgt[myName]["myText"]["myText"].textHeight+3>hh+3) {
			txt.attributes["class"] = css;
		}
		if (h == null) {
			trgt[myName]["myText"]["myText"]._height = trgt[myName]["myText"]["myText"].textHeight+5;
		}
		trgt[myName]["scrivi"] = function (newText) {
			if (trgt[myName].abilitaRoll) {
				trgt[myName].abilitaRoll = false;
				trgt[myName].c = setInterval(trgt[myName], "writer", random(1000), newText);
			}
		};
		if (ss._css["."+txt.attributes["class"]].color) {
			//trgt[myName]["riRiScrivi"](txt);
			_root.myDrawerFunc.drawer(trgt[myName], "fondo", 0, 0, 1, h, ss._css["."+txt.attributes["class"]].color, null, 100);
			trgt[myName]["fondo"]._visible = false;
			//_root.myDrawerFunc.drawer(trgt[myName], "mask", 0, 0, 1, h, 0xFFFFFF, null, 100);
			//trgt[myName]["myText"].setMask(trgt[myName]["mask"]);
			trgt[myName].scrivi(txt);
		} else {
			trgt[myName]["myText"]._alpha = 100;
		}
		trgt[myName]["writer"] = function (newText) {
			trgt[myName]["myText"].newText = newText;
			clearInterval(trgt[myName].c);
			trgt[myName]["fondo"]._visible = true;
			trgt[myName].myT1 = new main.myTween(trgt[myName]["fondo"], "_width", mx.transitions.easing.Strong.easeIn, 1, w, 8, this, "avvia_");
			trgt[myName].myT2 = new main.myTween(trgt[myName]["fondo"], "_x", mx.transitions.easing.Strong.easeIn, w, 1, 8, this, "avvia");
			//trgt[myName].myT3 = new main.myTween(trgt[myName]["mask"], "_width", mx.transitions.easing.Strong.easeIn, w, 1, 8, this, "avvia");
		};
		trgt[myName]["avvia"] = function () {
			trgt[myName]["myText"]["myText"].htmlText = trgt[myName]["myText"].newText;
			trgt[myName]["myText"]._alpha = 100;
			trgt[myName]["fondo"]._visible = false;
			trgt[myName].myT1 = new main.myTween(trgt[myName]["fondo"], "_width", mx.transitions.easing.Strong.easeIn, w, 1, 8, this, "avvia_");
			trgt[myName].myT2 = new main.myTween(trgt[myName]["fondo"], "_x", mx.transitions.easing.Strong.easeIn, 0, w, 8, this, "abilita");
			//trgt[myName].myT3 = new main.myTween(trgt[myName]["mask"], "_width", mx.transitions.easing.Strong.easeIn, 1, w, 8, this, "abilita");
		};
		trgt[myName]["abilita"] = function (newText) {
			trgt[myName].abilitaRoll = true;
		};
	}

	function drawer(trgt, myName, x, y, w, h, col, o_col, alpha) {
		trgt.createEmptyMovieClip(myName, trgt.getNextHighestDepth());
		if (alpha == undefined) {
			alpha = 100;
		}
		with (trgt[myName]) {
			if (o_col != null) {
				lineStyle(0, o_col, alpha);
			}
			if (col != null) {
				beginFill(col, alpha);
			}
			moveTo(0, 0);
			lineTo(w, 0);
			lineTo(w, h);
			lineTo(0, h);
			lineTo(0, 0);
			_x = x;
			_y = y;
		}
	}
	function arrow_drawer(trgt, myName, col, w, h) {
		trgt.createEmptyMovieClip(myName, trgt.getNextHighestDepth());
		with (trgt[myName]) {
			if (col != null) {
				beginFill(col, 100);
			}
			moveTo(-w/2, -h/2);
			lineTo(w/2, 0);
			lineTo(-w/2, h/2);
			lineTo(-w/2, -h/2);
		}
	}
	function txt_drawer(trgt, myName, x, y, txt, myStyle) {
		trgt.createTextField(myName, trgt.getNextHighestDepth(), 0, 0, 200, 200);
		trgt[myName]._y = y;
		trgt[myName]._x = x;
		with (trgt[myName]) {
			background = false;
			html = false;
			multiline = false;
			selectable = false;
			wordWrap = false;
			embedFonts = true;
			text = txt;
			setTextFormat(myStyle);
			setNewTextFormat(myStyle);
			_width = textWidth+9;
			_height = textHeight+5;
		}
	}
}
