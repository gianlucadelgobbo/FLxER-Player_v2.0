class main.flxerPlayer extends MovieClip {
	// X COSTRUTTORE
	var x:Number;
	var y:Number;
	var w:Number;
	var h:Number;
	var col:Number;
	var toolbar:Boolean;
	var toolbarHead:Number;
	// X AVVIA
	var lista:XML;
	var path:String;
	var att:String;
	var resizza_onoff:Boolean;
	var centra_onoff:Boolean;
	var ss_time:Number;
	var assolvenza:Boolean;
	var downPath:String;
	var info:Boolean;
	// CLASSI
	var flvLoader;
	var mcLoader;
	// MOVIECLIP
	var myToolbar:MovieClip;
	var monitor:MovieClip;
	// INTERNE
	var barr_width:Number;
	var play_status:Boolean;
	var mcLoaded:Boolean;
	var loadedMov;
	var currMov:String;
	var stopper:Number;
	var c:Number;
	var d:Number;
	var e:Number;
	var f:Number;
	var l:Number;
	var n:Number;
	var tipo:String;
	var netStrea1:NetStream;
	var myDuration:Number;
	var myloaded:Boolean;
	var mp3player:Sound;
	var swf_started:Boolean;
	var firstTime:Boolean;
	var myUrl;
	var urlTarget
	//
	function flxerPlayer() {
		this._x = x;
		this._y = y;
		//drawer(this, "fondo", x, y+toolbarHead, w, h, col);
		this.attachMovie("fondo", "fondo", this.getNextHighestDepth());
		this["fondo"]._y = y+toolbarHead;
		this["monitor"].setMask(this["mask"]);
		this.createEmptyMovieClip("monitor", this.getNextHighestDepth());
		this["monitor"]._x = x;
		this["monitor"]._y = y+toolbarHead;
		drawer(this, "mask", x, y+toolbarHead, w, h, col);
		this["monitor"].setMask(this["mask"]);
		if (toolbar) {
			this.attachMovie("toolbar", "myToolbar", this.getNextHighestDepth());
		}
		barr_width = myToolbar.indice.barr._width;
		play_status = false;
	}
	function avvia(obj):Void {
		lista = obj.myXML;
		path = obj.myPath;
		att = obj.myAtt;
		resizza_onoff = obj.myResizza_onoff;
		centra_onoff = obj.myCentra_onoff;
		ss_time = obj.mySs_time;
		assolvenza = obj.myAssolvenza;
		downPath = obj.myDownPath;
		info = obj.myInfo;
		myUrl = obj.myUrl;
		//
		var tmp = lista.childNodes[0].childNodes[0].attributes[att];
		tipo = tmp.substring(tmp.lastIndexOf(".")+1, tmp.length).toLowerCase();
		trace("flxerPlayer "+tipo);
		//monitor.print_layout._visible = false;
		var owner:flxerPlayer = this;
		resetta();
		/* new Sound */
		mp3player = new Sound();
		mp3player.onLoad = function() {
			this.start(0, 10000);
			owner.loadedMov = owner.currMov;
			owner.d = setInterval(owner, "indice_mp3", 30);
		};
		/*/////////////////////////////*/
		myToolbar.fw.onPress = function() {
			this._parent.contr.gotoAndStop(1);
			owner.play_status = false;
			owner["avanti_"+owner.tipo]();
		};
		myToolbar.rw.onPress = function() {
			this._parent.contr.gotoAndStop(1);
			owner.play_status = false;
			owner["indietro_"+owner.tipo]();
		};
		myToolbar.contr.onRelease = function() {
			trace("sssssssss"+owner.tipo);
			clearInterval(owner.stopper);
			owner["stop_play_"+owner.tipo]();
		};
		if (myUrl) {
			if (lista.toString().indexOf("http://www.flxer.net") != -1) {
				urlTarget = "_blank";
				myToolbar.flxer.onRelease = function() {
					var myUrl2 = "http://www.flxer.net";
					getURL(myUrl2, "_blank");
					trace("cazzo "+myUrl2);
				};
			} else {
				urlTarget = "_self";
			}
			monitor.onRelease = function() {
				trace(owner.urlTarget)
				getURL(owner.myUrl, owner.urlTarget);
			};
			this["fondo"].onRelease = function() {
				trace(owner.urlTarget)
				getURL(owner.myUrl, owner.urlTarget);
			};
			myToolbar.flxer.onRollOver = function() {
				this.txt.text = ".net";
			};
			myToolbar.flxer.onRollOut = function() {
				this.txt.text = "player";
			};
		} else {
			this["fondo"].onRelease = function() {
				clearInterval(owner.stopper);
				owner["stop_play_"+owner.tipo]();
			};
			myToolbar.flxer.enabled = false;
		}
		myToolbar.stampa.onRelease = function() {
			owner.monitor.print_layout._visible = true;
			print(owner.monitor, "bmovie");
			owner.monitor.print_layout._visible = false;
		};
		myToolbar.download.onPress = function() {
			getURL(owner.path+owner.downPath+owner.currMov);
		};
		myToolbar.indice.curs.onPress = function() {
			owner.scratch();
			startDrag(this, false, 0, this._y, owner.barr_width, this._y);
		};
		myToolbar.indice.curs.onRelease = function() {
			owner.indice();
			stopDrag();
		};
		myToolbar.indice.curs.onReleaseOutside = function() {
			owner.indice();
			stopDrag();
		};
		myToolbar.volume_ctrl.slider.onPress = function() {
			startDrag(this, false, this._parent.path._x, this._parent.path._y+this._parent.path._height, this._parent.path._x, this._parent.path._y);
			owner.volume_onPress();
		};
		myToolbar.volume_ctrl.slider.onRelease = function() {
			this._parent.prevFrame();
			stopDrag();
			owner.volume_onRelease();
		};
		myToolbar.volume_ctrl.slider.onReleaseOutside = function() {
			this._parent.prevFrame();
			stopDrag();
			owner.volume_onRelease();
		};
		this["avvia_"+tipo]();
	}
	/* IMMAGINI /////////////////*/
	function avvia_jpg() {
		trace("avvia_jpg "+lista.childNodes.length);
		if (lista.childNodes.length>1) {
			//ss = true;
			myToolbar.contr.gotoAndStop(2);
			play_status = true;
		} else {
			//ss = false;
			play_status = false;
		}
		myToolbar.indice.curs.enabled = false;
		myToolbar.contr.enabled = play_status;
		myToolbar.fw.enabled = play_status;
		myToolbar.rw.enabled = play_status;
		load_foto();
	}
	function load_foto() {
		clearInterval(c);
		this["monitor"].createEmptyMovieClip("foto_"+l, this["monitor"].getNextHighestDepth());
		this["monitor"]["foto_"+l]._alpha = 0;
		if (col) {
			drawer(this["monitor"]["foto_"+l], "fondo", 0, 0, w, h, col);
		}
		var tmp = this.lista.childNodes[n].childNodes[0].attributes[att];
		if (tmp.lastIndexOf("mm=") != -1) {
			tmp = tmp.substring(tmp.lastIndexOf("mm=")+3, tmp.length);
		}
		load_jpg_swf(tmp, this["monitor"]["foto_"+l]);
		if (lista.childNodes.length>1) {
			myToolbar.tit = (n+1)+" / "+lista.childNodes.length+" - "+lista.childNodes[this.n].childNodes[0].childNodes[0].toString();
			//myToolbar.descr = lista.childNodes[this.n].childNodes[1];
			myToolbar.indice.curs._x = (((barr_width)/(lista.childNodes.length-1))*n);
			/////////////////
			_parent.pulsa0["puls"+n].puls.onRollOver();
			_parent.pulsa0["puls"+n].puls.enabled = false;
			/////////////////
			l++;
			if (n>lista.childNodes.length-2) {
				n = 0;
			} else {
				n++;
			}
		} else {
			myToolbar.tit = lista.childNodes[this.n].childNodes[0].childNodes[0].toString();
			//myToolbar.descr = lista.childNodes[this.n].childNodes[1];
		}
		myToolbar.lab = myToolbar.tit;
	}
	/* SWF /////////////////*/
	function avvia_swf() {
		//ss = false;
		var tmp = lista.childNodes[0].childNodes[0].attributes[att];
		if (tmp.lastIndexOf("mm=") != -1) {
			tmp = tmp.substring(tmp.lastIndexOf("mm=")+3, tmp.length);
		}
		this["monitor"].createEmptyMovieClip("mon", this["monitor"].getNextHighestDepth());
		load_jpg_swf(tmp, this["monitor"].mon);
		mp3player = new Sound(this.monitor.mon);
		myToolbar.tit = lista.childNodes[0].childNodes[0].childNodes[0].toString();
		//myToolbar.descr = lista.childNodes[0].childNodes[0].childNodes[0].childNodes[1];
		myToolbar.lab = myToolbar.tit;
		n++;
	}
	/* JPG / SWF /////////////////*/
	function load_jpg_swf(mov, trgt) {
		trgt.mcl = new main.mcLoader(this.path+mov, trgt, this, "MovieClipLoader_succes", "MovieClipLoader_progress");
		//my_mcl.loadClip(this.path+mov, trgt);
		currMov = mov;
	}
	function MovieClipLoader_progress(target_mc, loadedBytes, totalBytes) {
		if (info) {
			myToolbar.lab = myToolbar.tit+"   (size: "+int(loadedBytes/1024)+" Kb / "+int(totalBytes/1024)+" Kb )";
		} else {
			myToolbar.lab = myToolbar.tit;
		}
		myToolbar.indice.barr._width = barr_width*(loadedBytes/totalBytes);
		if (tipo == "swf" && loadedBytes/totalBytes>0.1 && swf_started == false) {
			resizza(target_mc);
			myToolbar.contr.gotoAndStop(2);
			swf_started = true;
			d = setInterval(this, "indice_swf", 30);
			play_status = true;
			if (firstTime) {
				stopper = setInterval(this, "stoppa", 500);
			} else {
				target_mc.play();
			}
			firstTime = false;
		}
	}
	function stoppa() {
		trace("ooooooooooooooooo");
		myToolbar.contr.onRelease();
	}
	function MovieClipLoader_succes(target_mc) {
		loadedMov = currMov;
		mcLoaded = true;
		resizza(target_mc);
		if (tipo == "swf" && swf_started == false) {
			play_status = true;
			myToolbar.contr.gotoAndStop(2);
			swf_started = true;
			d = setInterval(this, "indice_swf", 30);
			if (firstTime) {
				stopper = setInterval(this, "stoppa", 500);
			} else {
				target_mc.play();
			}
			firstTime = false;
		}
		if (assolvenza && tipo == "jpg") {
			target_mc._parent.myTween = new main.myTween(target_mc._parent, "_alpha", mx.transitions.easing.Regular.easeIn, 0, 100, 10, this, "loadNext");
			//trace(l+"bingoooooooooooooooo"+target_mc);
			if (l>1) {
				//trace(l+"bingoooooooooooooooo"+target_mc._parent._parent["foto_"+(l-2)]);
				target_mc._parent._parent["foto_"+(l-2)].myTween = new main.myTween(target_mc._parent._parent["foto_"+(l-2)], "_alpha", mx.transitions.easing.Regular.easeIn, 100, 0, 10, this, "removePrev");
			}
		} else {
			target_mc._parent.mask.gotoAndPlay(2);
			if (l>1) {
				target_mc._parent._parent["foto_"+(l-2)].mask.gotoAndPlay(31);
			}
		}
		if (info) {
			myToolbar.lab = myToolbar.tit+"   (size: "+int(target_mc.getBytesTotal()/1024)+" Kb / W: "+target_mc._width+" px / H: "+target_mc._height+" px)";
		} else {
			myToolbar.lab = myToolbar.tit;
		}
	}
	function loadNext() {
		if (play_status) {
			c = setInterval(this, "load_foto", ss_time);
		}
	}
	function removePrev(target_mc) {
		target_mc.removeMovieClip();
	}
	/* MP3 /////////////////*/
	function avvia_mp3() {
		myToolbar.tit = lista.childNodes[0].childNodes[0].childNodes[0];
		myToolbar.lab = myToolbar.tit;
		var tmp = lista.childNodes[0].childNodes[0].childNodes[0].attributes[att];
		//descr = lista.childNodes[0].childNodes[0].childNodes[1];
		load_mp3(tmp.substring(tmp.lastIndexOf("mm=")+3, tmp.length));
	}
	function load_mp3(mov) {
		mp3player.loadSound(path+mov, false);
		currMov = mov;
		play_status = true;
		myToolbar.contr.gotoAndStop(2);
	}
	/* FLV /////////////////*/
	function avvia_flv() {
		resizza(monitor.video.vid_flv);
		myToolbar.fw.enabled = false;
		myToolbar.tit = lista.childNodes[0].childNodes[0].toString();
		myToolbar.lab = myToolbar.tit+": Buffering...";
		var tmp = lista.childNodes[0].childNodes[0].attributes[att];
		if (tmp.lastIndexOf("mm=") != -1) {
			tmp = tmp.substring(tmp.lastIndexOf("mm=")+3, tmp.length);
		}
		load_flv(tmp);
		//descr = lista.childNodes[0].childNodes[0].childNodes[1];
	}
	function load_flv(mov) {
		d = 0;
		trace(path+mov);
		flvLoader = new main.flvLoader(path+mov, this["monitor"], this, "netStrea1", 5, null);
		//trace("avviaavviaavviaavviaavviaavvia "+path+mov);
		currMov = mov;
		mp3player = new Sound(this["monitor"].video.vid_flv._parent);
	}
	/* TOOLS /////////////////*/
	function volume_onPress() {
		f = setInterval(this, "MySetVolume", 30);
	}
	function volume_onRelease() {
		clearInterval(f);
	}
	function scratch() {
		netStrea1.pause(true);
		clearInterval(d);
		e = setInterval(this, "scratch_"+tipo, 30);
		mp3player.stop();
	}
	function indice() {
		clearInterval(e);
		d = setInterval(this, "indice_"+tipo, 30);
		monitor.mon.play();
		netStrea1.pause(false);
		mp3player.start(int((myToolbar.indice.curs._x/barr_width)*mp3player.duration/1000));
		mp3player.onSoundComplete = function() {
			this.start(0, 10000);
		};
		myToolbar.contr.gotoAndStop(2);
	}
	function avanti_swf() {
		monitor.mon.gotoAndStop(monitor.mon._totalframes);
		myToolbar.contr.gotoAndStop(1);
	}
	function avanti_mp3() {
		mp3player.stop();
		mp3player.start((mp3player.duration/1000)-0.1);
		mp3player.stop();
	}
	function avanti_jpg() {
		clearInterval(c);
		play_status = false;
		c = 0;
		if (lista.childNodes.length>1) {
			if (n<lista.childNodes.length-1) {
				load_foto();
			}
		}
	}
	function indietro_flv() {
		netStrea1.seek(0);
		netStrea1.pause();
	}
	function indietro_swf() {
		monitor.mon.gotoAndStop(1);
		//myToolbar.contr.gotoAndStop(1);
	}
	function indietro_mp3() {
		mp3player.stop();
		mp3player.start(0, 10000);
		//myToolbar.contr.gotoAndStop(2);
	}
	function indietro_jpg() {
		clearInterval(c);
		//play_status = false;
		if (lista.childNodes.length>1) {
			if (n>1) {
				n -= 2;
				load_foto();
			}
		}
	}
	function stop_play_flv() {
		trace(loadedMov);
		if (play_status) {
			myToolbar.contr.gotoAndStop(1);
			play_status = false;
			if (firstTime) {
				netStrea1.close();
				firstTime = false;
			} else {
				netStrea1.pause(true);
			}
		} else {
			myToolbar.contr.gotoAndStop(2);
			play_status = true;
			netStrea1.pause(false);
			if (loadedMov) {
				netStrea1.play(path+currMov);
				loadedMov = false;
			}
		}
	}
	function stop_play_jpg() {
		if (play_status) {
			myToolbar.contr.gotoAndStop(1);
			clearInterval(c);
			play_status = false;
		} else {
			myToolbar.contr.gotoAndStop(2);
			load_foto();
			play_status = true;
		}
	}
	function stoppaSwf(trgt, fnz) {
		trgt[fnz]();
		for (var item in trgt) {
			stoppaSwf(trgt[item], fnz);
		}
	}
	function stop_play_swf() {
		if (play_status) {
			myToolbar.contr.gotoAndStop(1);
			stoppaSwf(this.monitor.mon.trgt, "stop");
			play_status = false;
		} else {
			trace("stop_play_swfstop_play_swfstop_play_swfstop_play_swf");
			myToolbar.contr.gotoAndStop(2);
			stoppaSwf(this.monitor.mon.trgt, "play");
			play_status = true;
		}
	}
	function stop_play_mp3() {
		if (play_status) {
			myToolbar.contr.gotoAndStop(1);
			mp3player.stop();
			play_status = false;
		} else {
			myToolbar.contr.gotoAndStop(2);
			if (mp3player.duration != mp3player.position) {
				mp3player.start(mp3player.position/1000);
				mp3player.onSoundComplete = function() {
					this.start(0, 10000);
				};
			} else {
				mp3player.start(0, 10000);
			}
			play_status = true;
		}
	}
	function indice_swf() {
		myToolbar.indice.curs._x = (barr_width)*(monitor.mon._currentframe/monitor.mon._totalframes);
	}
	function indice_mp3() {
		if (mp3player.getBytesLoaded()<mp3player.getBytesTotal()) {
			myToolbar.lab = myToolbar.tit+": Playing "+int((mp3player.position/1000)/60)+"."+(int(mp3player.position/1000)-(int((mp3player.position/1000)/60)*60))+" / "+int((mp3player.duration/1000)/60)+"."+(int(mp3player.duration/1000)-(int((mp3player.duration/1000)/60)*60))+" min. (Size: "+int(mp3player.getBytesLoaded()/1024)+" / "+int(mp3player.getBytesTotal()/1024)+" Kb )";
			myToolbar.indice.barr._width = barr_width*(netStrea1.bytesLoaded/netStrea1.bytesTotal);
		} else if (mp3player.getBytesLoaded() == mp3player.getBytesTotal() && myloaded == false) {
			myloaded = true;
			myToolbar.indice.barr._width = barr_width;
		} else {
			myToolbar.lab = myToolbar.tit+": Playing "+int((mp3player.position/1000)/60)+"."+(int(mp3player.position/1000)-(int((mp3player.position/1000)/60)*60))+" / "+int((mp3player.duration/1000)/60)+"."+(int(mp3player.duration/1000)-(int((mp3player.duration/1000)/60)*60))+" min. (Size: "+int(mp3player.getBytesTotal()/1024)+" Kb )";
		}
		myToolbar.indice.curs._x = (barr_width)*(mp3player.position/mp3player.duration);
	}
	function indice_flv() {
		if (myDuration != undefined) {
			if (netStrea1.bytesLoaded<netStrea1.bytesTotal) {
				if (info) {
					myToolbar.lab = myToolbar.tit+": Playing "+netStrea1.time+" / "+myDuration+" sec. (Size: "+int(netStrea1.bytesLoaded/1024)+" / "+int(netStrea1.bytesTotal/1024)+" Kb W:"+monitor.video.vid_flv.width+" Kb H:"+monitor.video.vid_flv.height+" )";
				} else {
					myToolbar.lab = myToolbar.tit+": Playing "+netStrea1.time+" / "+myDuration+" sec.";
				}
				myToolbar.indice.barr._width = barr_width*(netStrea1.bytesLoaded/netStrea1.bytesTotal);
			} else if (netStrea1.bytesLoaded == netStrea1.bytesTotal && myloaded == false) {
				myloaded = true;
				myToolbar.indice.barr._width = barr_width;
			} else {
				if (info) {
					myToolbar.lab = myToolbar.tit+": Playing "+netStrea1.time+" / "+myDuration+" sec. (Size: "+int(netStrea1.bytesTotal/1024)+" Kb W:"+monitor.video.vid_flv.width+" Kb H:"+monitor.video.vid_flv.height+" )";
				} else {
					myToolbar.lab = myToolbar.tit+": Playing "+netStrea1.time+" / "+myDuration+" sec.";
				}
			}
			myToolbar.indice.curs._x = (barr_width)*(netStrea1.time/myDuration);
			myToolbar.indice.path._width = myToolbar.indice.curs._x;
		} else {
			if (netStrea1.bytesLoaded<netStrea1.bytesTotal) {
				if (info) {
					myToolbar.lab = myToolbar.tit+": Playing "+netStrea1.time+" sec. (Size: "+int(netStrea1.bytesLoaded/1024)+" / "+int(netStrea1.bytesTotal/1024)+" Kb W:"+monitor.video.vid_flv.width+" Kb H:"+monitor.video.vid_flv.height+" )";
				} else {
					myToolbar.lab = myToolbar.tit+": Playing "+netStrea1.time+" sec.";
				}
				myToolbar.indice.barr._width = barr_width*(netStrea1.bytesLoaded/netStrea1.bytesTotal);
			} else if (netStrea1.bytesLoaded == netStrea1.bytesTotal && myloaded == false) {
				myloaded = true;
				myToolbar.indice.barr._width = barr_width;
			} else {
				if (info) {
					myToolbar.lab = myToolbar.tit+": Playing "+netStrea1.time+" sec. (Size: "+int(netStrea1.bytesTotal/1024)+" Kb W:"+monitor.video.vid_flv.width+" Kb H:"+monitor.video.vid_flv.height+" )";
				} else {
					myToolbar.lab = myToolbar.tit+": Playing "+netStrea1.time+" sec.";
				}
			}
			myToolbar.indice.curs._x = 0;
			myToolbar.indice.curs.enabled = false;
		}
	}
	function scratch_swf() {
		monitor.mon.gotoAndStop(int((myToolbar.indice.curs._x/(barr_width))*monitor.mon._totalframes));
	}
	function scratch_mp3() {
		mp3player.position = (int((myToolbar.indice.curs._x/(barr_width))*mp3player.duration));
	}
	function scratch_flv() {
		netStrea1.seek(((myToolbar.indice.curs._x/(barr_width))*myDuration));
	}
	function MySetVolume() {
		mp3player.setVolume(-(myToolbar.volume_ctrl.slider._y+10));
	}
	function resetta() {
		myloaded = false;
		swf_started = false;
		myToolbar.fw.enabled = true;
		myToolbar.rw.enabled = true;
		myToolbar.indice.curs._x = 0;
		myToolbar.contr.enabled = true;
		myToolbar.contr.gotoAndStop(1);
		myToolbar.indice.curs.enabled = true;
		play_status = false;
		l = 0;
		n = 0;
		clearInterval(c);
		clearInterval(d);
		netStrea1.close();
		mp3player.stop();
		monitor.video.vid_flv.clear();
		if (mcLoaded) {
			//my_mcl.unloadClip(this.monitor.mon);
			mcLoaded = !mcLoaded;
		}
		/**/ 
		trace("+++++++++++++++++++++++++++++");
		for (var item in this.monitor) {
			delete this.monitor[item].myListener;
			delete this.monitor[item].myMcl;
			trace(this.monitor[item].myTweena.onMotionFinished);
			delete this.monitor[item].myTweena.onMotionFinished;
			this.monitor[item].removeMovieClip();
			/**/
		}
		trace("+++++++++++++++++++++++++++++");
	}
	function resizza(trgt) {
		if (tipo == "flv") {
			trgt._width = trgt.width;
			trgt._height = trgt.height;
		}
		if (resizza_onoff) {
			if ((trgt._width/trgt._height)>(w/h)) {
				trgt._width = w;
				trgt._yscale = trgt._xscale;
			} else {
				trgt._height = h;
				trgt._xscale = trgt._yscale;
			}
		}
		if (centra_onoff) {
			trgt._x = (w-trgt._width)/2;
			trgt._y = (h-trgt._height)/2;
		}
	}
	function drawer(trgt, myName, x, y, w, h, col) {
		trgt.createEmptyMovieClip(myName, trgt.getNextHighestDepth());
		with (trgt[myName]) {
			if (col != null) {
				beginFill(col, 100);
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
}
