class starter extends MovieClip {
	var c:Number;
	var owner:starter;
	var myListener:Object;
	var bella:Number = 0;
	///////
	function starter() {
		//System.useCodepage = true;
		Stage.showMenu = false;
		Stage.scaleMode = "noScale";
		Stage.align = "TL";
		System.security.allowDomain("www.flxer.net");
		_root.myPath = "";
		_root.myFolder = "";
		// LOCAL TEST ///////////////
		////////
		// FLxER
		_root.myDownPath = "/_class/mediaDownload.php?mm="
		// A1
		//_root.myDownPath = "/download.php?file=";
		if (!_root.avvia_con) {
			//_root.myPath = "";
			//_root.avvia_con = "ferro.flv,bella";
			_root.myPath = "http://www.flxer.net";
			_root.avvia_con = "/warehouse/_flxer/library/no_hole/fastpeople.swf,FastPeople";
			// A1
			//_root.myPath = "";
			//_root.myFolder = "";
		}
		///////////////// 
		_root.myDrawerFunc = new main.drawerFunc();
		_root.myClassedMC = function(classe, trgt, myName, obj) {
			Object.registerClass("empty", classe);
			trgt.attachMovie("empty", myName, trgt.getNextHighestDepth(), obj);
		};
		var tmp = _root.avvia_con.split(",");
		_root.myClassedMC(main.flxerPlayer, _root, "mySuperplayer", {x:0, y:0, w:400, h:300, firstTime:parseInt(tmp[2]), toolbar:true, toolbarHead:18, col:0x000000});
		var tmp = _root.avvia_con.split(",")[0];
		if (tmp.substring(tmp.length-4, tmp.length) == ".xml" || tmp.substring(tmp.length-4, tmp.length) == ".htm") {
			_root.myXMLloader = new main.xmlLoader(_root.myPath+_root.avvia_con, _root, "home", this, "startup");
		} else if (_root.avvia_con.length>4) {
			avvia(_root.avvia_con);
		}
	}
	function avviaSuperplayer(myXml, myUrl) {
		if (myXml.toString().indexOf(".swf") != -1) {
			var onoff = false;
		} else {
			var onoff = true;
		}
		var onoff = false;
		trace("avviaSuperplayer"+myUrl);
		if (myUrl) {
			_root["mySuperplayer"].avvia({myUrl:myUrl, myXML:myXml, myPath:_root.myPath, myResizza_onoff:onoff, myCentra_onoff:false, mySs_time:3000, myAssolvenza:true, myInfo:false, myDownPath:_root.myDownPath, myAtt:"href"});
		} else {
			trace("noLink");
			_root["mySuperplayer"].avvia({myXML:myXml, myPath:_root.myPath, myResizza_onoff:onoff, myCentra_onoff:false, mySs_time:3000, myAssolvenza:true, myInfo:false, myDownPath:_root.myDownPath, myAtt:"href"});
		}
	}
	function avvia(avvia_con) {
		var tmp = avvia_con.split(",");
		var tmpXml = new XML("<ul><li><a>"+tmp[1]+"</a></li></ul>");
		tmpXml.childNodes[0].childNodes[0].childNodes[0].attributes.href = "/mediaViewer.php?mm="+tmp[0];
		if (tmp[3] && tmp[2] == "1") {
			avviaSuperplayer(tmpXml.childNodes[0], "http://www.flxer.net/abusers/?userId="+tmp[3]+"&postId="+tmp[4]+"&pageItem=1");
		} else {
			avviaSuperplayer(tmpXml.childNodes[0], undefined);
		}
	}
	function startup(myXml) {
		avviaSuperplayer(myXml.childNodes[0].childNodes[0]);
	}
}
